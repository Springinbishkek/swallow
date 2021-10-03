import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      Name.curLocale = Locale(languageCode);
    }

    final isFirstStart = prefs.getBool('isFirstStart') ?? true;
    if (isFirstStart) {
      prefs.setBool('isFirstStart', false);
    }
    final nextRoute = isFirstStart ? '/onboarding' : '/home';

    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return _LogoPage();
  }
}

class _LogoPage extends StatelessWidget {
  const _LogoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 72.0),
      child: Center(
        child: Image.asset('assets/backgrounds/open_line_logo.png'),
      ),
    );
  }
}
