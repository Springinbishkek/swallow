import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LButton extends StatelessWidget {
  final String text;
  final String icon;
  final Function func;
  final bool iconOnRightSide;
  final Color buttonColor;
  final Color borderColor;

  LButton(
      {@required this.text,
      @required this.func,
      this.icon,
      this.iconOnRightSide = true,
      this.buttonColor = accentColor,
      this.borderColor = accentColor});

  Widget _getButton() {
    if (icon == null) {
      return RaisedButton(child: _getText(), onPressed: func);
    } else {
      if (iconOnRightSide) {
        return RaisedButton.icon(
            onPressed: func, icon: _getText(), label: _getIcon());
      } else {
        return RaisedButton.icon(
            onPressed: func, icon: _getIcon(), label: _getText());
      }
    }
  }

  EdgeInsets _getTextPadding() {
    if (icon == null) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else {
      if (iconOnRightSide) {
        return const EdgeInsets.only(left: 16.0);
      } else {
        return const EdgeInsets.only(right: 16.0);
      }
    }
  }

  Widget _getText() {
    return Padding(
      padding: _getTextPadding(),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: _getChildColor(),
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
        ),
      ),
    );
  }

  Color _getChildColor(){
    if(buttonColor==accentColor) {
      return whiteColor;
    }
    else if (borderColor!=whiteColor){
      return borderColor;
    }
    else{
      return accentColor;
    }
  }

  Widget _getIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Image.asset(
        icon,
        height: 14,
        color: _getChildColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45.0,
      minWidth: 127.0,
      buttonColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(22.5)),
        side: BorderSide(color: borderColor, width: 2.0),
      ),
      child: _getButton(),
    );
  }
}
