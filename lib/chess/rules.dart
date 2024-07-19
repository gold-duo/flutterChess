import 'package:chess/chess/piece.dart';
import 'motion.dart';

typedef RuleFunction=List<AxisXY> Function(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map);
final class Rules{
  static final Map<int,List<List<int>> > _score={
    Piece.R1: _sR, Piece.R2: _sR,
    Piece.r1: _sr, Piece.r2: _sr,
    Piece.H1: _sH, Piece.H2: _sH,
    Piece.h1: _sh, Piece.h2: _sh,
    Piece.E1: _se, Piece.E2: _se, Piece.e1: _se, Piece.e2: _se,
    Piece.A1: _sa, Piece.A2: _sa, Piece.a1: _sa, Piece.a2: _sa,
    Piece.K: _sk, Piece.k: _sk,
    Piece.C1: _sC, Piece.C2: _sC, Piece.c1: _sc, Piece.c2: _sc,
    Piece.P1: _sP, Piece.P2: _sP, Piece.P3: _sP, Piece.P4: _sP,Piece.P5: _sP,
    Piece.p1: _sp, Piece.p2: _sp, Piece.p3: _sp, Piece.p4: _sp,Piece.p5: _sp
  };

  static final Map<int,RuleFunction> _rules= {
    Piece.R1: _r, Piece.R2: _r, Piece.r1: _r, Piece.r2: _r,
    Piece.H1: _h, Piece.H2: _h, Piece.h1: _h, Piece.h2: _h,
    Piece.E1: _e, Piece.E2: _e, Piece.e1: _e, Piece.e2: _e,
    Piece.A1: _a, Piece.A2: _a, Piece.a1: _a, Piece.a2: _a,
    Piece.K: _k, Piece.k: _k,
    Piece.C1: _c, Piece.C2: _c, Piece.c1: _c, Piece.c2: _c,
    Piece.P1: _p, Piece.P2: _p, Piece.P3: _p, Piece.P4: _p,Piece.P5: _p,
    Piece.p1: _p, Piece.p2: _p, Piece.p3: _p, Piece.p4: _p,Piece.p5: _p
  };
  static const List<List<int>> normalBoard = [
    [Piece.R1,Piece.H1,Piece.E1,Piece.A1,Piece.K,Piece.A2,Piece.E2,Piece.H2,Piece.R2],
    [0,0,0,0,0,0,0,0,0],
    [0,Piece.C1,0,0,0,0,0,Piece.C2,0],
    [Piece.P1,0,Piece.P2,0,Piece.P3,0,Piece.P4,0,Piece.P5],
    [0,0,0,0,0,0,0,0,0],

    [0,0,0,0,0,0,0,0,0],
    [Piece.p1,0,Piece.p2,0,Piece.p3,0,Piece.p4,0,Piece.p5],
    [0,Piece.c1,0,0,0,0,0,Piece.c2,0],
    [0,0,0,0,0,0,0,0,0],
    [Piece.r1,Piece.h1,Piece.e1,Piece.a1,Piece.k,Piece.a2,Piece.e2,Piece.h2,Piece.r2]
  ];

