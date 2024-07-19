import 'package:chess/page/chess_page.dart';
import 'package:chess/page/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, // 竖屏 Portrait 模式
      DeviceOrientation.portraitDown,
// DeviceOrientation.landscapeLeft, // 横屏 Landscape 模式
// DeviceOrientation.landscapeRight,
    ],
  );
  // runZoned(()=>runApp(MyApp()),zoneSpecification:ZoneSpecification(
  //   // 拦截print
  //   print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
  //     parent.print(zone, "Interceptor: $line");
  //   },
  //   // 拦截未处理的异步错误
  //   handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone, Object error, StackTrace stackTrace) {
  //     debugPrintStack(stackTrace:stackTrace);
  //     parent.print(zone, '${error.toString()} $stackTrace');
  //   },
  // ) );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final pages = {
    // '/web': (context) => const WebViewPage(),
    '/chess': (context) => const ChessPage(),
    '/setting': (context) => const SettingPage(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: '象棋',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:const WebViewPage(),
        initialRoute:'/chess',//初始化导航到HomePage
        routes:pages
        // onGenerateRoute: (it) {
        //   final Function? f = pages[it.name];
        //   if (f == null) return null;
        //   final arg=it.arguments;
        //   return MaterialPageRoute(
        //       builder: arg == null? (c) => f(c) : (c) => f(c, arg)
        //   );
        // }
    );
  }
}
