library ns_firebase_utils;

import 'package:firebase_core/firebase_core.dart';
import 'package:ns_firebase_utils/analytics/analytics_service.dart';

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
  Object detail = '',
]) {}

void _errorLogs(Object message, [dynamic error, StackTrace? stackTrace]) {}

LogCallBack appLogsNS = _appLogs;
ErrorLogCallBack errorLogsNS = _errorLogs;

class NSFirebase {
  bool _isInitialized = false;
  String _buildNumber = '';
  String _version = '';

  bool get isInitialized => _isInitialized;

  String get buildNumber => _buildNumber;

  String get version => _version;

  static NSFirebase instance = NSFirebase();

  Future<void> init({
    required bool printLogs,
    required String buildNumber,
    required String version,
    LogCallBack? appLogsFunction,
    ErrorLogCallBack? errorLogsFunction,
    FirebaseOptions? options,
    String? name,
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

    await initializeDefault(
      options: options,
      name: name,
    );
  }
}

Future<void> initializeDefault({
  FirebaseOptions? options,
  String? name,
}) async {
  FirebaseApp app = await Firebase.initializeApp(
    options: options,
    name: name,
  );
  appLogsNS('Initialized default app $app');
}
