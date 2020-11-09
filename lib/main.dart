import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lastochki/models/route_arguments.dart';
import 'package:lastochki/services/api_client.dart';
import 'package:lastochki/services/chapter_repository.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/services/note_service.dart';
import 'package:lastochki/views/screens/game_page.dart';
import 'package:lastochki/views/screens/home_page.dart';
import 'package:lastochki/views/screens/note_page.dart';
import 'package:lastochki/views/screens/notes_page.dart';
import 'package:lastochki/views/screens/onboarding_page.dart';
import 'package:lastochki/views/screens/openline_logo_page.dart';
import 'package:lastochki/views/screens/settings_page.dart';
import 'package:lastochki/views/screens/test_page.dart';
import 'package:lastochki/views/screens/test_result_page.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await DotEnv().load('.env.development'); // TODO
  runApp(App());
}

class App extends StatelessWidget {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Injector(
        //Inject Model instance into the widget tree.
        inject: [
          // Inject(() => NoteService(repository: apiClient)),
          Inject(() => ChapterService(repository: ChapterRepository())),
        ],
        builder: (context) => MaterialApp(
              navigatorKey: RM.navigate.navigatorKey,
              title: 'Ласточки. Весна в Бишкеке',
              theme: ThemeData(
                fontFamily: 'SourceSansPro',
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: OpenlineLogoPage(),
              onGenerateRoute: _routes,
            ));
  }

  Route _routes(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => OnboardingPage());
        }
      case '/home':
        {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => HomePage());
        }
      case '/game':
        {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => GamePage());
        }
      case '/notes':
        {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => NotesPage());
        }
      case '/note':
        {
          final ArgumentsNotePage args = settings.arguments;
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) =>
                  NotePage(note: args.note, onRead: args.onRead));
        }
      case '/settings':
        {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => SettingsPage());
        }
      case '/test':
        {
          final ArgumentsTestPage args = settings.arguments;
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => TestPage(
                    test: args.test,
                    onTestPassed: args.onTestPassed,
                  ));
        }
      case '/test_result':
        {
          final ArgumentsTestResultPage args = settings.arguments;
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => TestResultPage(
                    questions: args.questions,
                    userAnswers: args.userAnswers,
                  ));
        }
    }
    throw Exception('invalid page');
  }
}
