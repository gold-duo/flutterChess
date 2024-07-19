import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef ThemeData = ({
  double width,
  double height,
  double offsetX,
  double offsetY,
  double pieceWidth,
  double pieceHeight,
  double guideWidth,
  double guideHeight,
  int bgColor,
  int guideColor,
  String path
});

final class ChessTheme {
  static const classical="classical";
  static const woods="woods";
  bool _loaded=false;
  late ThemeData _data;
  final String name;

  ChessTheme(this.name);
  double get width => _data.width;

  double get height => _data.height;

  double get pieceWidth => _data.pieceWidth;

  double get pieceHeight => _data.pieceHeight;

  double get guideWidth => _data.guideWidth;

  double get guideHeight => _data.guideHeight;

  double get offsetX => _data.offsetX;

  double get offsetY => _data.offsetY;

  String get path => _data.path;

  bool get loaded=>_loaded;
  int get bgColor => _data.bgColor;
  int get guideColor => _data.guideColor;
  void load(BuildContext context,void Function(bool)block) {
    if(_loaded)return;
    rootBundle.loadString('assets/themes/$name.json').then((value) {
      _data=_calc(context, jsonDecode(value));
      _loaded=true;
      block(true);
    },onError: (e){
      debugPrintStack(stackTrace:  e.stackTrace);
      block(false);
    });
  }

  ThemeData _calc(BuildContext context, dynamic js) {
    final size = MediaQuery.of(context).size;
    final w = size.width < size.height ? size.width : size.height;
    final scale = w / (js['width'] as double);
    final h = (js['height'] as double) * scale;
    final mw = (js['pieceWidth'] as double) * scale;
    final mh = (js['pieceHeight'] as double) * scale;
    return (
      width: w,
      height: h,
      offsetX: (js['offsetX'] as double) * scale,
      offsetY: (js['offsetY'] as double) * scale,
      pieceWidth: mw,
      pieceHeight: mh,
      guideWidth: (js['guideAspect'] as double) * mw,
      guideHeight: (js['guideAspect'] as double) * mh,
      bgColor: (js['bgColor'] as int),
      guideColor: (js['guideColor'] as int),
      path: (js['path'] as String)
    );
  }
}