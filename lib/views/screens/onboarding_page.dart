import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_character_name_input.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';

import '../translation.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Name aboutGame = Name(
      ru: 'Это игра про девчонок, дружбу, любовь и свободу. '
          'Главная героиня игры — это ты.',
      kg: 'Бул кыздар жөнүндө оюн, анда достук, сүйүү жана эркиндик жөнүндө айтылат.'
          ' Оюндун башкы каарманы - сенсиң!');
  Name aboutDecisions = Name(
      ru: 'Именно от твоих решений зависит, как будет меняться жизнь героев, и чем всё закончится. \n'
          'Обещаем: будет интересно и очень волнительно!',
      kg: 'Каармандардын жашоосу кандайча өзгөрүп, кандайча аяктаганы сенин чечимиңден көз каранды.'
          ' Бул оюн кызыктуу жана абдан толкунданткан болот деп, убада беребиз!');
  Name askLanguage = Name(
      ru: 'На каком языке ты хочешь играть?',
      kg: 'Кайсы тилде ойногонду каалайсың?');
  Name askName = Name(
      ru: 'Как тебя зовут?',
      kg: 'Сенин атың ким болсо, башкы каармандын да\nаты ошондой болот');
  Name aboutName = Name(ru: 'Также будут звать главную героиню игры', kg: '');
  Name greetingName = Name(ru: 'Отлично, @name!', kg: 'Абдан жакшы, @name!');
  Name aboutSettings = Name(
      ru: 'Поменять имя, язык или начать игру заново можно в разделе «Настройки» с таким значком: ',
      kg: 'Төмөнкү белги менен "Баптоолор" бөлүмүндө атын, тилин өзгөртүп жана оюнду кайрадан баштаса болот: ');
  Name letsStart =
      Name(ru: 'А теперь давай начнём игру!', kg: 'Эми оюнду баштайлы!');
  Name nextFirstPage = Name(ru: 'Далее', kg: 'Андан ары');

  final PageController _pageStateController = PageController(initialPage: 0);
  final TextEditingController _textNameController = TextEditingController();
  final String _onboardingBG = 'assets/backgrounds/onboarding_background.png';

  String name = 'Бегайым';
  String languageCode;

  void _navigateToNextPage() {
    _pageStateController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void onChangeLanguageCode(String code) {
    setState(() {
      languageCode = code;
    });
  }

  @override
  dispose() {
    _textNameController.clear();
    _textNameController.dispose();
    _pageStateController.dispose();
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
            aboutGame.toString(),
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            aboutDecisions.toString(),
            style: contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: Container()),
        _getButton(nextFirstPage.toString(), () => _navigateToNextPage())
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
            padding: const EdgeInsets.only(top: 24.0),
            child: LLanguageCheckbox(
              onChanged: onChangeLanguageCode,
            )),
        Expanded(child: Container()),
        _getButton(next.toString(), () => _navigateToNextPage())
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
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: LCharacterNameInput(_textNameController),
        ),
        Expanded(child: Container()),
        _getButton(next.toString(), () {
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
            greetingName.toStringWithVar(variables: {'name': name}),
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
        _getButton(letsPlay.toString(), () {
          Navigator.of(context).pushReplacementNamed('/home');
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

  Widget _getButton(String text, Function func) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LButton(
        text: text,
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
              onPageChanged: (int page) {
                if (page == 2) {
                  if (languageCode != null) {
                    setState(() {
                      Name.curLocale = Locale(languageCode);
                    });
                  }
                }
              },
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
