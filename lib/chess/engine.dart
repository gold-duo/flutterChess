import 'package:chess/chess/rules.dart';
import 'package:chess/extensions/collection_extensions.dart';
import 'package:flutter/foundation.dart';
import '../utils/stack.dart';
import 'motion.dart';
import 'piece.dart';
import 'bot.dart';

enum UpdateType{
  move,
  eat,
  select,
  none,
}

typedef BoardUpdatedCallback=void Function(UpdateType,Motion);
typedef GameOverCallback=void Function(bool playerWin);
typedef GameStartCallback=void Function(bool restart);
class Engine {
  static const dbg=kDebugMode;
  static final log=debugPrint;
  static const tag = '[Chess.Engine]';

  List<List<int>> _oriBoard=List.empty(growable: false);
  final List<List<int>> _board=[];
  List<List<int>> get board=>_board;

  final Map<int, Piece> _pieceMap = {};
  Map<int, Piece> get pieceMap => _pieceMap;

  int _nowKey=Piece.none;
  final Stack<Motion> _his=[];
  bool _playing=true;
  bool get playing=>_playing;
  bool get canBack => _playing && _his.isNotEmpty;

  
  final ChessColor chessColor;
  final int _depth;
  Motion _foul=invalidMotion;

  List<AxisXY>? _guideSteps;
  List<AxisXY>? get guideSteps=>_guideSteps;

   final Duration _botPlayInterval;
  final bool _botAuto;
  late Bot _bot;
  bool _botThinking=false;
  bool get isBotThinking=>_botThinking;

  final BoardUpdatedCallback onBoardUpdated;
  final GameStartCallback onGameStart;
  final GameOverCallback onGameOver;

  Engine({
    required this.onBoardUpdated,
    required this.onGameStart,
    required this.onGameOver,
    this.chessColor=ChessColor.red,
    int depth = 2,
    int botPlayInterval = 1,
    bool botAutoPlay = true,
  })  :_depth = depth,
        _botPlayInterval = Duration(seconds: botPlayInterval),
        _botAuto = botAutoPlay;

  void start([List<List<int>>? board]){
    if (board != null && board.isNotEmpty) {
      _oriBoard = board;
    } else if (_oriBoard.isEmpty) {
      _oriBoard= Rules.normalBoard;
    } else {
      //_oriBoard.isNotEmpty
    }
    final List<List<int>> list=_oriBoard.clone2d();
    Rules.createMap(list, _pieceMap);
    final bool restart=_board.isNotEmpty;
    if(restart) _board.clear();
    _board.addAll(list);
    _nowKey=Piece.none;
    if(_his.isNotEmpty) _his.clear();
    _guideSteps=null;
    _playing=true;
    _foul=invalidMotion;

    
    onGameStart(restart);
  }

  
  void back() {
    if (!canBack) return;
    int i=0;
    while (_his.isNotEmpty && ++i <= 2) {
      final s = _his.pop();
      
      final oldKey = s.oldKey;
      final piece = _pieceMap[s.key];
      final x = s.newX;
      final y = s.newY;
      final ox = s.oldX;
      final oy = s.oldY;
      if (oldKey != Piece.none) {
        final oPiece = _pieceMap[oldKey];
        if (oPiece != null) {
          oPiece.isKilled = false;
          oPiece.setXY(x, y);   
        }
        _board[y][x] = oldKey;  
      }else{
        _board[y][x] = Piece.none;  
      }
      _board[oy][ox] = s.key;
      piece?.setXY(ox, oy);
    }
    if (i >= 2) {
      _guideSteps=[];
      _nowKey=Piece.none;
      final last = _his.peek();
      if (last != null) {
        
        onBoardUpdated(last.oldKey != Piece.none ? UpdateType.eat : UpdateType.move, last);
      } else {
        
        onBoardUpdated(UpdateType.none, invalidMotion);
      }
    }
  }

  
  void play(int x,int y){
    if(!_playing)return;
    try{
      final key=_board[y][x];
      if(key!=Piece.none){
        _clickPiece(key, x, y);
      }else{
        _clickPoint(x, y);
      }
      _checkFoul();
    }  catch(e,stack){
      if (dbg) {
        debugPrintStack(stackTrace: stack);
      }
    }
  }

