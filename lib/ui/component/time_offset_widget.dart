import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:proxypin/l10n/app_localizations.dart';
import 'package:proxypin/network/util/time_offset_config.dart';

class TimeOffsetWidget extends StatefulWidget {
  final TextStyle? textStyle;
  final String? title;

  const TimeOffsetWidget({super.key, this.textStyle, this.title});

  @override
  State<TimeOffsetWidget> createState() => _TimeOffsetWidgetState();
}

class _TimeOffsetWidgetState extends State<TimeOffsetWidget> {
  final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    if(TimeOffsetConfig.instance.offsetDay>0){
      textController.text = "+${TimeOffsetConfig.instance.offsetDay}";
    }else{
      textController.text = TimeOffsetConfig.instance.offsetDay.toString();
    }
    focusNode.addListener(() async {
      if (!focusNode.hasFocus) {
        var newText = textController.text.trim();
        if (newText.isEmpty) {
          textController.text = '0';
          newText="0";
        }
        final offset = int.tryParse(newText);
        if (offset == null) {
          FlutterToastr.show(localizations.invalidNumber, context, duration: 3);
          textController.text = TimeOffsetConfig.instance.offsetDay.toString();
          return;
        }
        if (offset != TimeOffsetConfig.instance.offsetDay) {
          await TimeOffsetConfig.instance.setOffset(offset);
          if (mounted) {
            FlutterToastr.show(localizations.timeOffsetSaved, context, duration: 2);
            String digitstr;
            if(TimeOffsetConfig.instance.offsetDay>0){
              digitstr="+${TimeOffsetConfig.instance.offsetDay}";
            }else{
              digitstr=TimeOffsetConfig.instance.offsetDay.toString();
            }
            textController.text=digitstr;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(padding: EdgeInsets.only(left: 15)),
      Text(widget.title ?? localizations.timeOffset, style: widget.textStyle),
      const SizedBox(width: 16),
      Expanded(
        child: TextFormField(
          focusNode: focusNode,
          controller: textController,
          textAlign: TextAlign.right,
          onTapOutside: (event) => focusNode.unfocus(),
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.allow(RegExp(r'^[-+]?\d*$')),
          ],
          decoration: const InputDecoration(
            hintText: '+/- days',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: UnderlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 15),
    ]);
  }
}