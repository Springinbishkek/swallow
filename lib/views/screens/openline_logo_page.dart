import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenlineLogoPage extends StatefulWidget {
  @override
  _OpenlineLogoPageState createState() => _OpenlineLogoPageState();
}

class _OpenlineLogoPageState extends State<OpenlineLogoPage> {
  final String openLine = 'assets/backgrounds/open_line_logo.png';
  SharedPreferences prefs;
  bool isFirstStart;

  @override
  void initState() {
    _getPrefsData();
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed(_getRoute()));
  }

  String _getRoute() =>  '/onboarding' ;

  void _getPrefsData() async {
    prefs = await SharedPreferences.getInstance();
    isFirstStart = prefs.getBool('isFirstStart') ?? true;
    String languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      Name.curLocale = Locale(languageCode);
    }
    if (isFirstStart) {
      prefs.setBool('isFirstStart', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 72.0),
      child: Center(
        child: Image.asset(openLine),
      ),
    );
  }
}
