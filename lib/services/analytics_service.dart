import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

abstract class AnalyticsService {
  void log(String message);

  get observer;
  void setCurrentScreen({String screenName});
}

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver _observer;

  FirebaseAnalyticsService() {

    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
    _analytics.logAppOpen();
  }

  void log(String message) {
    FirebaseAnalytics().logEvent(name: message);
  }

  get observer => _observer;

  Future<void> setCurrentScreen({String screenName}) async{
    _analytics.setCurrentScreen(screenName: screenName);
  }
}
