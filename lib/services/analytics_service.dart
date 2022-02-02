import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:platform_device_id/platform_device_id.dart';

abstract class AnalyticsService {
  void log({@required String name, Map<String, Object> /*?*/ parameters});

  NavigatorObserver get navigationObserver;

  void setCurrentScreen({@required String screenName});
}

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseFirestore _store;
  final FirebaseAnalytics _analytics;
  final FirebaseAnalyticsObserver _observer;

  FirebaseAnalyticsService._(this._store, this._analytics, this._observer) {
    final now = DateTime.now().hour;
    log(name: 'app_start', parameters: {'time': now - now % 3});
  }

  factory FirebaseAnalyticsService() {
    final store = FirebaseFirestore.instance;
    final analytics = FirebaseAnalytics.instance;
    final observer = FirebaseAnalyticsObserver(analytics: analytics);
    return FirebaseAnalyticsService._(store, analytics, observer);
  }

  String /*?*/ __deviceId;

  Future<String> get _deviceId async {
    return __deviceId ??= await PlatformDeviceId.getDeviceId;
  }

  @override
  void log({
    @required String name,
    Map<String, Object> /*?*/ parameters,
  }) async {
    _analytics.logEvent(name: name, parameters: parameters);
    _store.collection('events').add({
      ...?parameters,
      'device_id': await _deviceId,
      'event_name': name,
      'event_time': FieldValue.serverTimestamp(),
    });
  }

  @override
  NavigatorObserver get navigationObserver => _observer;

  @override
  void setCurrentScreen({@required String screenName}) {
    _analytics.setCurrentScreen(screenName: screenName);
  }
}
