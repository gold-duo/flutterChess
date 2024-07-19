import 'package:chess/chess/rules.dart';
import 'motion.dart';

enum ChessColor {
  black,
  red,
}
extension ChessColorEnxtensions on ChessColor {
  int get multiplier => this == ChessColor.red ? 1 : -1;
}

final class Piece {
  static const names = [
    '',
    'r1', //1
    'r2', //2
    'h1', //3
    'h2', //4
    'k', //5
    'c1', //6
    'c2', //7
    'a1', //8
    'a2', //9
    'e1', //10
    'e2', //11
    'p1', //12
    'p2', //13
    'p3', //14
    'p4', //15
    'p5', //16
    'R1', //17
    'R2', //18
    'H1', //19
    'H2', //20
    'K', //21
    'C1', //22
    'C2', //23
    'A1', //24
    'A2', //25
    'E1', //26
    'E2', //27
    'P1', //28
    'P2', //29
    'P3', //30
    'P4', //31
    'P5', //32
  ];

  static const none = 0;
  static const r1 = 1;
  static const r2 = 2;
  static const h1 = 3;
  static const h2 = 4;
  static const k = 5;
  static const c1 = 6;
  static const c2 = 7;
  static const a1 = 8;
  static const a2 = 9;
  static const e1 = 10;
  static const e2 = 11;
  static const p1 = 12;
  static const p2 = 13;
  static const p3 = 14;
  static const p4 = 15;
  static const p5 = 16;
  //black
  static const R1 = 17;
  static const R2 = 18;
  static const H1 = 19;
  static const H2 = 20;
  static const K = 21;
  static const C1 = 22;
  static const C2 = 23;
  static const A1 = 24;
  static const A2 = 25;
  static const E1 = 26;
  static const E2 = 27;
  static const P1 = 28;
  static const P2 = 29;
  static const P3 = 30;
  static const P4 = 31;
  static const P5 = 32;

  late int _mask;
  List<AxisXY>? nextSteps;

  static const _pBlack=14;
  static const _pSelected=15;
  static const _pKilled=16;

  //0-7：xy
  //8-13:key
  //14：isBlack 有点多余，不过为了方便
  //15：isSelected
  //16：isKilled
  Piece(int key, int x, int y,
      {ChessColor? color, bool isSelected = false, bool isKilled = false}){
    assert (key >= 0 && key< Piece.names.length,"key($key) out of range[0,${Piece.names.length}]");
    assert (x >= 0 && x<=8,"x($x) out of range[0,8]");
    assert (y >= 0 && y<=9,"y($y) out of range[0,9]");
    final isBlack =color!=null? (color==ChessColor.black): key>=Piece.R1;
    _mask=((key & 0x3F) << 8) |
    ((y & 0xF) << 4) |
    (x & 0xF) |
    ((isBlack ? 1 : 0) << _pBlack) |
    ((isSelected ? 1 : 0) << _pSelected) |
    ((isKilled ? 1 : 0) << _pKilled);
  }

  Piece.rawValue(int mask):_mask=mask;
  Piece.copy(Piece piece):_mask=piece._mask;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece &&
          runtimeType == other.runtimeType &&
          _mask == other._mask;

  @override
  int get hashCode => key.hashCode ^ _isBlack.hashCode;

  @override
  String toString() {
    return 'Piece{key: $keyName($key),x: $x, y: $y, isSelected: $isSelected, isKilled: $isKilled, color: $color}';
  }

  @pragma('vm:prefer-inline')
  static String key2Name(int key) =>Piece.names[key];
  @pragma('vm:prefer-inline')
  static int name2Key(String key)=>Piece.names.indexOf(key);
}

extension PieceExtensions on Piece {
  @pragma('vm:prefer-inline')
  String get keyName=>Piece.names[key];

  @pragma('vm:prefer-inline')
  int get key =>(_mask >> 8) & 0x3F;
  
  void setXY(int x, int y) {
    assert(x >= 0 && x<=8,"x($x) out of range[0,8]");
    assert(y >= 0 && y<=9,"y($y) out of range[0,9]");
    _mask = (_mask & 0xFFFFFF00) | (((y & 0xF) << 4) | (x & 0xF));
  }

  @pragma('vm:prefer-inline')
  int get x => _mask & 0xF;

  @pragma('vm:prefer-inline')
  int get y => (_mask >> 4) & 0xF;

  @pragma('vm:prefer-inline')
  int get xy => _mask & 0xFF;

  @pragma('vm:prefer-inline')
  bool get _isBlack => (_mask & (1 << Piece._pBlack)) != 0;

  
  set isSelected(bool v) {
    if(!v) nextSteps=null;
    _mask = v ? (_mask | (1 << Piece._pSelected)) : (_mask & (~(1 << Piece._pSelected)));
  }

  @pragma('vm:prefer-inline')
  bool get isSelected => (_mask & (1 << Piece._pSelected)) != 0;

  @pragma('vm:prefer-inline')
  set isKilled(bool v) {
    if(v) nextSteps=null;
    _mask = v ? (_mask | (1 << Piece._pKilled)) : (_mask & (~(1 << Piece._pKilled)));
  }

  @pragma('vm:prefer-inline')
  bool get isKilled => (_mask & (1 << Piece._pKilled)) != 0;

  @pragma('vm:prefer-inline')
  int get rawValue=>_mask;

  @pragma('vm:prefer-inline')
  String get img {
    final f = _isBlack;
    return '${f ? "b" : "r"}${Piece.names[f ? key - Piece.p5 : key][0]}';
  }

  
  @pragma('vm:prefer-inline')
  List<List<int>> get score=>Rules.getScore(key);

  @pragma('vm:prefer-inline')
  ChessColor get color=>_isBlack? ChessColor.black:ChessColor.red;

  @pragma('vm:prefer-inline')
  List<AxisXY> guideSteps(List<List<int>> list,Map<int,Piece> map)=>Rules.getRule(key)(x,y,color,list,map);

  
  bool inNextSteps(int x,int y){
    if(nextSteps==null||nextSteps!.isEmpty) return false;
    final f=axisXY(x, y);
    return nextSteps!.any((it) => it==f);
  }
}