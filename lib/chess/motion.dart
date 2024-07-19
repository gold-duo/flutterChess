import 'piece.dart';

typedef Motion = int;
typedef AxisXY = Motion;
typedef CompactPiece =Motion;

const invalidMotion = -1;
const invalidMotionX = 0xF;
const invalidMotionY = invalidMotionX;
//0-7：xy
//8-13:key
//14-21：newX、newY
//22-27:old key
Motion motion(int oldX, int oldY,int newX,int newY, {int key=Piece.none,int oldKey=Piece.none}){
  assert (key >= 0 && key< Piece.names.length,"key($key) out of range[0,${Piece.names.length})");
  assert (oldKey >= 0 && oldKey< Piece.names.length,"oldKey($oldKey) out of range[0,${Piece.names.length})");
  assert ((oldX >= 0 && oldX<=8)||oldX==invalidMotionX,"oldX($oldX) out of range[0,8]");
  assert ((oldY >= 0 && oldY<=9)||oldY==invalidMotionY,"oldY($oldY) out of range[0,9]");
  assert ((newX >= 0 && newX<=8)||newX==invalidMotionX,"newX($newX) out of range[0,8]");
  assert ((newY >= 0 && newY<=9)||newY==invalidMotionY,"newY($newY) out of range[0,9]");
  return ((oldKey & 0x3F) << 22) |
      ((newY & 0xF) << 18) |
      ((newX & 0xF) << 14) |
      ((key & 0x3F) << 8) |
      ((oldY & 0xF) << 4) |
      (oldX & 0xF);
}

AxisXY axisXY (int x, int y) {
  assert ((x >= 0 && x <= 8)||x==invalidMotionX,"x($x) out of range[0,8]");
  assert ((y >= 0 && y <= 9)||y==invalidMotionY,"y($y) out of range[0,9]");
  return ((y & 0xF) << 4) | (x & 0xF);
}

Motion compactPiece(int x, int y,int key){
  assert (key >= 0 && key< Piece.names.length,"key($key) out of range[0,${Piece.names.length})");
  assert ((x >= 0 && x<=8)||x==invalidMotionX,"x($x) out of range[0,8]");
  assert ((y >= 0 && y<=9)||y==invalidMotionY,"y($y) out of range[0,9]");
  return ((key & 0x3F) << 8) |
  ((y & 0xF) << 4) |
  (x & 0xF);
}

extension MotionExtensions on Motion{
  @pragma('vm:prefer-inline')
  int get key =>(this >> 8) & 0x3F;
  @pragma('vm:prefer-inline')
  int get oldKey =>(this >> 22) & 0x3F;
  @pragma('vm:prefer-inline')
  String get keyName => Piece.key2Name(key);
  @pragma('vm:prefer-inline')
  String get oldKeyName => Piece.key2Name(oldKey);

  @pragma('vm:prefer-inline')
  int get x => this & 0xF;

  @pragma('vm:prefer-inline')
  int get y => (this >> 4) & 0xF;

  @pragma('vm:prefer-inline')
  int get newX =>  (this >> 14) & 0xF;

  @pragma('vm:prefer-inline')
  int get newY => (this >> 18) & 0xF;

  @pragma('vm:prefer-inline')
  int get xy => this & 0xFF;

  @pragma('vm:prefer-inline')
  int get oldX => x;

  @pragma('vm:prefer-inline')
  int get oldY => y;

  String get strAxisXY =>'axisXY{x: $x, y :$y}';

  String get strMotion =>this==invalidMotion? 'Motion invalidMMotion' :'Motion{key:$keyName($key),oldKey:$oldKeyName($oldKey) x: $oldX, y :$oldY, newX: $newX, newY :$newY}';
}