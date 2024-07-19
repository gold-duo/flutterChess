
import 'package:chess/component/piece_move_effect.dart';
import 'package:chess/component/repeat_fade_widget.dart';
import 'package:chess/extensions/widget_extensions.dart';
import 'package:chess/utils/Audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chess/motion.dart';
import '../chess/bot.dart';
import '../chess/piece.dart';
import '../chess/engine.dart';
import '../chess/chess_theme.dart';
import '../extensions/provider_extensions.dart';
import '../extensions/collection_extensions.dart';
import 'chess_controller.dart';

typedef ChessboardUpdated=void Function(bool canBack);
class Chessboard extends StatefulWidget{
  final ChessTheme chessTheme;
  final ChessController? chessController;
  final ChessboardUpdated? onChessboardUpdated;
  final GameStartCallback? onGameStart;
  final GameOverCallback? onGameOver;
  //theme外部可以修改,局部刷新
  //难度外部可以修改，局部刷新
  const Chessboard({super.key, required this.chessTheme, this.chessController, this.onChessboardUpdated, this.onGameStart, this.onGameOver});
  @override
  State<StatefulWidget> createState() =>_Chessboard();
}
typedef EngineNotifier= ValueNotifierEx<Engine>;
class _Chessboard extends State<Chessboard>{
  static const dbg=!false;//kDebugMode;
  static const tag = '[Chess.Chessboard]';

  late final  Engine _engine;
  late EngineNotifier _engineNotifier;
  Motion _lastMotion = invalidMotion;