  void _clickPiece(int key,int x,int y){
    final clicked=_pieceMap[key];
    if(clicked==null) throw Exception('$tag ${Piece.key2Name(key)} not found!');
    final now = _nowKey != Piece.none && _nowKey != key ? _pieceMap[_nowKey] : null;
    if(now!=null && clicked.color!=now.color){
      if( now.inNextSteps( x, y)){
        clicked.isKilled=true;
        final ox=now.x;
        final oy=now.y;
        _board[oy][ox] = Piece.none; 
        _board[y][x] = _nowKey;
        final m= motion(ox, oy, x, y, key: _nowKey, oldKey: key);
        
        now.setXY(x,y);
        now.isSelected=false;
        _his.push(m);
        _nowKey=Piece.none;
        _guideSteps=null;
        onBoardUpdated(UpdateType.eat,m);
        _botAutoPlay();
        _checkGameOver(key);
      }
    }else{
      if(clicked.color== chessColor){
        _pieceMap[_nowKey]?.isSelected=false;
        
        clicked.isSelected=true;
        _nowKey=key;
        clicked.nextSteps=clicked.guideSteps(_board,_pieceMap);
        _guideSteps=clicked.nextSteps;
        onBoardUpdated(UpdateType.select, motion(invalidMotionX, invalidMotionY, x, y, key: key));
      }
    }
  }

  
  void _clickPoint(int newX,int newY){
    if(_nowKey==Piece.none) return;
    final now=_pieceMap[_nowKey];
    if(now==null) throw Exception('$tag ${Piece.key2Name(_nowKey)} piece not found!');
    if(now.inNextSteps( newX,newY)){
      final ox=now.x;
      final oy=now.y;
      _board[oy][ox] = Piece.none;
      _board[newY][newX] = _nowKey;
      final m = motion(ox, oy, newX, newY, key: _nowKey);
      

      now.setXY(newX,newY);
      now.isSelected=false;
      _his.push(m);
      _nowKey=Piece.none;

      _guideSteps=null;
      onBoardUpdated(UpdateType.move,m);
      _botAutoPlay();
    }
  }

  void _botAutoPlay(){
    if(_playing && _botAuto){
      _botThinking=true;
      Future.delayed(_botPlayInterval,botPlay);
    }
  }
  
  void botPlay(){
    if(!_playing){
      _botThinking=false;
      return;
    }
    try {
      final _bot=Bot(_board,_pieceMap,chessColor==ChessColor.red? ChessColor.black:ChessColor.red,_depth);
      final p = _bot.calc(_hisJoin, _foul);
      
      if (p == invalidMotion) {
        _gameOver(true);
        return;
      }
      _nowKey = _board[p.y][p.x];
      final key = _board[p.newY][p.newX];
      if (key != Piece.none) {
        _botClickPiece(key, p.newX, p.newY);
      } else {
        _botClickPoint(p.newX, p.newY);
      }
    } catch(e,stack){
      if (dbg) {
        debugPrintStack(stackTrace: stack);
        
      }
    }finally{
      _botThinking=false;
    }
  }

  
  void _botClickPiece(int key,int x,int y){
    final killed=_pieceMap[key];
    if(killed==null) throw Exception('$tag piece return null!');
    
    killed.isKilled=true;
    killed.isSelected=false;
    final now=_pieceMap[_nowKey];
    if(now==null) throw Exception('$tag $_nowKey not found!');
    final ox=now.x;
    final oy=now.y;
    final m = motion(ox, oy, x, y, key: _nowKey, oldKey: key);
    _his.push(m);
    
    _board[oy][ox] = Piece.none;
    _board[y][x] = _nowKey;

    now.setXY(x, y);
    _nowKey=Piece.none;
    onBoardUpdated(UpdateType.eat, m);
    _checkGameOver(key);
  }

  
  void _botClickPoint(int newX,int newY){
    if(_nowKey==Piece.none)return;
    final now=_pieceMap[_nowKey];
    if(now==null) throw Exception('$tag $_nowKey not found!');

    final ox=now.x;
    final oy=now.y;
    final m= motion(ox, oy, newX, newY, key:_nowKey);
    _his.push(m);
    
    _board[oy][ox]=Piece.none;
    _board[newY][newX]=_nowKey;

    now.setXY(newX, newY);
    _nowKey=Piece.none;
    onBoardUpdated(UpdateType.move, m);
  }

  void _checkGameOver(int key){
    if(key==Piece.k){
      _gameOver(chessColor==ChessColor.black);
    }else if(key==Piece.K){
      _gameOver(chessColor==ChessColor.red);
    }
  }

  void _gameOver(bool playerWin){
    _playing = false;
    onGameOver(playerWin);
  }

  String get _hisJoin{
    final sb=StringBuffer();
    for(final it in _his){
      sb.write(it.oldX);
      sb.write(it.oldY);
      sb.write(it.newX);
      sb.write(it.newY);
    }
    return sb.toString();
  }

  void _checkFoul() {
    final p = _his;
    final l = _his.length;
    if(l > 11 && p[l - 1] == p[l - 5] && p[l - 5] == p[l - 9]){
      final f=p[l - 4];
      _foul = f;
    }else{
      _foul=invalidMotion;
    }
  }
}