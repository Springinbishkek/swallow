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
  final String answer1 =
      'Спросить его прямо или понаблюдать за его поведением, а потом сделать выводы';
  final String answer2 = 'Дать ему повод для ревности и посмотреть на реакцию.';
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
      margin: EdgeInsets.only(right: 16.0, left: 24.0, top: 16.0, bottom: 16.0),
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
      margin: EdgeInsets.only(right: 16.0, left: 24.0, top: 16.0, bottom: 16.0),
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
      margin: EdgeInsets.only(right: 16.0, left: 24.0, top: 16.0, bottom: 16.0),
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
    return GestureDetector(
      onTap: () => widget.isResult ? null : _onAnswerTap(val),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(24.0),
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            decoration: BoxDecoration(
                borderRadius: boxBorderRadius, color: scaffoldBgColor),
            child: Center(
              child: Text(
                question,
                style: appbarTextStyle,
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
