import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/models/route_arguments.dart';
import 'package:lastochki/services/analytics_service.dart';
import 'package:lastochki/services/chapter_repository.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/screens/about_page.dart';
import 'package:lastochki/views/screens/game_page.dart';
import 'package:lastochki/views/screens/home_page.dart';
import 'package:lastochki/views/screens/note_page.dart';
import 'package:lastochki/views/screens/notes_page.dart';
import 'package:lastochki/views/screens/onboarding_page.dart';
import 'package:lastochki/views/screens/splash_page.dart';
import 'package:lastochki/views/screens/settings_page.dart';
import 'package:lastochki/views/screens/test_page.dart';
import 'package:lastochki/views/screens/test_result_page.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject(() => ChapterService(repository: ChapterRepository())),
        Inject<AnalyticsService>(() => FirebaseAnalyticsService()),
      ],
      builder: (context) => MaterialApp(
        navigatorObservers: [
          RM.get<AnalyticsService>().state.navigationObserver,
        ],
        navigatorKey: RM.navigate.navigatorKey,
        title: 'Ласточки. Весна в Бишкеке',
        theme: ThemeData(
          fontFamily: 'SourceSansPro',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        onGenerateRoute: _route,
      ),
    );
  }

  Route<void> _route(RouteSettings settings) {
    RM.get<AnalyticsService>().state.setCurrentScreen(
          screenName: settings.name,
        );
    switch (settings.name) {
      case '/onboarding':
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => OnboardingPage(),
          );
        }
      case '/about':
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AboutPage(),
          );
        }
      case '/home':
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => HomePage(),
          );
        }
      case '/game':
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => GamePage(),
          );
        }
      case '/notes':
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => NotesPage(),
          );
        }
      case '/note':
        {
          final args = settings.arguments as ArgumentsNotePage;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => NotePage(note: args.note),
          );
        }
      case '/settings':
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => SettingsPage(),
          );
        }
      case '/test':
        {
          final service = RM.get<ChapterService>();
          final test = service.state.getTest();
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TestPage(test: test),
          );
        }
      case '/test_result':
        {
          final args = settings.arguments as ArgumentsTestResultPage;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TestResultPage(
              questions: args.questions,
              userAnswers: args.userAnswers,
            ),
          );
        }
    }
    throw Exception('invalid page');
  }
}
