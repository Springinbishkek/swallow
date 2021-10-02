import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/AnswerOption.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/models/entities/Test.dart';
import 'package:lastochki/models/route_arguments.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_test_box.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../translation.dart';

class TestPage extends StatefulWidget {
  final Test test;
  final TestPassFunction onTestPassed;

  TestPage({@required this.test, @required this.onTestPassed});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final PageController _testPageController = PageController(initialPage: 0);
  final String rocketImg = 'assets/icons/mw_rocket.png';
  final String cloverImg = 'assets/icons/mw_clover.png';
  Test test;

  int _currentPage = 0;
  bool _isAnswerChosen = false;
  List<AnswerOption> _chosenAnswers = [];
  AnswerOption _currentAnswer;

  static const int swallowForTest = 15;

  @override
  void initState() {
    test = widget.test ?? Test(questions: []);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.test == null) {
        PopupText popupText = RM.get<ChapterService>().state.getPopupText();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => LInfoPopup(
                image: noteImg,
                title: (popupText.title ?? '').toString(),
                content: (popupText.content ?? '').toString(),
                actions: LButton(
                    text: backToChapter.toString(),
                    func: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    })));
      }
    });
  }

  void _navigateToNextPage() {
    _saveAnswer();
    setState(() {
      _isAnswerChosen = false;
      _currentPage++;
    });
    _testPageController.nextPage(
        duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  void _saveAnswer() {
    if (_chosenAnswers.length >= test.questions.length) return;
    setState(() {
      _chosenAnswers.add(_currentAnswer);
    });
  }

  void _onTestEnd() {
    _saveAnswer();
    int result = _chosenAnswers.where((a) => a.isRight).length;
    bool isSuccessful = result == test.questions.length;
    if (isSuccessful) {
      _openWellDonePopup();
    } else {
      _openFailedPopup();
    }
  }

  void _openFailedPopup() {
    int mistakes = _chosenAnswers.where((a) => !a.isRight).length;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: cloverImg,
            title: testFailedTitle.toString(),
            content: testFailedContent
                .toStringWithVar(variables: {'mistakes': mistakes}),
            actions: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LButton(
                      text: restartTest.toString(),
                      icon: refreshIcon,
                      func: () {
                        // TODO unificate swallow logic, too long handlers chain
                        widget.onTestPassed(successful: false);
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/test',
                            arguments: ArgumentsTestPage(
                                test: test, onTestPassed: widget.onTestPassed));
                      }),
                  SizedBox(
                    height: 8.0,
                  ),
                  LButton(
                      text: checkAnswers.toString(),
                      icon: forwardIcon,
                      buttonColor: whiteColor,
                      func: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/test_result',
                            arguments: ArgumentsTestResultPage(
                                questions: test.questions,
                                userAnswers: _chosenAnswers));
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
                  widget.onTestPassed(successful: true);
                  Navigator.of(context).popUntil((route) {
                    return ModalRoute.withName('/notes')(route) ||
                        ModalRoute.withName('/home')(route) ||
                        ModalRoute.withName('/game')(route);
                  });
                })));
  }

  Widget _buildButton() {
    if (_currentPage == test.questions.length - 1) {
      return LButton(
        text: done.toString(),
        func: _isAnswerChosen ? _onTestEnd : null,
        icon: checkIcon,
      );
    }
    return LButton(
      text: next.toString(),
      func: _isAnswerChosen ? _navigateToNextPage : null,
      icon: forwardIcon,
    );
  }

  Widget _buildBody({Widget testBox}) {
    const double bottomControlsHeight = 200;
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${_currentPage + 1}/${test.questions.length}',
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              testBox,
              SizedBox(height: bottomControlsHeight)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: bottomControlsHeight,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(testBG), fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: Center(
                child: _buildButton(),
              ),
            ),
          ),
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
                itemCount: test.questions.length,
                itemBuilder: (BuildContext context, index) => _buildBody(
                        testBox: LTestBox(
                      question: test.questions[index],
                      onChooseAnswer: _onChooseAnswer,
                    )))));
  }
}
