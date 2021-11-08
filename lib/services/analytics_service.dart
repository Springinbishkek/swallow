import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';

abstract class AnalyticsService {
  void log({@required String name, Map<String, Object> parameters});

  NavigatorObserver get observer;

  void setCurrentScreen({@required String screenName});
}

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver _observer;

  FirebaseAnalyticsService() {
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
    //АНАЛИТИКА время старта приложения
    final now = DateTime.now().hour;
    log(name: 'app_start', parameters: {'time': now - now % 3});
  }

  void log({@required String name, Map<String, Object> parameters}) {
    FirebaseAnalytics().logEvent(name: name, parameters: parameters);
  }

  get observer => _observer;

  Future<void> setCurrentScreen({@required String screenName}) async {
    _analytics.setCurrentScreen(screenName: screenName);
  }
}
