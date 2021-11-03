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
    final now = DateTime.now().hour;
    if (now >= 0 && now < 3)
      log('App open 0:00-3:00');
    else if (now >= 3 && now < 6)
      log('App open 3:00-6:00');
    else if (now >= 6 && now < 9)
      log('App open 6:00-9:00');
    else if (now >= 9 && now < 12)
      log('App open 9:00-12:00');
    else if (now >= 12 && now < 15)
      log('App open 12:00-15:00');
    else if (now >= 15 && now < 18)
      log('App open 15:00-18:00');
    else if (now >= 18 && now < 21)
      log('App open 18:00-21:00');
    else if (now >= 21) log('App open 21:00-0:00');
  }

  void log(String message) {
    FirebaseAnalytics().logEvent(name: message);
  }

  get observer => _observer;

  Future<void> setCurrentScreen({String screenName}) async {
    _analytics.setCurrentScreen(screenName: screenName);
  }
}
