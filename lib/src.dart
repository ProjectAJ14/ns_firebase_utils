library ns_firebase_utils;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ns_firebase_utils/analytics/analytics_service.dart';
import 'package:ns_firebase_utils/utils/logs.dart';
import 'package:ns_firebase_utils/utils/nsf_strings.dart';

final AppAnalytics analytics = new AppAnalytics();

class NSFirebase {
  bool _isInitialized = false;
  bool _printLogs = false;
  String _buildNumber = NSFStrings.empty;
  String _version = NSFStrings.empty;

  bool get isInitialized => _isInitialized;

  bool get printLogs => _printLogs;

  String get buildNumber => _buildNumber;

  String get version => _version;

  static NSFirebase instance = NSFirebase();

  Future<Null> init({
    @required bool printLogs,
    @required String buildNumber,
    @required String version,
  }) async {
    _isInitialized = true;
    _printLogs = printLogs;
    _buildNumber = buildNumber;
    _version = version;
    await initializeDefault();
  }

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    nsfLogs('Initialized default app $app');
  }
}
