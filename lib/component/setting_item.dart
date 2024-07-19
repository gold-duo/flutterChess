import 'package:chess/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

typedef OnClick= void Function(BuildContext context);

class SettingItem extends StatefulWidget{
  final bool enable;
  final String name;
  String? summary;
  final OnClick?  onClick;
  SettingItem({super.key, required this.name, this.onClick, this.enable=true,this.summary});

  @override
  State<StatefulWidget> createState()=>_SettingItem();
}
class _SettingItem extends State<SettingItem>{
  @override
  Widget build(BuildContext context) =>ListTile(
    title: widget.name.toText,
    subtitle: ('\t\t${widget.summary??""}').toText,
    onTap: !widget.enable || widget.onClick == null? null: ()=>widget.onClick!(context),
    trailing: const Icon(Icons.arrow_right),
    hoverColor:Colors.blueGrey,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );
}