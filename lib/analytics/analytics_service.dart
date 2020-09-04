import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ns_firebase_utils/utils/logs.dart';
import 'package:ns_firebase_utils/utils/nsf_exception.dart';
import 'package:ns_firebase_utils/utils/nsf_keys.dart';
import 'package:ns_firebase_utils/utils/nsf_strings.dart';

import '../src.dart';

class AppAnalytics implements FirebaseAnalytics {
  final FirebaseAnalytics _firebaseAnalytics;

  AppAnalytics() : _firebaseAnalytics = new FirebaseAnalytics();

  Map<String, dynamic> _userInfo = Map();

  Future<Null> setUser({
    @required String id,
    @required String email,
  }) async {
    nsfLogs("setUser:$id");
    await setUserId(id);
    _userInfo = {
      NSFKeys.id: id,
      NSFKeys.email: email,
    };
  }

  Future<Null> log(
      {@required String eventName,
      String category,
      Map<String, dynamic> parameters}) async {
    if (parameters == null) {
      parameters = <String, dynamic>{};
    }
    if (category == null) {
      category = NSFStrings.empty;
    }
    await logEvent(name: eventName, category: category, parameters: parameters);
  }

  @override
  Future<Null> logAppOpen() async {
    if (!NSFirebase.instance.isInitialized)
      throw NSFException(
        code: 'NSFirebase_not_initialized',
        message: 'Please Initialized NSFirebase',
      );
    await _firebaseAnalytics.logAppOpen();
  }

  @override
  Future<Null> logEvent({
    String name,
    String category,
    Map<String, dynamic> parameters,
  }) async {
    name = name?.replaceAll(new RegExp(r' '), '_'); // name cannot use '-'
    category = category?.replaceAll(new RegExp(r' '), '_');
    final eventName = category == null ? name : "${name}_$category";
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

    Map<String, dynamic> newParameters = new Map<String, dynamic>();
    // Remove null
    parameters.forEach((key, dynamic value) {
      if (value != null) {
        newParameters.putIfAbsent(key, () => value);
      }
    });
    nsfLogs("eventName:$eventName", tag: "Analytics");
    // TODO: need to avoid parameters contains List value. This causes exception
    await _firebaseAnalytics.logEvent(
        name: eventName, parameters: newParameters);
  }

  @override
  Future<Null> logJoinGroup({String groupId}) async {
    await _firebaseAnalytics.logJoinGroup(groupId: groupId);
  }

  @override
  Future<Null> logLogin({String loginMethod}) async {
    await _firebaseAnalytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<Null> logSignUp({String signUpMethod}) async {
    await _firebaseAnalytics.logSignUp(signUpMethod: signUpMethod);
  }

  @override
  Future<Null> logTutorialBegin() async {
    await _firebaseAnalytics.logTutorialBegin();
  }

  @override
  Future<Null> logTutorialComplete() async {
    await _firebaseAnalytics.logTutorialComplete();
  }

  @override
  Future<void> setCurrentScreen({
    @required String screenName,
    String screenClassOverride: 'Flutter',
  }) async {
    await _firebaseAnalytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
    );
  }

  @override
  Future<Null> setUserId(String id) async {
    await _firebaseAnalytics.setUserId(id);
  }

  @override
  Future<Null> setUserProperty({String name, String value}) async {
    await _firebaseAnalytics.setUserProperty(name: name, value: value);
  }

  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
