import 'package:chess/chess/chess_theme.dart';
import 'package:flutter/material.dart';

class PieceMoveEffect extends StatefulWidget{
  final double width;
  final double height;
  final double fromX;
  final double fromY;
  final double toX;
  final double toY;
  final ChessTheme chessTheme;

  const PieceMoveEffect(
      {super.key,
      required this.width,
      required this.height,
      required this.fromX,
      required this.fromY,
      required this.toX,
      required this.toY, required this.chessTheme});

  @override
  State<StatefulWidget> createState() =>_Border();

  // @override
  String _string() {
    return 'PieceMoveEffect{width: $width, height: $height, fromX: $fromX, fromY: $fromY, toX: $toX, toY: $toY}';
  }
}
class _Border extends State<PieceMoveEffect> with TickerProviderStateMixin{
  static const dbg=!false;//kDebugMode;
  static const tag = '[Chess.PieceMoveEffect]';
  Animation<Offset>? _animSlide;
  Animation<double>? _animFade;
  late AnimationController _controller;
  @override
  Widget build(BuildContext context) {
    final color= Color(widget.chessTheme.guideColor);
    final w=widget.width/2.5;
    Widget child = Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.5)),
        child: Center(
          child: Container(
              width: w,
              height: widget.height / 2.5,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(w))),
        ));
    final show=widget.width > 0 && widget.height > 0;
    if (show && _animSlide!=null) {
        child=SlideTransition(
          position:_animSlide!,
          child: FadeTransition(
            opacity: _animFade!,
            child: child,
          )
        );
    }
    return Positioned(
        left: widget.toX,
        top: widget.toY,
        child:Offstage(
          offstage: !show,
          child: child));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller=AnimationController(vsync: this,duration: const Duration(milliseconds: 888));
    _buildAnimation();
  }
  void _buildAnimation(){
    if(_animSlide!=null && _controller.isAnimating)_controller.stop();
    final show=widget.width > 0 && widget.height > 0;
    if (show && !(widget.fromX == widget.toX && widget.fromY == widget.toY)) {
      _animSlide= Tween(
          begin: Offset( ((widget.fromX-widget.toX ) / widget.width), ((widget.fromY-widget.toY ) / widget.height)),
          end: const Offset(0, 0))
          .animate(_controller)
        ..addStatusListener((status){
          if(status==AnimationStatus.completed) {
            _controller.reset();
            _controller.forward();
          }
        });
      _animFade=Tween(begin: 0.2,end: 1.0)
          .animate(_controller);
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PieceMoveEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildAnimation();
  }
}