import 'package:chess/chess/engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess/chess/bot.dart';
import 'package:chess/chess/chess_theme.dart';
import 'package:chess/component/chess_controller.dart';
import 'package:chess/component/chessboard.dart';
import 'package:chess/extensions/collection_extensions.dart';
import 'package:chess/extensions/widget_extensions.dart';

class ChessPage extends StatefulWidget {
  const ChessPage({super.key});
  @override
  State<StatefulWidget> createState() => _ChessPage();
}

class _ChessPage extends State<ChessPage> {
  int _themeIndex=1;
  int _grade=0;
  static const int maxGameBack=5;
  int _gameBackCount=0;
  bool _gameCanBack=false;
  ChessTheme _chessTheme = ChessTheme(ChessTheme.woods);
  final ChessController _chessController=ChessController();
  static const dbg=kDebugMode;
  static const tag = '[Chess.ChessPage]';
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return; //走系统路由
          final NavigatorState navigator = Navigator.of(context,rootNavigator: true);
          final bool? r=await context.alertDialog('象棋','确定退出吗？');
          if(r!=true) return;
          if(navigator.canPop()){
            
            navigator.pop();
          }
          await _forceExitApp();
          
        },
        child: Scaffold(
          body: _buildBody(context),
          drawer: _buildDrawer(),
          endDrawer: _buildDrawer(),
        ));
  }

  Widget _buildDrawer() => Drawer(
      child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Flex(direction: Axis.vertical, children: [
            UserAccountsDrawerHeader(
              // arrowColor: Colors.lightGreen,
              accountName: const Text("象棋"),
              accountEmail: const Text("gold.duo@gmail.com"),
              currentAccountPicture: Image.asset('assets/themes/woods/rk.png',fit: BoxFit.cover),
              // otherAccountsPictures: [
              //   Image.network('https://gold-duo.github.io/assets/logo.png'),
              //   Image.network('https://gold-duo.github.io/assets/logo.png'),
              // ],
            ),
            Expanded(child: _buildMenu(context))
          ])));

  Widget _buildMenu(BuildContext ctx) => SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSelectedTheme(),
                _buildGrade(),
                ListTile(leading: const Icon(Icons.abc_outlined), title: const Text("关于"),onTap: (){
                  Navigator.pop(context);
                  showAboutDialog(context:context,applicationName: "Chess",
                      applicationVersion: "1.0.0",
                      applicationIcon: Image.asset('assets/themes/woods/rk.png',fit: BoxFit.cover),
                      applicationLegalese: "Copyright ©2024 gold-duo.All rights reserved.");
                }),
                ListTile(leading: const Icon(Icons.exit_to_app_sharp),
                    title: const Text("退出"),
                    onTap: () async => await _forceExitApp()),
                // exit(0);,
          ])));

  Widget _buildSelectedTheme(){
    final List<String> list= List.unmodifiable(['古典', '木纹']);
    Widget child=Flex(
        direction: Axis.horizontal,
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.theater_comedy_sharp),
          const SizedBox(width: 18),
          DropdownButton(
              value: _themeIndex,
              selectedItemBuilder: (ctx) => list.map2List((v) => DropdownMenuItem(
                      child: Text('棋盘风格  $v',style: Theme.of(context).textTheme.bodyLarge,
                  ))),
              icon: const Icon(Icons.arrow_drop_down),
                  items: list.buildDropdownMenuItems(),
                  onChanged: (value) {
                    if(value==null||value<0||value>=list.length ||_themeIndex==value) return;
                    setState(() {
                      _themeIndex=value;
                      final name = [ChessTheme.classical, ChessTheme.woods][_themeIndex];
                      _chessTheme=ChessTheme(name);
                    });
              })
        ]
    );
    return child;
  }
  Widget _buildGrade(){
    final List<String> list= List.unmodifiable(['小白', '中级', '高手','大师']);
    Widget child=Flex(
        direction: Axis.horizontal,
        children: [
          const SizedBox(width:  16),
          const Icon(Icons.grade_sharp),
          const SizedBox(width: 18),
          DropdownButton(
              value: _grade,
              selectedItemBuilder: (ctx) => list.map2List( (v)=>DropdownMenuItem(
                  child: Text( '难度  $v', style: Theme.of(context).textTheme.bodyLarge, )) ),
              icon: const Icon(Icons.arrow_drop_down),
              items: list.buildDropdownMenuItems(),
              onChanged: (value) {
                if(value==null||value<0||value>=list.length ||_themeIndex==value) return;
                setState(() {
                  _grade=value;
                });
              })
        ]
    );
    return child;
  }
  Widget _buildBody(BuildContext context) {
    if (!_chessTheme.loaded) {
      _chessTheme.load(context, (success) => setState(() {}));
      return Center(child: context.loadingView());
    }
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(color: Color(_chessTheme.bgColor)),
      child: Align(
        
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize:MainAxisSize.min,
          children: [
            Chessboard(chessTheme: _chessTheme,
                chessController:_chessController,
                onGameOver: _onGameOver,
                onGameStart: _onGameStart,
                onChessboardUpdated:_onChessboardUpdated,
            ),
            const SizedBox(height: 40),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final bool? r = _gameCanBack ? await context.alertDialog("象棋", '确定要重新开始吗？') : true;
                      if (r == true) _chessController.restart();
                    },
                    child: const Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.restart_alt_sharp),
                          Text("新对局")
                        ])),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                          if (!_gameCanBack) return;
                          if (_gameBackCount >= maxGameBack){
                            context.showSnackBar("已经超过最大悔棋数($maxGameBack)啦！");
                            return;
                          }
                          ++_gameBackCount;
                          _chessController.back();
                        },
                    child: const Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.restore_sharp), Text("悔  棋")]
                    ))
              ]
            )
          ]
        )
      )
    );
  }

  void _onChessboardUpdated(bool canBack){
    _gameCanBack=canBack;
  }
  void _onGameStart(bool restart){
    _gameCanBack=false;
    _gameBackCount=0;
  }
  void _onGameOver(bool playerWin){
    _gameCanBack=false;
    context.alertDialog( '象棋',playerWin?"恭喜您，您赢了！":'很遗憾，您输了！',showBtnCancel: false);
  }

  Future<void> _forceExitApp() async {
    _beforeDispose();
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
  void _beforeDispose(){
    try {
      _chessController.dispose();
    }catch (s){}
    Bot.release();
    
  }
  @override
  void dispose() {
    _beforeDispose();
    super.dispose();
  }
}
