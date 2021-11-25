import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/services/analytics_service.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_character_name_input.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

// \u{00A0} is non-breaking space

const Name aboutGame = Name(
  ru: 'Привет, главная героиня!',
  kg: 'Салам, башкы каарман!',
);

const Name aboutDecisions = Name(
  ru: '«Тайна Сары-Кёль» — это игра-сериал про дружбу, любовь и свободу. В главной роли игры — ты!'
      '\n\nИменно от твоих решений зависит, как сложится судьба наших героев, и чем все закончится. Обещаем, скучно не будет!',
  kg: '«Сары-Көл сыры» – бул достук, сүйүү жана эркиндик тууралуу оюн-сериал. Оюндун башкы каарманы сенсиң!'
      '\n\nБиздин каармандардын тагдыры кандай болору жана бул окуя кандай аякташы сенин  чечимдериңден көз каранды. Бул оюнда зериккенге убакыт болбойт деп убада кылабыз!',
);

const Name askLanguage = Name(
  ru: 'На каком языке ты хочешь играть?',
  kg: 'Кайсы тилде ойногонду каалайсың?',
);

const Name askName = Name(
  ru: 'Как тебя зовут?',
  kg: 'Сенин атың ким болсо, башкы каармандын да\nаты ошондой болот',
);

const Name aboutName = Name(
  ru: 'Так же будут звать главную героиню игры',
  kg: '',
);

const Name greetingName = Name(
  ru: 'Отлично, \$name!',
  kg: 'Абдан жакшы, \$name!',
);

const Name aboutSettings = Name(
  ru: 'Поменять имя, язык или начать игру заново можно в разделе «Настройки» с таким значком: ',
  kg: 'Төмөнкү белги менен "Баптоолор" бөлүмүндө атын, тилин өзгөртүп жана оюнду кайрадан баштаса болот: ',
);

const Name letsStart = Name(
  ru: 'Всё, теперь ты готова к приключениям!',
  kg: 'Анда эмесе, кызыктуу окуяларга даярсыңбы!',
);

const Name nextFirstPage = Name(
  ru: 'Далее',
  kg: 'Андан ары',
);

const String _onboardingBg = 'assets/backgrounds/onboarding_background.png';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageStateController = PageController(initialPage: 0);

  String name = 'Бегайым';
  String languageCode = Name.curLocale.languageCode;

  void navigateToNextPage() {
    _pageStateController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  dispose() {
    _pageStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_onboardingBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageStateController,
          children: [
            _AskLanguagePage(
              onNext: navigateToNextPage,
            ),
            _AboutGamePage(
              onNext: navigateToNextPage,
            ),
            _AskNamePage(
              onNext: navigateToNextPage,
            ),
            _LetsStartPage(
              onNext: navigateToHome,
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final Widget child;

  const _Page({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: child,
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final String text;
  final VoidCallback func;

  const _NextButton(this.text, this.func, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LButton(
        text: text,
        func: func,
        icon: forwardIcon,
      ),
    );
  }
}

class _AboutGamePage extends StatelessWidget {
  final VoidCallback onNext;

  const _AboutGamePage({
    Key key,
    @required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Page(
      child: Column(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              aboutGame.toString(),
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              aboutDecisions.toString(),
              style: contentTextStyle.apply(fontSizeFactor: .9),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          SizedBox(height: 16),
          _NextButton(nextFirstPage.toString(), onNext),
        ],
      ),
    );
  }
}

class _AskLanguagePage extends StatefulWidget {
  final VoidCallback onNext;

  const _AskLanguagePage({
    Key key,
    @required this.onNext,
  }) : super(key: key);

  @override
  State<_AskLanguagePage> createState() => _AskLanguagePageState();
}

class _AskLanguagePageState extends State<_AskLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return _Page(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              askLanguage.toString(),
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: LLanguageCheckbox(
              onChanged: onChangeLanguageCode,
            ),
          ),
          Spacer(),
          _NextButton(next.toString(), () {
            RM.get<AnalyticsService>().state.log(
              name: 'language_initial',
              parameters: {'language': Name.curLocale.languageCode},
            );
            widget.onNext();
          }),
        ],
      ),
    );
  }

  void onChangeLanguageCode(String code) async {
    Name.curLocale = Locale(code);
    setState(() {}); // update ui
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', code);
  }
}

class _AskNamePage extends StatefulWidget {
  final VoidCallback onNext;

  const _AskNamePage({
    Key key,
    @required this.onNext,
  }) : super(key: key);

  @override
  State<_AskNamePage> createState() => _AskNamePageState();
}

class _AskNamePageState extends State<_AskNamePage> {
  final textNameController = TextEditingController();
  bool isTouched = false;

  @override
  void dispose() {
    textNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Page(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              askName.toString(),
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              aboutName.toString(),
              style: contentTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: LCharacterNameInput(
              textNameController,
              onChanged: (_) => setState(() {
                isTouched = true;
              }),
            ),
          ),
          Spacer(),
          _NextButton(next.toString(), getNameSettingHandler()),
        ],
      ),
    );
  }

  VoidCallback /*?*/ getNameSettingHandler() {
    if (isTouched && textNameController.text.trim().isEmpty) {
      return null;
    }
    return () {
      final name = textNameController.text;
      RM.get<AnalyticsService>().state.log(
        name: 'player_name_initial',
        parameters: {'name': name},
      );
      RM
          .get<ChapterService>()
          .setState((s) => s.setGameParam(name: 'Main', value: name));
      widget.onNext();
    };
  }
}

class _LetsStartPage extends StatelessWidget {
  final VoidCallback onNext;

  const _LetsStartPage({
    Key key,
    @required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = RM.get<ChapterService>().state.getGameVariable('Main');
    return _Page(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              greetingName.toStringWithVar(variables: {'name': name}),
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: aboutSettings.toString(),
                    style: contentTextStyle,
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      settingsIcon,
                      color: accentColor,
                      height: 20,
                    ),
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              letsStart.toString(),
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          _NextButton(letsPlay.toString(), onNext),
        ],
      ),
    );
  }
}
