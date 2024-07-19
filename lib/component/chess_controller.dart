import 'package:flutter/widgets.dart';

class ChessController extends ChangeNotifier {
  static const int opNone=0;
  static const int opBack=1;
  static const int opRestart=2;

  int _op=opNone;
  ChessController();
  void back() {
    _op=opBack;
    notifyListeners();
  }

  void restart(){
    _op=opRestart;
    notifyListeners();
  }
  int getOpReset() {
    final v=_op;
    _op=opNone;
    return v;
  }
}