import 'package:flutter/material.dart';
import 'package:lastochki/views/screens/home_page.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final String _forwardIcon = 'assets/icons/forward_arrow.png';
  final String _onboardingBG = 'assets/backgrounds/onboardingBackground.png';

  Widget firstPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Привет!',
                      style: TextStyle(
                          color: Color(0xFF1F2E6C),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Это игра про кыргизских девченок, дружбу, любовь и все такое прочее. '
                      'Главная героиня игры — это ты. ',
                      style:
                          TextStyle(color: Color(0xFF1F2E6C), fontSize: 21.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      ' От твоих решений зависит, что будет происходить, и чем все закончится.',
                      style: TextStyle(
                        color: Color(0xFF1F2E6C),
                        fontSize: 21.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              _getButton(() {
                _pageController.nextPage(
                    duration: Duration(microseconds: 500), curve: Curves.ease);
              })
            ],
          )),
    );
  }

  Widget secondPage(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'На каком языке ты хочешь играть?',
                      style: TextStyle(
                          color: Color(0xFF1F2E6C),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: LLanguageCheckbox()
                  ),
                ],
              ),
              _getButton(() {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>HomePage(title: 'Title',)));
              })
            ],
          )),
    );
  }

  Widget _getButton(Function func) {
    return Align(
      alignment: Alignment(0.0, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LButton(
          text: 'ДАЛЕЕ',
          func: func,
          icon: _forwardIcon,
        ),
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
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.transparent,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                firstPage(),
                secondPage()
              ],
            )),
      ),
    );
  }
}
