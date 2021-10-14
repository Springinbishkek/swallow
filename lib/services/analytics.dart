import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

class Analytics {
  FirebaseAnalyticsObserver observer;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  Analytics(){
    observer = FirebaseAnalyticsObserver(analytics: analytics);
    analytics.logAppOpen();
}
  void log(String message) {
    FirebaseAnalytics().logEvent(name: message);
  }

}
