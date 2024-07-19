import 'package:flutter/material.dart';

class RepeatFadeWidget extends StatefulWidget {
  final Widget child;
  final double begin;
  final double end;
  final Duration duration;

  const RepeatFadeWidget(
      {super.key,
      required this.child,
      this.begin = 0,
      this.end = 1,
      this.duration = const Duration(milliseconds: 888)});

  @override
  State<StatefulWidget> createState() => _RepeatFadeWidget();
}

class _RepeatFadeWidget extends State<RepeatFadeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) =>FadeTransition(opacity: _animation, child: widget.child);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation =
        Tween<double>(begin: widget.begin, end: widget.end).animate(_controller)
          ..addStatusListener((status) {
            if (AnimationStatus.completed == status) {
              _controller.reverse();
            } else if (AnimationStatus.dismissed == status) {
              _controller.forward();
            }
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();

  }
}
