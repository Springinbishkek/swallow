import 'package:flutter/material.dart';

class LButton extends StatelessWidget {
  String text;
  String icon;
  Function func;

  LButton({@required this.text, @required this.func, this.icon});

  Widget _getButton() {
    if (icon == null) {
      return RaisedButton(child: _getText(), onPressed: func);
    } else {
      return RaisedButton.icon(
          onPressed: func, icon: _getText(), label: _getIcon());
    }
  }

  EdgeInsets _getTextPadding() => icon == null
      ? const EdgeInsets.symmetric(horizontal: 16.0)
      : const EdgeInsets.only(left: 16.0, right: 8.0);

  Widget _getText() {
    return Padding(
      padding: _getTextPadding(),
      child: Text(
        text,
        style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 17.0),
      ),
    );
  }

  Widget _getIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Image.asset(
        icon,
        height: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45.0,
      minWidth: 127.0,
      buttonColor: Color(0xFF31D3B2),
      highlightColor: Color(0xFF21A68B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.5))),
      child: _getButton(),
    );
  }
}
