
import 'package:chess/extensions/collection_extensions.dart';
import 'package:chess/extensions/provider_extensions.dart';
import 'package:chess/extensions/widget_extensions.dart';
import 'package:chess/model/config.dart';
import 'package:chess/component/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/play_game_info.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPage();
}
typedef ConfigNotifier=ValueNotifierEx<Config>;
typedef PlayGameInfoNotifier=ValueNotifierEx<PlayGameInfo>;
class _SettingPage extends State<SettingPage> {
  bool _configChanged=false;
  bool _playInfChanged=false;
  static const difficultyMap = {0: '入门', 1: '中级', 2: '高手'};
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final config = args['config'] as Config;
    final playInfo = args['playInfo'] as PlayGameInfo;
    
    return PopScope(
    canPop:false,
    onPopInvoked: (didPop)async{
        if(didPop)return;
        if(!_configChanged&&!_playInfChanged){
          Navigator.pop(context);
          return;
        }
        context.loadingDialog(physicalCanDismiss: false);
        final Map<String,dynamic> r={};
        if(_configChanged){
          await config.toPreferences();
          r['config']=config;
        }
        if(_playInfChanged){
          await playInfo.toPreferences();
          await playInfo.toFile();
          r['playInfo']=playInfo;
        }
        Navigator.pop(context);
        Navigator.pop(context,r);
      },
      child: Scaffold(
      appBar: AppBar(
        title: "设置".toText,
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (ctx) => ValueNotifier<Config>(config)),
          ChangeNotifierProvider(
              create: (ctx) => ValueNotifier<PlayGameInfo>(playInfo))
        ],
        child: _buildFlex(context),
      ),
    ));
  }

  Widget _buildFlex(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
            child: ListView(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
          shrinkWrap: true,
          children: [
            _buildDifficulty(context),
            const SizedBox(height: 6),
            _buildLimit(context),
            const SizedBox(height: 6),
            _buildLimitWeekend(context),
            const SizedBox(height: 6),
            _buildMaxReject(context),
            const SizedBox(height: 6),
            _buildCanTheme(context),
            const SizedBox(height: 6),
            _buildCanChallenge(context),
            const SizedBox(height: 6),
            _buildPassword(context),
            const SizedBox(height: 6),
            _buildGameTimes(context)
          ],
        ))
      ],
    );
  }

  Widget _buildDifficulty(BuildContext context){
    return Selector<ConfigNotifier, Set<int>>(
        selector: (ctx, vn) => vn.value.difficulty,
        builder: (ctx, difficulty, child) => SettingItem(
            name: "难易程度",
            summary: difficulty.map2List((it) => difficultyMap[it]).join(','),
            onClick: (ctx) async {
              final set = await ctx.multipleChoiceDialog("难易程度", difficultyMap,initialChoice: difficulty);
              if (set != null && set.isNotEmpty&& !set.equalTo(difficulty)) {
                final vn = ctx.read<ConfigNotifier>();
                vn.value.difficulty = set;
                _configChanged=true;
                vn.markDirty();
              }
            }));
  }

  Widget _buildLimit(BuildContext context){
    return Selector<ConfigNotifier, int>(
        selector: (ctx, vn) => vn.value.limit,
        builder: (ctx, limit, child) => SettingItem(
            name: "每天限制棋局数",
            summary: limit.toString(),
            onClick: (ctx) async {
              final str = await ctx.promptDialog("每天限制棋局数",keyboardType: TextInputType.number, hintText: limit.toString());
              if (str != null && str.isNotEmpty) {
                final num = int.parse(str);
                if (num > 0 && num <= 10) {
                  if(num==limit)return;
                  final vn = ctx.read<ConfigNotifier>();
                  vn.value.limit = num;
                  _configChanged=true;
                  vn.markDirty();
                } else {
                  ctx.showSnackBar("请输入1-10的数字");
                }
              }
            }));
  }
  Widget _buildLimitWeekend(BuildContext context){
    return Selector<ConfigNotifier, int>(
        selector: (ctx, vn) => vn.value.limitWeekend,
        builder: (ctx, limitWeekend, child) => SettingItem(
            name: "周六日限制棋局数",
            summary: limitWeekend.toString(),
            onClick: (ctx) async {
              final str = await ctx.promptDialog("周六日棋局数限制",keyboardType: TextInputType.number, hintText: limitWeekend.toString());
              if (str != null && str.isNotEmpty) {
                final num = int.parse(str);
                if (num > 0 && num <= 20) {
                  if(num==limitWeekend)return;
                  final vn = ctx.read<ConfigNotifier>();
                  vn.value.limitWeekend = num;
                  _configChanged=true;
                  vn.markDirty();
                } else {
                  ctx.showSnackBar("请输入1-20的数字");
                }
              }
            }));
  }
  Widget _buildMaxReject(BuildContext context){
    return Selector<ConfigNotifier, int>(
        selector: (ctx, vn) => vn.value.maxReject,
        builder: (ctx, maxReject, child) => SettingItem(
            name: "最大悔棋步数",
            summary: maxReject.toString(),
            onClick: (ctx) async {
              final str = await ctx.promptDialog("周六日棋局数限制",keyboardType: TextInputType.number, hintText: maxReject.toString());
              if (str != null && str.isNotEmpty) {
                final num = int.parse(str);
                if (num > 0 && num <= 20) {
                  if(num==maxReject)return;
                  final vn = ctx.read<ConfigNotifier>();
                  vn.value.maxReject = num;
                  _configChanged=true;
                  vn.markDirty();
                } else {
                  ctx.showSnackBar("请输入1-20的数字");
                }
              }
            }));
  }
  Widget _buildCanTheme(BuildContext context)=>Selector<ConfigNotifier, bool>(builder: (ctx,canTheme,child){
      return SwitchListTile(
          title: "可换肤".toText,
          value: canTheme,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (v) {
            final vn = ctx.read<ConfigNotifier>();
            vn.value.canTheme = v;
            _configChanged = true;
            vn.markDirty();
          });
    },
    selector: (ctx, vn) => vn.value.canTheme);
  Widget _buildCanChallenge(BuildContext context)=>Selector<ConfigNotifier, bool>(builder: (ctx,canChallenge,child){
      return SwitchListTile(
          title: "可挑战棋局".toText,
          value: canChallenge,
          controlAffinity:ListTileControlAffinity.trailing,
          onChanged: (v) {
            final vn = ctx.read<ConfigNotifier>();
            vn.value.canChallenge = v;
            _configChanged = true;
            vn.markDirty();
          });
    }, selector: (ctx,vn)=>vn.value.canChallenge);
  Widget _buildPassword(BuildContext context)=>Selector<ConfigNotifier,String>(
      selector: (ctx, vn) => vn.value.pwd,
      builder: (ctx, pwd, child) => SettingItem(
          name: "pwd",
          onClick: (ctx) async {
            final str = await ctx.promptDialog("pwd", hintText:pwd,obscureText:true);
            if (str != null ) {
              if (str.isNotEmpty) {
                if(str==pwd)return;
                final vn = ctx.read<ConfigNotifier>();
                vn.value.pwd = str;
                _configChanged=true;
                vn.markDirty();
              } else {
                ctx.showSnackBar("不能输入空pwd");
              }
            }
          }));
  Widget _buildGameTimes(BuildContext context)=> Selector<PlayGameInfoNotifier,int>(builder: (ctx,gameTimes,child)=>SettingItem(
      name: "今天已下棋局数",
      summary: gameTimes.toString(),
      onClick:(ctx) async {
        final str = await ctx.promptDialog("今天已下棋局数",keyboardType:TextInputType.number, hintText:gameTimes.toString());
        if(str!=null&& str.isNotEmpty){
          final num=int.parse(str);
          if(num>=0){
            if(num==gameTimes)return;
            final vn=ctx.read<PlayGameInfoNotifier>();
            vn.value.gameTimes=num;
            _playInfChanged=true;
            vn.markDirty();
          }else{
            ctx.showSnackBar("请输入大于0数字");
          }
        }
      }), selector: (ctx,runtimeInfo)=>runtimeInfo.value.gameTimes);
}
