import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';

abstract class AnalyticsService {
  void log({@required String name, Map<String, Object> parameters});

  NavigatorObserver get navigationObserver;

  void setCurrentScreen({@required String screenName});
}

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics;
  final FirebaseAnalyticsObserver _observer;

  FirebaseAnalyticsService._(this._analytics, this._observer) {
    final now = DateTime.now().hour;
    log(name: 'app_start', parameters: {'time': now - now % 3});
  }

  factory FirebaseAnalyticsService() {
    final analytics = FirebaseAnalytics();
    final observer = FirebaseAnalyticsObserver(analytics: analytics);
    return FirebaseAnalyticsService._(analytics, observer);
  }

  @override
  void log({@required String name, Map<String, Object> parameters}) {
    _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  NavigatorObserver get navigationObserver => _observer;

  @override
  void setCurrentScreen({@required String screenName}) {
    _analytics.setCurrentScreen(screenName: screenName);
  }
}
