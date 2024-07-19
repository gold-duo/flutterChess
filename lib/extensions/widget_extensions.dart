import 'package:chess/extensions/multi_choice_dialog.dart';
import 'package:flutter/material.dart';

extension BuildContextToWidgetExt on BuildContext {
  bool get isDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;

  void closeDrawer() => Navigator.pop(this);

  Future<T?> alertDialog<T>(
      String title,
      String content, {
        String btnSureText = "确 定",
        String btnCancelText = "取 消",
        bool barrierDismissible = false,
        bool showBtnCancel=true
      }) =>
      showDialog(
          context: this,
          // barrierLabel:"barrierLabel",//遮罩语义标签
          barrierDismissible: barrierDismissible, //点遮罩是否取消
          builder: (context) => AlertDialog(
            title: Text(title,style: Theme.of(context).textTheme.titleMedium),
            content: Text(content,style: Theme.of(context).textTheme.bodyMedium),
            actionsPadding: const EdgeInsets.only(right: 8),
            actions: [
              if(showBtnCancel)
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child:Text(btnCancelText)),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(btnSureText))
            ],
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ));

  Future<String?> promptDialog(
      String title,
      {
        String? message,
        String? hintText,
        bool obscureText=false,//
        String btnSureText = "确 定",
        String btnCancelText = "取 消",
        TextInputType keyboardType=TextInputType.text,
        bool barrierDismissible = false,
        bool showBtnCancel=true
      }) {
    final controller=TextEditingController();
    return showDialog(
        context: this,
        // barrierLabel:"barrierLabel",//遮罩语义标签
        barrierDismissible: barrierDismissible, //点遮罩是否取消
        builder: (context) => AlertDialog(
          title: Text(title,style: Theme.of(context).textTheme.titleMedium),
          content: Flex(direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(message!=null&&message.isNotEmpty) Text(message,style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType:keyboardType,
                onSubmitted: (value)=> Navigator.pop(context, value),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    fillColor: Colors.blue,
                    filled: false),
              )
            ],
          ),
          titlePadding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
          contentPadding:const EdgeInsets.fromLTRB(10, 0, 10, 0),
          actionsPadding: const EdgeInsets.only(right: 8),
          insetPadding:const EdgeInsets.all(0),
          actions: [
            if(showBtnCancel)
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:Text(btnCancelText)),
            TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text(btnSureText))
          ],
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ));
  }

  Future<Set<T>?> multipleChoiceDialog<T>(
          String title,
          Map<T, String> options,
          {Set<T>? initialChoice,
          String btnSureText = "确 定",
          String btnCancelText = "取 消",
          bool barrierDismissible = false,
          bool showBtnCancel = true}) =>
      showDialog<Set<T>?>(
          context: this,
          barrierDismissible:barrierDismissible,
          builder: (ctx) => MultipleChoiceDialog(
              title: title,
              options: options,
              initialChoice: initialChoice,
              btnSureText: btnSureText,
              btnCancelText: btnCancelText,
              showBtnCancel: showBtnCancel));

  Future<V?> optionsDialog<V>(String title, List<String> options,{bool barrierDismissible = false}) =>
      showDialog(
          context: this,
          barrierDismissible:barrierDismissible,
          builder: (ctx)=>SimpleDialog(
            title: title.toText,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            children: options.buildSimpleOptions(this),
          ));

  Future<T?> modalBottomSheet<T>(String content,
          {IconData? icon = Icons.info, String btnCloseText = "知道了"}) =>
      showModalBottomSheet(
          elevation: 6,
          context: this,
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(6)),
          builder: (ctx) => Padding(
              padding: const EdgeInsets.all(6),
              child: ListTile(
                leading: icon?.toIcon,
                title: content.toText,
                trailing: TextButton(
                    child: btnCloseText.toText,
                    onPressed: () => Navigator.pop(this, true)),
              )));

  ScaffoldFeatureController showSnackBar(String content,
          {SnackBarBehavior behavior = SnackBarBehavior.floating,
          bool showCloseIcon = true}) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
          content: content.toText,
          behavior: behavior,
          showCloseIcon: showCloseIcon,
          closeIconColor: isDarkMode ? Colors.black:Colors.white));

  Widget loadingView({String tips="loading ... "}){
    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(6)),
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                    height: 88,
                    width: 88,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      strokeWidth: 6,
                      valueColor:const AlwaysStoppedAnimation(Colors.blue),
                    )),
                Text(tips)
              ],
            ),
          )
        ]);
  }
  void loadingDialog({String? key,bool barrierDismissible=false,bool physicalCanDismiss=true,String tips="loading ... "}){
    final Widget widget=loadingView(tips: tips);
    showDialog(
        context: this,
        barrierColor: Colors.black.withOpacity(0.8),
        barrierDismissible: barrierDismissible,
        builder: (ctx) => AlertDialog(
            backgroundColor: Colors.transparent,
            content: physicalCanDismiss
                ? widget
                : PopScope(
                    canPop: false,
                    child: widget)));
  }
}