  @override
  Widget build(BuildContext context) {
    
    final Widget child;
    if(_engine.pieceMap.isEmpty){
      child= context.loadingView();
    } else {
      child = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => _engineNotifier),
          ProxyProvider<EngineNotifier, Motion>(
              update: (ctx, model, previous) => _lastMotion),
          ProxyProvider<EngineNotifier, Map<int,Piece>>(
              update: (ctx, model, previous) => model.get.pieceMap),
          ProxyProvider<EngineNotifier, List<AxisXY>>(
              update: (ctx, model,List<AxisXY>? previous) =>
              model.get.guideSteps ?? List.empty(growable: false)),
        ],
        child: Container(
          width: widget.chessTheme.width,
          height: widget.chessTheme.height,
          decoration: _background(),
          child: Stack(
            children: [
              _buildPieceMoveEffect(),
              GestureDetector(
                  onTapUp: _onTapUp,
                  behavior: HitTestBehavior.opaque, 
                  child: _buildPieces(context)),
              _buildGuides()
            ],
          ),
        ),
      );
    }
    return child;
  }

  void _onTapUp(TapUpDetails details){
    if(_engineNotifier.get.isBotThinking){
      context.showSnackBar("机器人脑子笨还在思考呢！");
      return;
    }
    final theme=widget.chessTheme;
    final x = (details.localPosition.dx - theme.offsetX) ~/ theme.pieceWidth;
    final y = (details.localPosition.dy - theme.offsetY) ~/ theme.pieceHeight;
    if (x > 8 || y > 9 || x < 0 || y < 0) return;
    _engineNotifier.get.play(x,y);
  }

  Decoration _background()=> BoxDecoration(color: Color(widget.chessTheme.bgColor), image: DecorationImage(image:AssetImage('${widget.chessTheme.path}board.png'),fit: BoxFit.fill));

  Widget _buildPieces(BuildContext context) =>Consumer<Map<int, Piece>>(
      builder: (context, map, child) =>  Stack(
          children: map.keys
              .map2List((key) => Selector<EngineNotifier, int>(
            builder: (context, mask, child) {
              final piece =Piece.rawValue(mask); //不能直接传Piece对象，对象赋值是引用原来的修改也会导致同步修改
              
              
              Widget child = Image.asset(
                '${widget.chessTheme.path}${piece.img}.png',
                fit: BoxFit.contain,
                width: widget.chessTheme.pieceWidth,
                height: widget.chessTheme.pieceHeight,
              );
              if (piece.isSelected) child = RepeatFadeWidget(begin: 0.4, child: child);
              return AnimatedPositioned(
                  duration: const Duration(milliseconds: 888),
                  left: _getPieceLeft(piece.x),
                  top: _getPieceTop(piece.y),
                  child: Offstage(
                    offstage: piece.isKilled, child: child,
                  ));
            },
            selector: (ctx, model) =>  model.get.pieceMap[key]?.rawValue ?? -1, //不能直接传Piece对象，对象赋值是引用原来的修改也会导致同步修改
          ))));

  Widget _buildPieceMoveEffect() =>Consumer<Motion>(builder: (BuildContext context, Motion move, Widget? child) {
    
    Widget ret;
    if (move!=invalidMotion) {
      double fromX = 0;
      double fromY = 0;
      if (move.oldX!=invalidMotionX && move.oldY!=invalidMotionY) {
        fromX = _getPieceLeft(move.oldX);
        fromY = _getPieceTop(move.oldY);
      }
      double toX = 0;
      double toY = 0;
      if (move.newX!=invalidMotionX && move.newY!=invalidMotionY) {
        toX = _getPieceLeft(move.newX);
        toY = _getPieceTop(move.newY);
      }
      
      ret = Stack(children: [
        PieceMoveEffect(
            width: widget.chessTheme.pieceWidth,
            height: widget.chessTheme.pieceHeight,
            fromX: fromX,
            fromY: fromY,
            toX: toX,
            toY: toY,
            chessTheme: widget.chessTheme)
      ]);
    }else {
      ret=const Positioned(child: Offstage(offstage: true,));
    }
    return ret;
  });

  Widget _buildGuides() {
    double getGuidesLeft(int x) {
      final t=widget.chessTheme;
      return t.offsetX + t.pieceWidth * x + (t.pieceWidth - t.guideWidth) / 2;
    }
    double getGuidesTop(int y) {
      final t=widget.chessTheme;
      return t.offsetY + t.pieceHeight * y +(t.pieceHeight - t.guideHeight) / 2;
    }
    return Consumer<List<AxisXY>>(builder: (BuildContext context, List<int> value, Widget? child) => IgnorePointer(
        child: Stack(
          children: value.map2List((it) => Positioned(
              left: getGuidesLeft(it.x),
              top: getGuidesTop(it.y),
              child: RepeatFadeWidget(
                child: Container(
                  width: widget.chessTheme.guideWidth,
                  height: widget.chessTheme.guideHeight,
                  decoration: BoxDecoration(
                      color: Color(widget.chessTheme.guideColor),
                      borderRadius: BorderRadius.circular((widget.chessTheme.guideHeight +  widget.chessTheme.guideWidth) / 4)),
                ),
              ))),
        )));
  }

  void _onBoardUpdated(UpdateType showType,Motion motion) {
    _lastMotion=invalidMotion;
    switch(showType){
      case UpdateType.move:
        _lastMotion=motion;
        Audio.play(Audio.move);
      case UpdateType.eat:
        _lastMotion=motion;
        Audio.play(Audio.eat);
      case UpdateType.select:
        Audio.play(Audio.select);
      case UpdateType.none:{}
    }
    _engineNotifier.markDirty();
    widget.onChessboardUpdated?.call(_engineNotifier.get.canBack);
  }
  void _onGameStart(bool restart){
    if(restart){
      _lastMotion=invalidMotion;
      _engineNotifier.markDirty();
    }else {
      setState(() => _engineNotifier = _engine.notifier);
    }
    widget.onGameStart?.call(restart);
  }
  void _onGameOver(bool playerWin){
    Audio.play(playerWin? Audio.win:Audio.lose);
    widget.onGameOver?.call(playerWin);
  }
  @override
  void initState()  {
    _init();
    widget.chessController?.addListener(_handleChessController);
    super.initState();
  }

  void _init(){
    _engine = Engine(
      onBoardUpdated: _onBoardUpdated,
      onGameStart: _onGameStart,
      onGameOver: _onGameOver,
      // botAutoPlay:false
    );

    Bot.load().then((value) {
      _engine.start();
    }, onError: (e, s) {
      debugPrintStack(stackTrace: s);
    });
  }
  double _getPieceLeft(int x) => widget.chessTheme.offsetX + widget.chessTheme.pieceWidth * x;
  double _getPieceTop(int y) => widget.chessTheme.offsetY + widget.chessTheme.pieceHeight * y;

  void _handleChessController() {
    final op=widget.chessController!.getOpReset();
    if(op==ChessController.opBack){
      _engineNotifier.get.back();
    }else if(op==ChessController.opRestart){
      _engineNotifier.get.start();
    }
    
  }

  @override
  void dispose() {
    _engineNotifier.dispose();
    widget.chessController?.removeListener(_handleChessController);
    super.dispose();
  }
}