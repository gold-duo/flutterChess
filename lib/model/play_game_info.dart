import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:downloadsfolder/downloadsfolder.dart';

class PlayGameInfo {
  static const String fileName="__chess.txt";
   int date;
  int gameTimes;
  PlayGameInfo(this.date, this.gameTimes);

  PlayGameInfo.fromJson(Map<String, dynamic> m)
      : date = m["date"] ?? today,
        gameTimes = m["gameTimes"] ?? 0;

  void updateByJson(String json){
    final js=jsonDecode(json);
    final d=js["date"];
    if(d!=null) date=d;
    final t=js["gameTimes"];
    if(t!=null) gameTimes=t;
  }

  Map<String, dynamic> toJson() => {"date": date, "gameTimes": gameTimes};

  String toJsonString()=>jsonEncode(toJson());

  PlayGameInfo.fromPreferences(SharedPreferences pref) :
    date = pref.getInt("date") ?? 0,
    gameTimes = pref.getInt("gameTimes") ??0;


  Future<void> toPreferences() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt("date", date);
    pref.setInt("gameTimes", gameTimes);
  }

  static Future<PlayGameInfo?> fromFile() async {
    try {
      final file = await _downloadPath;
      if (file == null) return Future.value(null);
      final f = File(file.endsWith(Platform.pathSeparator) ? file + fileName : "$file${Platform.pathSeparator}$fileName");
      if(!f.existsSync()) return Future.value(null);
      final String str = await f.readAsString();
      if (str.isNotEmpty) {
        final item = str.split(",");
        if (item.length == 2) {
          final date = int.tryParse(item[0]);
          final times = int.tryParse(item[1]);
          if ( times != null) {
            return Future.value(PlayGameInfo(date!, times));
          }
        }
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
    }
    return Future.value(null);
  }

  Future<bool> toFile() async {
    try {
      final file = await _downloadPath;
      if (file == null) return Future.value(false);

      final f = File(file.endsWith(Platform.pathSeparator)
          ? file + fileName
          : "$file${Platform.pathSeparator}$fileName").absolute;
      // if(kDebugMode) debugPrint("toFile--${f.isAbsolute},${f.absolute.path}");
      f.writeAsStringSync("$date,$gameTimes",flush: true);
      return Future.value(true);
    }catch(e,s){
      debugPrintStack(stackTrace: s);
    }
    return Future.value(false);
  }


  static Future<PlayGameInfo> load() async {
    final today=PlayGameInfo.today;
    var r=await PlayGameInfo.fromFile();
    if(r!=null&& r.date!=today){
      r=null;
    }
    r ??= PlayGameInfo.fromPreferences(await SharedPreferences.getInstance());
    if(r.date!=today){
      r.date=today;
      r.gameTimes=0;
    }
    return Future.value(r);
  }
  static int get today{
    final d=DateTime.now();
    final str = "${d.year.toString().padLeft(4,'0')}${d.month.toString().padLeft(2,'0')}${d.day.toString().padLeft(2,'0')}";
    return int.parse(str);
  }

  static Future<String?> get _downloadPath async {
    String? downloadDirectoryPath = await getDownloadDirectoryPath();
    if(downloadDirectoryPath==null)return Future.value(null);
    final f=Directory(downloadDirectoryPath).absolute;
    
    return Future.value(f.path);
  }

  @override
  String toString() {
    return 'RuntimeInfo{date: $date, gameTimes: $gameTimes}';
  }
}