  static const _sr=[
    [206, 208, 207, 213, 214, 213, 207, 208, 206],
    [206, 212, 209, 216, 233, 216, 209, 212, 206],
    [206, 208, 207, 214, 216, 214, 207, 208, 206],
    [206, 213, 213, 216, 216, 216, 213, 213, 206],
    [208, 211, 211, 214, 215, 214, 211, 211, 208],

    [208, 212, 212, 214, 215, 214, 212, 212, 208],
    [204, 209, 204, 212, 214, 212, 204, 209, 204],
    [198, 208, 204, 212, 212, 212, 204, 208, 198],
    [200, 208, 206, 212, 200, 212, 206, 208, 200],
    [194, 206, 204, 212, 200, 212, 204, 206, 194]
  ];
  static const _sR = [
    [194, 206, 204, 212, 200, 212, 204, 206, 194],
    [200, 208, 206, 212, 200, 212, 206, 208, 200],
    [198, 208, 204, 212, 212, 212, 204, 208, 198],
    [204, 209, 204, 212, 214, 212, 204, 209, 204],
    [208, 212, 212, 214, 215, 214, 212, 212, 208],
    [208, 211, 211, 214, 215, 214, 211, 211, 208],
    [206, 213, 213, 216, 216, 216, 213, 213, 206],
    [206, 208, 207, 214, 216, 214, 207, 208, 206],
    [206, 212, 209, 216, 233, 216, 209, 212, 206],
    [206, 208, 207, 213, 214, 213, 207, 208, 206],
  ];
  static const _sh=[
    [90, 90, 90, 96, 90, 96, 90, 90, 90],
    [90, 96,103, 97, 94, 97,103, 96, 90],
    [92, 98, 99,103, 99,103, 99, 98, 92],
    [93,108,100,107,100,107,100,108, 93],
    [90,100, 99,103,104,103, 99,100, 90],

    [90, 98,101,102,103,102,101, 98, 90],
    [92, 94, 98, 95, 98, 95, 98, 94, 92],
    [93, 92, 94, 95, 92, 95, 94, 92, 93],
    [85, 90, 92, 93, 78, 93, 92, 90, 85],
    [88, 85, 90, 88, 90, 88, 90, 85, 88]
  ];
  static const _sH = [
    [88, 85, 90, 88, 90, 88, 90, 85, 88],
    [85, 90, 92, 93, 78, 93, 92, 90, 85],
    [93, 92, 94, 95, 92, 95, 94, 92, 93],
    [92, 94, 98, 95, 98, 95, 98, 94, 92],
    [90, 98, 101, 102, 103, 102, 101, 98, 90],
    [90, 100, 99, 103, 104, 103, 99, 100, 90],
    [93, 108, 100, 107, 100, 107, 100, 108, 93],
    [92, 98, 99, 103, 99, 103, 99, 98, 92],
    [90, 96, 103, 97, 94, 97, 103, 96, 90],
    [90, 90, 90, 96, 90, 96, 90, 90, 90],
  ];
  static const _se=[
    [0, 0,20, 0, 0, 0,20, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0,23, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0,20, 0, 0, 0,20, 0, 0],

    [0, 0,20, 0, 0, 0,20, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [18,0, 0, 0,23, 0, 0, 0,18],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0,20, 0, 0, 0,20, 0, 0]
  ];
  static const _sa=[
    [0, 0, 0,20, 0,20, 0, 0, 0],
    [0, 0, 0, 0,23, 0, 0, 0, 0],
    [0, 0, 0,20, 0,20, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],

    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0,20, 0,20, 0, 0, 0],
    [0, 0, 0, 0,23, 0, 0, 0, 0],
    [0, 0, 0,20, 0,20, 0, 0, 0]
  ];
  static const _sk=[
    [0, 0, 0, 8888, 8888, 8888, 0, 0, 0],
    [0, 0, 0, 8888, 8888, 8888, 0, 0, 0],
    [0, 0, 0, 8888, 8888, 8888, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],

    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 8888, 8888, 8888, 0, 0, 0],
    [0, 0, 0, 8888, 8888, 8888, 0, 0, 0],
    [0, 0, 0, 8888, 8888, 8888, 0, 0, 0]
  ];
  static const _sc=[
    [100, 100,  96, 91,  90, 91,  96, 100, 100],
    [ 98,  98,  96, 92,  89, 92,  96,  98,  98],
    [ 97,  97,  96, 91,  92, 91,  96,  97,  97],
    [ 96,  99,  99, 98, 100, 98,  99,  99,  96],
    [ 96,  96,  96, 96, 100, 96,  96,  96,  96],

    [ 95,  96,  99, 96, 100, 96,  99,  96,  95],
    [ 96,  96,  96, 96,  96, 96,  96,  96,  96],
    [ 97,  96, 100, 99, 101, 99, 100,  96,  97],
    [ 96,  97,  98, 98,  98, 98,  98,  97,  96],
    [ 96,  96,  97, 99,  99, 99,  97,  96,  96]
  ];
  static const _sC = [
    [96, 96, 97, 99, 99, 99, 97, 96, 96],
    [96, 97, 98, 98, 98, 98, 98, 97, 96],
    [97, 96, 100, 99, 101, 99, 100, 96, 97],
    [96, 96, 96, 96, 96, 96, 96, 96, 96],
    [95, 96, 99, 96, 100, 96, 99, 96, 95],
    [96, 96, 96, 96, 100, 96, 96, 96, 96],
    [96, 99, 99, 98, 100, 98, 99, 99, 96],
    [97, 97, 96, 91, 92, 91, 96, 97, 97],
    [98, 98, 96, 92, 89, 92, 96, 98, 98],
    [100, 100, 96, 91, 90, 91, 96, 100, 100],
  ];
  static const _sp=[
    [ 9,  9,  9, 11, 13, 11,  9,  9,  9],
    [19, 24, 34, 42, 44, 42, 34, 24, 19],
    [19, 24, 32, 37, 37, 37, 32, 24, 19],
    [19, 23, 27, 29, 30, 29, 27, 23, 19],
    [14, 18, 20, 27, 29, 27, 20, 18, 14],

    [ 7,  0, 13,  0, 16,  0, 13,  0,  7],
    [ 7,  0,  7,  0, 15,  0,  7,  0,  7],
    [ 0,  0,  0,  0,  0,  0,  0,  0,  0],
    [ 0,  0,  0,  0,  0,  0,  0,  0,  0],
    [ 0,  0,  0,  0,  0,  0,  0,  0,  0]
  ];
  static const _sP = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [7, 0, 7, 0, 15, 0, 7, 0, 7],
    [7, 0, 13, 0, 16, 0, 13, 0, 7],
    [14, 18, 20, 27, 29, 27, 20, 18, 14],
    [19, 23, 27, 29, 30, 29, 27, 23, 19],
    [19, 24, 32, 37, 37, 37, 32, 24, 19],
    [19, 24, 34, 42, 44, 42, 34, 24, 19],
    [9, 9, 9, 11, 13, 11, 9, 9, 9],
  ];

  static List<AxisXY> _r(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    final List<AxisXY> ret = [];
    lr(int i){
      final key = list[y][i];
      if (key == Piece.none) {
        ret.add( axisXY( i,y ) );
        return true;
      }
      if (map[key]!.color != color) ret.add( axisXY( i,y ) );
      return false;
    }
    for (int i = x - 1; i >= 0; i--) {//left
      if(!lr(i)) break;
    }
    for (int i = x + 1; i <= 8; i++) {//right
      if(!lr(i)) break;
    }
    ud(int i){
      final key=list[i][x];
      if(key==Piece.none){
        ret.add( axisXY( x,i ) );
        return true;
      }
      if (map[key]!.color != color) ret.add( axisXY( x,i ) );
      return false;
    }
    for (int i = y - 1; i >= 0; i--) {//up
      if(!ud(i))break;
    }
    for (int i = y + 1; i <= 9; i++) {//down
      if(!ud(i))break;
    }
    return ret;
  }

  static List<AxisXY> _h(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    final List<AxisXY> ret=[];
    if (y >= 2) {
      if (x <= 7 && Piece.none == list[y - 1][x] && _can(x + 1, y - 2, color, list, map)) ret.add( axisXY(x + 1, y - 2) );//1 point不绊马脚(不存在棋子或1点棋子颜色不同)
      if (x >= 1 && Piece.none == list[y - 1][x] && _can(x - 1, y - 2,color,list, map)) ret.add( axisXY(x - 1, y - 2) );//11 point
    }
    if (y >= 1) {
      if (x <= 6 && Piece.none == list[y][x + 1] && _can(x + 2, y - 1, color, list, map)) ret.add( axisXY(x + 2, y - 1) );//2 point
      if (x >= 2 && Piece.none == list[y][x - 1] && _can(x - 2, y - 1,color,list, map)) ret.add( axisXY(x - 2, y - 1) );//10 point
    }
    if (y <= 8) {
      if (x <= 6 && Piece.none == list[y][x + 1] && _can(x + 2, y + 1, color, list, map)) ret.add( axisXY(x + 2, y + 1) );//4 point
      if (x >= 2 && Piece.none == list[y][x - 1] && _can(x - 2, y + 1,color,list, map)) ret.add( axisXY(x - 2, y + 1) );//8 point
    }
    if (y <= 7) {
      if (x <= 7 && Piece.none == list[y + 1][x] && _can(x + 1, y + 2, color, list, map)) ret.add(axisXY(x + 1, y + 2)); //5 point
      if (x >= 1 && Piece.none == list[y + 1][x] && _can(x - 1, y + 2, color, list, map)) ret.add(axisXY(x - 1, y + 2)); //7 point
    }
    return ret;
  }

  static List<AxisXY> _e(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    final List<AxisXY> ret=[];
    if (color==ChessColor.red){
      if (y <= 7){
        if (x <= 6 && Piece.none == list[y + 1][x + 1] && _can(x + 2, y + 2, color, list, map)) ret.add( axisXY(x + 2, y + 2) );//4 point
        if (x >= 2 && Piece.none == list[y + 1][x - 1] && _can(x - 2, y + 2, color, list, map)) ret.add( axisXY(x - 2, y + 2) );//7 point
      }
      if (y >= 7){
        if (x <= 6 && Piece.none == list[y - 1][x + 1] && _can(x + 2, y - 2, color, list, map)) ret.add( axisXY(x + 2, y - 2) );//1 point
        if (x >= 2 && Piece.none == list[y - 1][x - 1] && _can(x - 2, y - 2, color, list, map)) ret.add( axisXY(x - 2, y - 2) );//10 point
      }
    }else{
      if (y <= 2){
        if (x <= 6 && Piece.none == list[y + 1][x + 1] && _can(x + 2, y + 2, color, list, map)) ret.add( axisXY(x + 2, y + 2) );//4 point
        if (x >= 2 && Piece.none == list[y + 1][x - 1] && _can(x - 2, y + 2, color, list, map)) ret.add( axisXY(x - 2, y + 2) );//7 point
      }
      if (y >= 2){
        if (x <= 6 && Piece.none == list[y - 1][x + 1] && _can(x + 2, y - 2, color, list, map)) ret.add( axisXY(x + 2, y - 2) );//1 point
        if (x >= 2 && Piece.none == list[y - 1][x - 1] && _can(x - 2, y - 2, color, list, map)) ret.add( axisXY(x - 2, y - 2) );//10 point
      }
    }
    return ret;
  }

  static List<AxisXY> _a(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    final List<AxisXY> ret = [];
    if (color==ChessColor.red){
      if ( y<= 8 ){
        if ( x<= 4 && _can(x + 1, y + 1, color, list, map)) ret.add( axisXY(x + 1, y + 1) );//4 point
        if ( x>= 4 && _can(x - 1, y + 1, color, list, map)) ret.add( axisXY(x - 1, y + 1) );//7 point
      }
      if ( y>= 8 ){
        if ( x<= 4 && _can(x + 1, y - 1, color, list, map)) ret.add( axisXY(x + 1, y - 1) );//1 point
        if ( x>= 4 && _can(x - 1, y - 1, color, list, map)) ret.add( axisXY(x - 1, y - 1) );//10 point
      }
    }else{
      if ( y<= 1 ){
        if ( x<= 4 && _can(x + 1, y + 1, color, list, map)) ret.add( axisXY(x + 1, y + 1) );//4 point
        if ( x>= 4 && _can(x - 1, y + 1, color, list, map)) ret.add( axisXY(x - 1, y + 1) );//7 point
      }
      if ( y>= 1 ){
        if ( x<= 4 && _can(x + 1, y - 1, color, list, map)) ret.add( axisXY(x + 1, y - 1) );//1 point
        if ( x>= 4 && _can(x - 1, y - 1, color, list, map)) ret.add( axisXY(x - 1, y - 1) );//10 point
      }
    }
    return ret;
  }

  static bool _isOpposite(List<List<int>> list,Map<int,Piece> map) {
    final m=map[Piece.K]!;
    var y1 = map[Piece.k]!.y;
    var x1 = m.x;
    var y2 = m.y;
    for (var i = y1 - 1; i > y2; i--) {
      if (list[i][x1] != Piece.none) return false;
    }
    return true;
  }

  static List<AxisXY> _k(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    
    
    final List<AxisXY> ret = [];
    if (color==ChessColor.red){
      if (y <= 8 && _can(x, y + 1, color, list, map)) ret.add(axisXY(x, y + 1));//down
      if (y >= 8 && _can(x, y - 1, color, list, map)) ret.add(axisXY(x, y - 1));//up
      if ( map[Piece.k]!.x == map[Piece.K]!.x && _isOpposite(list, map)){
        final m=map[Piece.K]!;
        ret.add(axisXY(m.x, m.y));
      }
    }else{
      if ( y<= 1 && _can(x, y + 1, color, list, map)) ret.add(axisXY(x, y + 1));//down
      if ( y>= 1 && _can(x, y - 1, color, list, map)) ret.add(axisXY(x, y - 1));//up
      if ( map[Piece.k]!.x == map[Piece.K]!.x && _isOpposite(list, map)){
        final m=map[Piece.k]!;
        ret.add(axisXY(m.x, m.y));
      }
    }
    if ( x<= 4 && _can(x + 1, y, color, list, map)) ret.add(axisXY(x + 1, y));//right
    if ( x>= 4 && _can(x - 1, y, color, list, map))ret.add(axisXY(x - 1, y));//left
    return ret;
  }

  static List<AxisXY> _c(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    final List<AxisXY> ret = [];
    var flag = true;
    fn1(i){
      if(list[y][i]!=Piece.none){
        if (flag){
          flag = false;
          return true;
        }
        if (map[list[y][i]]?.color!=color) ret.add( axisXY( i,y ) );
        return false;
      }
      if(flag) ret.add( axisXY( i,y ) );
      return true;
    }
    //left
    for (var i=x-1; i>= 0; i--){
      if(!fn1(i)) break;
    }
    //right
    flag = true;
    for (var i=x+1; i <= 8; i++){
      if(!fn1(i)) break;
    }

    fn2(i){
      if (list[i][x]!=Piece.none) {
        if (flag){
          flag = false;
          return true;
        }
        if (map[list[i][x]]?.color!=color) ret.add( axisXY( x,i ) );
        return false;
      }
      if(flag) ret.add( axisXY( x,i ) );
      return true;
    }
    //up
    flag = true;
    for (var i = y-1 ; i >= 0; i--){
      if (!fn2(i)) break;
    }
    //down
    flag = true;
    for (var i = y+1 ; i<= 9; i++){
      if (!fn2(i)) break;
    }
    return ret;
  }

  static List<AxisXY> _p(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map){
    final List<AxisXY> ret = [];
    if (color==ChessColor.red){
      if (y >= 1 && _can(x, y - 1, color, list, map)) ret.add( axisXY( x,y-1 ) );//up
      if (y <= 4) {
        if (x<= 7 && _can(x + 1, y, color, list, map)) ret.add( axisXY( x+1,y ) );//right
        if (x>= 1 && _can(x - 1, y, color, list, map)) ret.add( axisXY( x-1,y ) );//left
      }
    }else{
      if (y<= 8 && _can(x, y + 1, color, list, map)) ret.add( axisXY( x,y+1 ) );//down
      if (y >= 6) {
        if (x<= 7 && _can(x + 1, y, color, list, map)) ret.add( axisXY( x+1,y ) );//right
        if (x >= 1 && _can(x - 1, y, color, list, map))ret.add( axisXY( x-1,y ) );//left
      }
    }
    return ret;
  }

  static bool _can(int x, int y, ChessColor color, List<List<int>> list,Map<int,Piece> map) {
    if (x > 8 || y > 9 || x < 0 || y < 0) return false;
    final int key = list[y][x];
    return (!map.containsKey(key) || map[key]!.color != color);
  }

  static RuleFunction getRule(int key) {
    assert (key > 0 && key < Piece.names.length, "key($key) out of range");
    return _rules[key]!;
  }

  static List<List<int>> getScore(int key){
    assert (key > 0 && key < Piece.names.length, "key($key) out of range");
    return _score[key]!;
  }
  

  static Map<int, Piece> createMap(List<List<int>> list, [Map<int, Piece>? map]) {
    final Map<int, Piece> m;
    if (map != null) {
      if (map.isNotEmpty) map.clear();
      m = map;
    } else {
      m = {};
    }
    for (int i = 0; i < list.length; i++) {
      final line = list[i];
      for (int j = 0; j < line.length; j++) {
        final key = line[j];
        if (key != Piece.none) {
          m[key] = Piece(key, j, i);
        }
      }
    }
    return m;
  }
}