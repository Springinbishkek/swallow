import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/screens/test_result_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_test_box.dart';

class TestPage extends StatefulWidget {
  final int questionCount;
  TestPage({@required this.questionCount});
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Name done = Name(ru: 'Готово');
  Name next = Name(ru: 'Далее');

  final PageController _testPageController = PageController(initialPage: 0);

  int _currentPage = 0;

  void _navigateToNextPage() {
    setState(() {
      _currentPage++;
    });
    _testPageController.nextPage(
        duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  Widget _buildButton() {
    if (_currentPage == 9) {
      return LButton(
        text: done.toString(),
        func: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TestResultPage()));
        },
        icon: checkIcon,
      );
    }
    return LButton(
      text: next.toString(),
      func: () => _navigateToNextPage(),
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
              '${_currentPage + 1}/${widget.questionCount}',
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
          child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _testPageController,
        children: [
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
          _buildBody(testBox: LTestBox()),
        ],
      )),
    );
  }
}
