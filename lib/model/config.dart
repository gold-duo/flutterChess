//保存游戏结果用于复盘
//saveGameResult()=false          =>转json
//getMask():Int                   =>转json
//canStart(): Boolean             =>转json
//canReject(count: Int): Boolean  =>转json

//onGameOver(pace: String?)
//gotoSetting()
import 'package:chess/extensions/int_extensions.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const int MASK_DIFFICULTY_EASY = 0; //菜鸟
  static const int MASK_DIFFICULTY_MEDIUM = 1; //中级
  static const int MASK_DIFFICULTY_MASTER = 2; //高手
  static const int MASK_CAN_CHALLENGE = 3; 
  static const int MASK_CAN_THEME = 4; //皮肤
  static const int MASK_SAVE_GAME_RESULT = 5; //保存游戏结果
  static const int DEFAULT_MASK = 0x13; //0b0010011
  static const DEFAULT_PWD = "123456789";

  int mask = DEFAULT_MASK;

  /// 每天限制次数
  int limit = 5;

  ///周末限制次数
  int limitWeekend = 10;

  ///最大悔棋次数
  int maxReject = 5;

  ///设置页面密码
  String pwd = DEFAULT_PWD;

  ///难易程度
  Set<int> get difficulty {
    final Set<int> r = {};
    if (mask.getBit(MASK_DIFFICULTY_EASY)) r.add(MASK_DIFFICULTY_EASY);
    if (mask.getBit(MASK_DIFFICULTY_MEDIUM)) r.add(MASK_DIFFICULTY_MEDIUM);
    if (mask.getBit(MASK_DIFFICULTY_MASTER)) r.add(MASK_DIFFICULTY_MASTER);
    return r;
  }

  set difficulty(Set<int> value) {
    final array = [
      MASK_DIFFICULTY_EASY,
      MASK_DIFFICULTY_MEDIUM,
      MASK_DIFFICULTY_MASTER
    ];
    for (var it in array) {
      mask = mask.setBit(it, value.contains(it));
    }
  }

  ///是否显示挑战
  bool get canChallenge => mask.getBit(MASK_CAN_CHALLENGE);

  set canChallenge(bool value) => mask = mask.setBit(MASK_CAN_CHALLENGE, value);

  ///是否可以换皮肤
  bool get canTheme => mask.getBit(MASK_CAN_THEME);

  set canTheme(bool value) => mask = mask.setBit(MASK_CAN_THEME, value);

  ///是否保存游戏结果
  bool get saveGameResult => mask.getBit(MASK_SAVE_GAME_RESULT);

  set saveGameResult(bool value) =>
      mask = mask.setBit(MASK_SAVE_GAME_RESULT, value);

  Map<String, dynamic> toJson() =>
      {
        "mask": mask,
        "limit": limit,
        "limitWeekend": limitWeekend,
        "maxReject": maxReject,
        "p": pwd,
      };
  String toJsonString()=>jsonEncode(toJson());

  Config.fromJson(Map<String, dynamic> js){
    mask = js["mask"] ?? DEFAULT_MASK;
    limit = js["limit"] ?? 5;
    limitWeekend = js["limitWeekend"] ?? 20;
    maxReject = js["maxReject"] ?? 5;
    pwd = js["p"] ?? DEFAULT_PWD;
  }
  

  Config.fromPreferences(SharedPreferences pref) {
    mask = pref.getInt("mask") ?? DEFAULT_MASK;
    limit = pref.getInt("limit") ?? 5;
    limitWeekend = pref.getInt("limitWeekend") ?? 20;
    maxReject = pref.getInt("maxReject") ?? 5;
    pwd = pref.getString("p") ?? DEFAULT_PWD;
  }

  Future<void> toPreferences() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt("mask", mask);
    pref.setInt("limit", limit);
    pref.setInt("limitWeekend", limitWeekend);
    pref.setInt("maxReject", maxReject);
    pref.setString("p", pwd);
  }

  @override
  String toString() {
    return 'Config{mask: $mask, limit: $limit, limitWeekend: $limitWeekend, maxReject: $maxReject, pwd: $pwd}';
  }
}