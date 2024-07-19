import 'package:chess/chess/motion.dart';

///双方对弈者实现，达到分离engine里写死玩家、bot
abstract class Player{
  AxisXY nextMove();
}

class UserPlayer implements Player {
  @override
  AxisXY nextMove() {
    // TODO: implement next
    throw UnimplementedError();
  }
}