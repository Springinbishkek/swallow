import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lastochki/views/screens/home_page.dart';
import 'package:lastochki/views/screens/onboarding_page.dart';

import 'models/entities/Name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstStart = prefs.getBool('isFirstStart') ?? true;
  // TODO set language on single place
  String languageCode = prefs.getString('languageCode');
  if (languageCode != null) {
    Name.curLocale = Locale(languageCode);
  }
  prefs.setBool('isFirstStart', false);
  runApp(App(isFirstStart: isFirstStart));
}

class App extends StatelessWidget {
  final bool isFirstStart;

  @override
  App({
    Key key,
    this.isFirstStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ласточки. Весна в Бишкеке',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: !isFirstStart ? OnboardingPage() : HomePage(),
    );
  }
}
