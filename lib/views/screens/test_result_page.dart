import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_test_box.dart';

class TestResultPage extends StatefulWidget {
  @override
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  Name done = Name(ru: 'Готово', kg: 'test');
  Name checkRes = Name(ru: 'Проверь свои ответы', kg: 'test');

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
          LTestBox(
            isResult: true,
          ),
          LTestBox(
            isResult: true,
          ),
          LTestBox(
            isResult: true,
          ),
          LTestBox(
            isResult: true,
          ),
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
      )),
    );
  }
}
