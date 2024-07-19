import 'dart:math';

import 'package:chess/extensions/collection_extensions.dart';
import 'package:flutter/material.dart';

class MultipleChoiceDialog<T> extends StatefulWidget {
  final Map<T, String> options;
  final Set<T>? initialChoice;
  final Set<T> _choice = {};
  final String btnSureText;
  final String btnCancelText;
  final String title;
  final bool showBtnCancel;
  final double itemWidth;

  MultipleChoiceDialog({
    super.key,
    required this.title,
    required this.options,
    required this.btnSureText ,
    required this.btnCancelText,
    required this.showBtnCancel,
    this.initialChoice,
    this.itemWidth=300
  }) {
    initialChoice?.forEach((e) => _choice.add(e));
  }

  @override
  State<StatefulWidget> createState() => _MultipleChoiceDialog();
}

class _MultipleChoiceDialog extends State<MultipleChoiceDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title,style: Theme.of(context).textTheme.titleMedium),
      content: _buildListView(context),
      actionsPadding: const EdgeInsets.only(right: 8),
      contentPadding: const EdgeInsets.only(left: 16,right: 16),
      actions: [
        if (widget.showBtnCancel)
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.btnCancelText)),
        TextButton(
            onPressed: () => Navigator.pop(context, widget._choice),
            child: Text(widget.btnSureText))
      ],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }

  Widget _buildListView(BuildContext context) {
    return SizedBox(
      width: widget.itemWidth,
      height: min((widget.options.length +2)* 30, MediaQuery.of(context).size.height*0.8),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: widget.options.map2List((entry) => CheckboxListTile(
                  value: widget._choice.contains(entry.key),
                  title: Text(entry.value),
                  onChanged: (selected) {
                    final k = entry.key;
                    setState(() {
                      if (selected == true) {
                        widget._choice.add(k);
                      } else {
                        widget._choice.remove(k);
                      }
                    });
                  })),
            ),
          )
        ],
      ),
    );
  }
}