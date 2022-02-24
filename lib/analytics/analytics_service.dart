import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:ns_firebase_utils/utils/nsf_exception.dart';
import 'package:ns_firebase_utils/utils/nsf_keys.dart';
import 'package:ns_firebase_utils/utils/nsf_strings.dart';

import '../src.dart';

class AppAnalytics implements FirebaseAnalytics {
  final FirebaseAnalytics _firebaseAnalytics;

  AppAnalytics() : _firebaseAnalytics = FirebaseAnalytics.instance;

  Map<String, dynamic> _userInfo = Map();

  Future<void> setUser({
    required String id,
    required String email,
  }) async {
    appLogsNS("setUser:$id");
    await setUserId(
      id: id,
    );
    await setUserProperty(
      name: 'email',
      value: email,
    );
    _userInfo = {
      NSFKeys.id: id,
      NSFKeys.email: email,
    };
  }

  Future<void> log(
      {required String eventName,
      String? category,
      Map<String, dynamic>? parameters}) async {
    if (parameters == null) {
      parameters = <String, dynamic>{};
    }
    if (category == null) {
      category = NSFStrings.empty;
    }
    await logEvent(name: eventName, category: category, parameters: parameters);
  }

  @override
  Future<void> logAppOpen({AnalyticsCallOptions? callOptions}) {
    if (!NSFirebase.instance.isInitialized)
      throw NSFException(
        code: 'NSFirebase_not_initialized',
        message: 'Please Initialized NSFirebase',
      );
    return _firebaseAnalytics.logAppOpen(
      callOptions: callOptions,
    );
  }

  @override
  Future<void> logEvent({
    String? name,
    String? category,
    Map<String, dynamic>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {
    name = name?.replaceAll(new RegExp(r' '), '_'); // name cannot use '-'
    category = category?.replaceAll(new RegExp(r' '), '_');

    final eventName =
        category == null || category == '' ? name! : "${name}_$category";

    // TODO: needs to get this from the config or app version or A/B testing version
    if (parameters == null) {
      parameters = <String, dynamic>{};
    }

    String buildStr = NSFirebase.instance.buildNumber;
    String versionStr = NSFirebase.instance.version;
    parameters.putIfAbsent(
        NSFKeys.version, () => versionStr + NSFKeys.dash + buildStr);

    if (_userInfo.isNotEmpty) {
      parameters.putIfAbsent(NSFKeys.id, () => _userInfo[NSFKeys.id]);
      parameters.putIfAbsent(NSFKeys.email, () => _userInfo[NSFKeys.email]);
    }

    Map<String, dynamic> newParameters = Map<String, dynamic>();
    // Remove null
    parameters.forEach((key, dynamic value) {
      if (value != null) {
        newParameters.putIfAbsent(key, () => value);
      }
    });
    appLogsNS("eventName:$eventName");
    newParameters.putIfAbsent(
        'date_time', () => DateTime.now().toIso8601String());
    // TODO: need to avoid parameters contains List value. This causes exception
    await _firebaseAnalytics.logEvent(
      name: eventName,
      parameters: newParameters,
      callOptions: callOptions,
    );
  }

  @override
  Future<void> logJoinGroup({
    required String groupId,
    AnalyticsCallOptions? callOptions,
  }) async {
    await _firebaseAnalytics.logJoinGroup(
      groupId: groupId,
      callOptions: callOptions,
    );
  }

  @override
  Future<void> logLogin({
    String? loginMethod,
    AnalyticsCallOptions? callOptions,
  }) async {
    await _firebaseAnalytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logSignUp({required String signUpMethod}) async {
    await _firebaseAnalytics.logSignUp(signUpMethod: signUpMethod);
  }

  @override
  Future<void> logTutorialBegin() async {
    await _firebaseAnalytics.logTutorialBegin();
  }

  @override
  Future<void> logTutorialComplete() async {
    await _firebaseAnalytics.logTutorialComplete();
  }

  @override
  Future<void> setCurrentScreen({
    required String? screenName,
    String screenClassOverride: 'Flutter',
    AnalyticsCallOptions? callOptions,
  }) async {
    await _firebaseAnalytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
      callOptions: callOptions,
    );
  }

  @override
  Future<void> setUserId({
    String? id,
    AnalyticsCallOptions? callOptions,
  }) async {
    await _firebaseAnalytics.setUserId(
      id: id,
      callOptions: callOptions,
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    String? value,
    AnalyticsCallOptions? callOptions,
  }) async {
    await _firebaseAnalytics.setUserProperty(
      name: name,
      value: value,
      callOptions: callOptions,
    );
  }

  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
