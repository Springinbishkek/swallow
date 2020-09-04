import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/AnswerOption.dart';
import 'package:lastochki/models/entities/Test.dart';
import 'package:lastochki/views/screens/notes_page.dart';
import 'package:lastochki/views/screens/test_result_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_test_box.dart';

import '../translation.dart';

class TestPage extends StatefulWidget {
  final Test test;

  TestPage({@required this.test});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final PageController _testPageController = PageController(initialPage: 0);
  final String rocketImg = 'assets/icons/mw_rocket.png';
  final String cloverImg = 'assets/icons/mw_rocket.png';

  int _currentPage = 0;
  bool _isAnswerChosen = false;
  List<AnswerOption> _chosenAnswers = [];
  AnswerOption _currentAnswer;

  static const int swallowForTest = 15;

  void _navigateToNextPage() {
    _checkCorrectness();
    setState(() {
      _isAnswerChosen = false;
      _currentPage++;
    });
    _testPageController.nextPage(
        duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  void _checkCorrectness() {
    setState(() {
      _chosenAnswers.add(_currentAnswer);
      if (_currentAnswer.isRight) {
        widget.test.result++;
      }
    });
  }

  void _onTestEnd() {
    _checkCorrectness();
    if (widget.test.result == widget.test.questions.length) {
      _openWellDonePopup();
    } else {
      _openFailedPopup();
    }
  }

  void _openFailedPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: cloverImg,
            title: testFailedTitle.toString(),
            //TODO вставить цифры
            content: testFailedContent.toString(),
            actions: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LButton(
                      text: restartTest.toString(),
                      icon: refreshIcon,
                      func: () {
                        widget.test.result = 0;
                        ///может добавить именованные маршруты?
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TestPage(test: widget.test)));
                      }),
                  SizedBox(
                    height: 8.0,
                  ),
                  LButton(
                      text: checkAnswers.toString(),
                      icon: forwardIcon,
                      buttonColor: whiteColor,
                      func: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TestResultPage(
                                      questions: widget.test.questions,
                                      userAnswers: _chosenAnswers,
                                    )));
                      }),
                ],
              ),
            )));
  }

  void _openWellDonePopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: rocketImg,
            title: testPassedTitle.toString(),
            content: testPassedContent.toString(),
            actions: LButton(
                text: hooray.toString(),
                icon: swallowIcon,
                swallow: swallowForTest,
                func: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => NotesPage()));
                })));
  }

  Widget _buildButton() {
    if (_currentPage == widget.test.questions.length - 1) {
      return LButton(
        text: done.toString(),
        func: _isAnswerChosen ? _onTestEnd : null,
        icon: checkIcon,
      );
    }
    return LButton(
      text: next.toString(),
      func: _isAnswerChosen ? () => _navigateToNextPage() : null,
      icon: forwardIcon,
    );
  }

  Widget _buildBody({Widget testBox}) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(testBG), fit: BoxFit.cover),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 36.0),
                child: _buildButton(),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              '${_currentPage + 1}/${widget.test.questions.length}',
              style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0),
            ),
            testBox,
          ],
        ),
      ]),
    );
  }

  void _onChooseAnswer(AnswerOption answer) {
    setState(() {
      _currentAnswer = answer;
      _isAnswerChosen = true;
    });
  }

  @override
  void dispose() {
    _testPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          actions: [
            IconButton(
                icon: Image.asset(
                  closeIcon,
                  height: 14.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        body: Container(
            child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _testPageController,
                itemCount: widget.test.questions.length,
                itemBuilder: (BuildContext context, index) => _buildBody(
                        testBox: LTestBox(
                      question: widget.test.questions[index],
                      onChooseAnswer: _onChooseAnswer,
                    )))));
  }
}