extension StringToWidgetExt on String {
  Text get toText => Text(this);

  Image get toImage => Image.network(this);

  TextButton toTextButton({VoidCallback? onPress}) =>
      TextButton(onPressed: onPress, child: Text(this));

  ElevatedButton toElevatedButton({VoidCallback? onPress}) =>
      ElevatedButton(onPressed: onPress, child: Text(this));
}

extension MapToWidgetExt<K> on Map<K, String> {
  List<PopupMenuEntry<K>> buildPopupMenuItems({PopupMenuItem<K> Function(K key,String value)? builder,bool showDivider=true}) {
    if (isEmpty) return [];
    final int last = length - 1;
    final List<PopupMenuEntry<K>> result = [];
    int i=0;
    for(MapEntry<K,String> it in entries){
      result.add(builder==null? PopupMenuItem(value: it.key, child: it.value.toText) : builder(it.key,it.value));
      if (showDivider && i != last) result.add(const PopupMenuDivider());
      ++i;
    }
    return result;
  }

  List<PopupMenuEntry<K>> buildCheckedPopupMenuItems ({CheckedPopupMenuItem<K> Function(K key,String value)? builder,bool showDivider=true}) {
    if (isEmpty) return [];
    final int last = length - 1;
    final List<PopupMenuEntry<K>> result = [];
    int i=0;
    for (final it in entries) {
      result.add(builder==null? CheckedPopupMenuItem(value: it.key, child: it.value.toText) : builder(it.key,it.value));
      if (showDivider && i != last) result.add(const PopupMenuDivider());
      ++i;
    }
    return result;
  }
}

extension ListStringToWidgetItems on List<String>{
  List<PopupMenuEntry<int>> buildPopupMenuItems({PopupMenuItem<int> Function(int index,String value)? builder,bool showDivider=false}) {
    if (isEmpty) return [];
    final int last = length - 1;
    final List<PopupMenuEntry<int>> result = [];

    for (int i = 0; i <= last; i++) {
      final it = this[i];
      result.add(builder==null? PopupMenuItem(value: i, child: it.toText) : builder(i,it));
      if (showDivider && i != last) result.add(const PopupMenuDivider());
    }
    return result;
  }

  List<PopupMenuEntry<int>> buildCheckedPopupMenuItems({CheckedPopupMenuItem<int> Function(int index,String value)? builder,bool showDivider=false}) {
    if (isEmpty) return [];
    final int last = length - 1;
    final List<PopupMenuEntry<int>> result = [];
    for (int i = 0; i <= last; i++) {
      final it = this[i];
      result.add(builder==null? CheckedPopupMenuItem(value:i, child: it.toText) : builder(i,it));
      if (showDivider && i != last) result.add(const PopupMenuDivider());
    }
    return result;
  }
  List<Widget> buildSimpleOptions(BuildContext context,{SimpleDialogOption Function(String value)? builder,bool showDivider=false}) {
    if (isEmpty) return [];
    final List<Widget> result = [];
    for (int i = 0; i < length; i++) {
      final it = this[i];
      if(showDivider)result.add(const Divider());
      result.add(builder==null? SimpleDialogOption( child: it.toText,onPressed: ()=>Navigator.pop(context,i)) : builder(it));
    }
    return result;
  }

  List<DropdownMenuEntry<int>> buildDropdownMenuEntries({DropdownMenuEntry<int> Function(int index,String value)? builder}){
    if (isEmpty) return [];
    final List<DropdownMenuEntry<int>> result = [];
    for (int i = 0; i < length; i++) {
      final it = this[i];
      result.add(builder==null? DropdownMenuEntry<int>(value:i, label: it) : builder(i,it));
    }
    return result;
  }

  List<DropdownMenuItem<int>> buildDropdownMenuItems({DropdownMenuItem<int> Function(int index,String value)? builder}){
    if (isEmpty) return [];
    final List<DropdownMenuItem<int>> result = [];
    for (int i = 0; i < length; i++) {
      final it = this[i];
      result.add(builder==null? DropdownMenuItem<int>(value:i, child: it.toText) : builder(i,it));
    }
    return result;
  }
}

extension IconDataStringToWidgetExt<T> on (IconData, String) {
  BottomNavigationBarItem get toBottomNavigationBarItem =>
      BottomNavigationBarItem(icon: Icon($1), label: $2);

  NavigationDestination get toNavigationDestination =>
      NavigationDestination(icon: Icon($1), label: $2);
}

extension IconDataToWidgetExt on IconData {
  Icon get toIcon => Icon(this);
}

extension ListIconDataToWidgetExt<T> on List<(IconData, String)> {
  List<BottomNavigationBarItem> get toBottomNavigationBarItems =>
      map((it) => BottomNavigationBarItem(icon: Icon(it.$1), label: it.$2))
          .toList(growable: false);

  List<NavigationDestination> get toNavigationDestinations =>
      map((it) => NavigationDestination(icon: Icon(it.$1), label: it.$2))
          .toList(growable: false);
}