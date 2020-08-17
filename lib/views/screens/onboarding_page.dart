import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/screens/settings_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';
import 'package:lastochki/views/ui/l_text_field.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Name greeting = Name(ru: 'Привет!');
  Name aboutGame = Name(
      ru: 'Это игра про кыргизских девчонок, дружбу, любовь и'
          ' все такое прочее. Главная героиня игры — это ты.');
  Name aboutDecisions = Name(
      ru: ' От твоих решений зависит, что будет происходить, и чем все закончится.');
  Name askLanguage = Name(ru: 'На каком языке ты хочешь играть?');
  Name askName = Name(ru: 'Выбери имя для героини');
  Name aboutName =
      Name(ru: 'Можно дать ей свое имя или то, которое очень нравится');
  Name greetingName = Name(ru: 'Отлично, ');
  Name aboutSettings = Name(
      ru: 'Сменить имя, язык игры или начать игру заново всегда можно в пункте Настроек с вот таким значком: ');
  Name letsStart = Name(ru: 'А теперь давай перейдем к первой главе!');
  Name next = Name(ru: 'Далее');

  final PageController _pageStateController = PageController(initialPage: 0);
  final TextEditingController _textNameController = TextEditingController();
  final String _onboardingBG = 'assets/backgrounds/onboarding_background.png';

  String name = 'Бегайым';

  void _navigateToNextPage() {
    _pageStateController.nextPage(
        duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  @override
  dispose() {
    _textNameController.clear();
    _textNameController.dispose();
    super.dispose();
  }

  Widget firstPage() {
    return _pageConstructor(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            greeting.toString(),
            style: titleTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            aboutGame.toString(),
            style: contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            aboutDecisions.toString(),
            style: contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: Container()),
        _getButton(() => _navigateToNextPage())
      ],
    ));
  }

  Widget secondPage() {
    return _pageConstructor(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            askLanguage.toString(),
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 24.0), child: LLanguageCheckbox()),
        Expanded(child: Container()),
        _getButton(() => _navigateToNextPage())
      ],
    ));
  }

  Widget thirdPage() {
    return _pageConstructor(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            askName.toString(),
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            aboutName.toString(),
            style: contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 56.0),
          child: LTextField(_textNameController),
        ),
        Expanded(child: Container()),
        _getButton(() {
          if (_textNameController.text != '') {
            setState(() {
              name = _textNameController.text;
            });
          }
          _navigateToNextPage();
        })
      ],
    ));
  }

  Widget fourthPage() {
    return _pageConstructor(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            greetingName.toString() + name,
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: aboutSettings.toString(), style: contentTextStyle),
              WidgetSpan(
                  child: Image.asset(
                settingsIcon,
                height: 20,
              ))
            ]),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            letsStart.toString(),
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: Container()),
        _getButton(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
        })
      ],
    ));
  }

  Widget _pageConstructor({Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: child,
      ),
    );
  }

  Widget _getButton(Function func) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LButton(
        text: next.toString(),
        func: func,
        icon: forwardIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(_onboardingBG), fit: BoxFit.cover)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.transparent,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageStateController,
              children: <Widget>[
                firstPage(),
                secondPage(),
                thirdPage(),
                fourthPage()
              ],
            )),
      ),
    );
  }
}
