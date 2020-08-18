import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LTestBox extends StatefulWidget {
  final bool isResult;

  LTestBox({this.isResult = false});

  @override
  _LTestBoxState createState() => _LTestBoxState();
}

class _LTestBoxState extends State<LTestBox> {
  final String question = '1. Работает ли в Кыргызтане единая служба спасения?';
  final String answer1 = 'Может и работает, но все равно не дозвонишься';
  final String answer2 = 'Работала до 2017 года, но сейчас нет';
  final String answer3 = 'Работает по номеру 112';

  int _radioVal;

  void _onAnswerTap(int val) {
    setState(() {
      _radioVal = val;
    });
  }

  Widget _buildEmptyCheckIcon() {
    return Container(
      height: 20,
      width: 20,
      margin: EdgeInsets.only(right: 16.0, left: 24.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: textColor, width: 2.0)),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildCorrectCheckIcon() {
    return Container(
      height: 20,
      width: 20,
      margin: EdgeInsets.only(right: 16.0, left: 24.0),
      child: CircleAvatar(
        backgroundColor: accentColor,
        child: Image.asset(
          checkIcon,
          height: 10,
          color: whiteColor,
        ),
      ),
    );
  }

  Widget _buildIncorrectCheckIcon() {
    return Container(
      height: 20,
      width: 20,
      margin: EdgeInsets.only(right: 16.0, left: 24.0),
      child: CircleAvatar(
        backgroundColor: errorColor,
        child: Image.asset(
          closeIcon,
          height: 10,
          color: whiteColor,
        ),
      ),
    );
  }

//TODO: переписать логику
  Widget _buildAnswerIcon(int val) {
    switch (val) {
      case 0:
        return _buildIncorrectCheckIcon();
      case 2:
        return _buildCorrectCheckIcon();
      default:
        return _buildEmptyCheckIcon();
    }
  }

  Widget _buildRadioButton(int val) {
    return Radio(
        activeColor: textColor,
        value: val,
        groupValue: _radioVal,
        onChanged: (int value) => _onAnswerTap(value));
  }

  Widget _buildCheckBox(int val, String answer) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isResult ? _buildAnswerIcon(val) : _buildRadioButton(val),
          Flexible(
              child: Text(
            answer,
            style: noteTextStyle,
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Container(
              height: 80.0,
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              decoration: BoxDecoration(
                  borderRadius: boxBorderRadius, color: scaffoldBgColor),
              child: Center(
                child: Text(
                  question,
                  style: appbarTextStyle,
                ),
              ),
            ),
          ),
          _buildCheckBox(0, answer1),
          _buildCheckBox(1, answer2),
          _buildCheckBox(2, answer3)
        ],
      ),
    );
  }
}
