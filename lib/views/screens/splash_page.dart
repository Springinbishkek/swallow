import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/screens/cover_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isShowingLogo2 = false;

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
    setState(() => _isShowingLogo2 = true);
    await Future.delayed(Duration(seconds: 3) + _animationDuration);
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  static const _animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _LogoPage2(),
        AnimatedSwitcher(
          duration: _animationDuration,
          child: _isShowingLogo2 ? SizedBox() : _LogoPage1(),
        ),
      ],
    );
  }
}

class _LogoPage1 extends StatelessWidget {
  const _LogoPage1({Key key}) : super(key: key);

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

class _LogoPage2 extends StatelessWidget {
  const _LogoPage2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: CoverPage(
        bodyContent: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              width: 100,
              height: 100,
              image: AssetImage(swallowImg),
            ),
            Image(
              height: 72,
              image: AssetImage(sponsoesImg),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'При поддержке ЮНИСЕФ (Детского фонда ООН) в рамках совместной инициативы ЕС и ООН «Луч света»',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1),
              ),
            ),
            SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
