library ns_firebase_utils;

import 'package:firebase_core/firebase_core.dart';
import 'package:ns_firebase_utils/analytics/analytics_service.dart';

import 'package:ns_firebase_utils/utils/nsf_strings.dart';

final AppAnalytics analytics = new AppAnalytics();

typedef LogCallBack = void Function(
  Object object, [
  Object detail,
]);

typedef ErrorLogCallBack = void Function(
  Object object, [
  dynamic error,
  StackTrace stackTrace,
]);

void _appLogs(
  dynamic object, [
  Object detail = "",
]) {}

void _errorLogs(Object message, [dynamic error, StackTrace? stackTrace]) {}

LogCallBack appLogsNS = _appLogs;
ErrorLogCallBack errorLogsNS = _errorLogs;

class NSFirebase {
  bool _isInitialized = false;
  String _buildNumber = NSFStrings.empty;
  String _version = NSFStrings.empty;

  bool get isInitialized => _isInitialized;

  String get buildNumber => _buildNumber;

  String get version => _version;

  static NSFirebase instance = NSFirebase();

  Future<Null> init({
    required bool printLogs,
    required String buildNumber,
    required String version,
    LogCallBack? appLogsFunction,
    ErrorLogCallBack? errorLogsFunction,
  }) async {
    if (appLogsFunction != null) {
      appLogsNS = appLogsFunction;
    }
    if (errorLogsFunction != null) {
      errorLogsNS = errorLogsFunction;
    }
    _isInitialized = true;
    _buildNumber = buildNumber;
    _version = version;
    await initializeDefault();
  }

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    appLogsNS('Initialized default app $app');
  }
}
