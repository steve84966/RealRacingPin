import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:proxypin/network/util/logger.dart';

/// 全局时间偏移配置（毫秒），单例
class TimeOffsetConfig {
  static TimeOffsetConfig? _instance;
  static TimeOffsetConfig get instance => _instance ??= TimeOffsetConfig._();

  TimeOffsetConfig._();

  static final int dayToMs=24*60*60*1000;
  static final String _fileName="offset_depot.json";
  static final String _keyName="offsetDay_dpt";

  int _offsetMs = 0;
  int _offsetDay=0;

  int get offsetMs => _offsetMs;
  int get offsetDay=>_offsetDay;

  set offsetDay(int offset){
    _offsetDay=offset;
    _offsetMs=_offsetDay*dayToMs;
  }

  /// 设置偏移量并持久化
  Future<void> setOffset(int offset) async {
    offsetDay = offset;
    await _saveToFile();
  }

  /// 加载配置（应用启动时调用一次）
  Future<void> load() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$_fileName');
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        offsetDay = json[_keyName] as int? ?? 0;
      }
    } catch (e, st) {
      logger.e('Failed to load time offset config', error: e, stackTrace: st);
      offsetDay = 0;
    }
  }

  Future<void> _saveToFile() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$_fileName');
      await file.writeAsString(jsonEncode({_keyName: _offsetDay}));
    } catch (e, st) {
      logger.e('Failed to save time offset config', error: e, stackTrace: st);
    }
  }
}