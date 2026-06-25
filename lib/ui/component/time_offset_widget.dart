import 'package:flutter/material.dart';
import 'package:flutter/services.dart';//import 'package:flutter/services.dart';
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
  String? lastError;

  String loadDigitStringFromOffset(){
    int offset =TimeOffsetConfig.instance.offsetDay;
    String re;
    if(TimeOffsetConfig.instance.offsetDay>0){
      re = "+${TimeOffsetConfig.instance.offsetDay}";
    }else{
      re = TimeOffsetConfig.instance.offsetDay.toString();
    }
    return re;
  }

  bool setDigitStringToOffset(String userInput){
    try{
      final offset = int.parse(userInput);
      if (offset != TimeOffsetConfig.instance.offsetDay) {
        TimeOffsetConfig.instance.setOffset(offset);
      }
      return true;
    }
    catch(e){
      lastError=e.toString();
      return false;
    }
  }
  void _onOffsetChanged(){
    textController.text=loadDigitStringFromOffset();
  }

  @override
  void initState() {
    super.initState();
    textController.text=loadDigitStringFromOffset();
    focusNode.addListener(() async {
      if (!focusNode.hasFocus) {
        var newText = textController.text.trim();
        if (newText.isEmpty) {
          newText="0";
          textController.text=loadDigitStringFromOffset();
        }
        if(setDigitStringToOffset(newText)) {
          if (mounted) {
            FlutterToastr.show(localizations.timeOffsetSaved, context, duration: 2);
          }
        }else{
          textController.text=loadDigitStringFromOffset();//rollback
          if(mounted){
            FlutterToastr.show(lastError??"UnexpectedError", context,duration: 5);
            lastError=null;
          }
          return;
        }

      }
    });
    TimeOffsetConfig.instance.offsetFlushNotify.addListener(_onOffsetChanged);
  }

  @override
  void dispose() {
    TimeOffsetConfig.instance.offsetFlushNotify.removeListener(_onOffsetChanged);
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
            //border: UnderlineInputBorder(),
            border: InputBorder.none,
          ),
        ),
      ),
      const SizedBox(width: 15),
    ]);
  }
}

//--------------------------------
//TimeOffset, but in date Type.
class TimeOffsetDateWidget extends StatefulWidget {
  final TextStyle? textStyle;
  final String? title;

  const TimeOffsetDateWidget({super.key, this.textStyle, this.title});

  @override
  State<TimeOffsetDateWidget> createState() => _TimeOffsetDateWidgetState();
}

class _TimeOffsetDateWidgetState extends State<TimeOffsetDateWidget> {
  final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  String? lastError;

  String loadDateStringFromOffset(){
    int offset =TimeOffsetConfig.instance.offsetDay;
    var targetTime = DateTime.now().add(Duration(days:offset));
    String re;
    re = '${targetTime.year.toString().padLeft(4,'0')}-${targetTime.month.toString().padLeft(2,"0")}-${targetTime.day.toString().padLeft(2,"0")}';
    return re;
  }

  bool setDateStringToOffset(String userInput){
    try{
      var digits=userInput.split('-');
      if(digits.length<3){
        lastError="InvalidInputFormat";
        return false;
      }
      int iyear=int.parse(digits[0]);
      int imonth=int.parse(digits[1]);
      int iday=int.parse(digits[2]);
      if(iyear<100 && digits[0].length<=2){
        iyear+=2000;
      }
      DateTime target=DateTime(iyear,imonth,iday);
      DateTime now=DateTime.now();
      now=DateTime(now.year,now.month,now.day);
      var diff = target.difference(now);
      var offsetDays = diff.inDays;
      if(offsetDays!=TimeOffsetConfig.instance.offsetDay){
        TimeOffsetConfig.instance.setOffset(offsetDays);
      }
      return true;
    }
    catch(e){
      lastError=e.toString();
      return false;
    }
  }
  void _onOffsetChanged(){
    textController.text=loadDateStringFromOffset();
  }
  @override
  void initState() {
    super.initState();
    textController.text=loadDateStringFromOffset();

    focusNode.addListener(() async {
      if (!focusNode.hasFocus) {
        var newText = textController.text.trim();
        if (newText.isEmpty) {
          //
          //return;
          //归零
          if(TimeOffsetConfig.instance.offsetDay!=0){
            TimeOffsetConfig.instance.setOffset(0);
          }
          if (mounted) {
            FlutterToastr.show(localizations.timeOffsetSaved, context, duration: 2);
          }
          textController.text = loadDateStringFromOffset();
          return;
        }

        if (setDateStringToOffset(newText)) {
          //textController.text= loadDateStringFromOffset();//交由回调通知修改
          if (mounted) {
            FlutterToastr.show(localizations.timeOffsetSaved, context, duration: 2);
          }
        }else{
          textController.text = loadDateStringFromOffset();//rollback
          if(mounted){
            FlutterToastr.show(lastError??"UnexpectedError", context,duration: 5);
            lastError=null;
          }
          return;
        }
      }
    }
    );

    TimeOffsetConfig.instance.offsetFlushNotify.addListener(_onOffsetChanged);
  }


  @override
  void dispose() {
    TimeOffsetConfig.instance.offsetFlushNotify.removeListener(_onOffsetChanged);
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
            DateInputFormatter(),
          ],
          decoration: const InputDecoration(
            hintText: 'YYYY-MM-DD',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            //border: InputBorder.none, //use default underline
          ),
        ),
      ),
      const SizedBox(width: 15),
    ]);
  }
}


class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    // 1. 只保留数字和连字符
    String filtered;// = text.replaceAll(RegExp(r'[^\d-]'), '');
    final units = text.codeUnits; // List<int>
    final filteredUnits = units.where((c) => (c >= 0x30 && c < 0x40) || c == 0x2D).toList();
    filtered = String.fromCharCodes(filteredUnits);

    // 2. 限制最多两个连字符
    int hyphenCount = 0;//'-'.allMatches(filtered).length;
    for(int i=0;i<filteredUnits.length;++i){
      if(0x2D==filteredUnits[i]){
        hyphenCount+=1;
        if(hyphenCount>2){
          //出现第三个-
          //aaaa-bbbb-cc-
          //    1    2    3
          // 去掉多余的连字符：保留前两个的位置
          var currInedx = i;
          List<int> cutted = filteredUnits.sublist(0,currInedx);
          filtered=String.fromCharCodes(cutted);
          break;
        }
      }
    }

    // // 4. 修正光标位置（不能超过过滤后文本的长度）
    // int selectionIndex = newValue.selection.end;
    // if (selectionIndex > filtered.length) {
    //   selectionIndex = filtered.length;
    // }
    var cursorPosition=newValue.selection;
    if(cursorPosition.end>filtered.length){
      cursorPosition=TextSelection.collapsed(offset: filtered.length);
    }
    return TextEditingValue(
      text: filtered,
      selection: cursorPosition,
    );
  }
}