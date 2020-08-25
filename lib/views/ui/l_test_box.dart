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

  Widget _buildIcon({String icon}) {
    if (icon != null) {
      return Image.asset(
        icon,
        height: 10,
        color: whiteColor,
      );
    }
    return null;
  }

  Widget _buildCheckIcon({Color color, String icon}) {
    return Container(
      height: 20,
      width: 20,
      margin: EdgeInsets.only(right: 16.0, left: 24.0, top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              icon == null ? Border.all(color: textColor, width: 2.0) : null),
      child: CircleAvatar(
        backgroundColor: color,
        child: _buildIcon(icon: icon),
      ),
    );
  }

//TODO: переписать логику
  Widget _buildAnswerIcon(int val) {
    switch (val) {
      case 0:
        return _buildCheckIcon(color: errorColor, icon: closeIcon);
      case 2:
        return _buildCheckIcon(color: accentColor, icon: checkIcon);
      default:
        return _buildCheckIcon(color: Colors.transparent, icon: null);
    }
  }

  Widget _buildRadioButton(int val, Function func) {
    return Radio(
        activeColor: textColor,
        value: val,
        groupValue: _radioVal,
        onChanged: (int value) => Function.apply(func, [value]));
  }

  Widget _buildCheckBox(int val, String answer) {
    return GestureDetector(
      onTap: () => widget.isResult ? null : _onAnswerTap(val),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isResult
                ? _buildAnswerIcon(val)
                : _buildRadioButton(val, (val) => _onAnswerTap(val)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
