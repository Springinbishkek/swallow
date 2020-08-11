import 'package:flutter/material.dart';
import 'package:lastochki/views/screens/home_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';
import 'package:lastochki/views/ui/l_text_field.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _textController = TextEditingController();
  final String _forwardIcon = 'assets/icons/forward_arrow.png';
  final String _onboardingBG = 'assets/backgrounds/onboardingBackground.png';
  final String _settingsIcon = 'assets/icons/settingsHomeIcon.png';

  String name = 'Бегайым';

  void _navigateToNextPage() {
    _pageController.nextPage(
        duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  @override
  dispose() {
    _textController.clear();
    _textController.dispose();
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
            'Привет!',
            style: titleTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Это игра про кыргизских девченок, дружбу, любовь и все такое прочее. '
            'Главная героиня игры — это ты. ',
            style: contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            ' От твоих решений зависит, что будет происходить, и чем все закончится.',
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
            'На каком языке ты хочешь играть?',
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(24.0), child: LLanguageCheckbox()),
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
            'Выбери имя для героини',
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Можно дать ей свое имя или то, которое очень нравится',
            style: contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 56.0),
          child: LTextField(_textController),
        ),
        Expanded(child: Container()),
        _getButton(() {
          if (_textController.text != '') {
            setState(() {
              name = _textController.text;
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
            'Отлично, $name',
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text:
                      'Сменить имя, язык игры или начать игру заново всегда можно в пункте Настроек с вот таким значком: ',
                  style: contentTextStyle),
              WidgetSpan(
                  child: Image.asset(
                _settingsIcon,
                height: 20,
              ))
            ]),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'А теперь давай перейдем к первой главе!',
            style: titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: Container()),
        _getButton(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        title: 'Title',
                      )));
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
        text: 'ДАЛЕЕ',
        func: func,
        icon: _forwardIcon,
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
              controller: _pageController,
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
