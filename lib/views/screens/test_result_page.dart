import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/AnswerOption.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_test_box.dart';

import '../translation.dart';

class TestResultPage extends StatefulWidget {
  final List<Question> questions;
  final List<AnswerOption> userAnswers;

  TestResultPage({@required this.questions, @required this.userAnswers});

  @override
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  Name checkRes =
      Name(ru: 'Проверь свои ответы', kg: 'Өзүңдүн жоопторуңду текшерип көр');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Image.asset(
                    closeIcon,
                    height: 14.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  checkRes.toString(),
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.questions.length,
                itemBuilder: (BuildContext context, index) => LTestBox(
                      question: widget.questions[index],
                      isResult: true,
                      userAnswer: widget.userAnswers[index],
                    )),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(testBG), fit: BoxFit.cover)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: LButton(
                    text: done.toString(),
                    func: () {
                      Navigator.pop(context);
                    },
                    icon: checkIcon,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
