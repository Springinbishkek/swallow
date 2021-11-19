import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback func;
  final bool newStyle;
  final int swallow;
  final bool iconOnRightSide;
  final Color buttonColor;
  final Color borderColor;
  final double fontSize;
  final double height;

  LButton({
    @required this.text,
    @required this.func,
    this.icon,
    this.swallow,
    this.iconOnRightSide = true,
    this.fontSize = 17,
    this.height = 45.0,
    this.buttonColor = accentColor,
    this.borderColor = accentColor,
    this.newStyle = false,
  });

  Widget _buildButton() {
    if (icon == null) {
      return ElevatedButton(
          child: Padding(
            padding: _getTextPadding(),
            child: _buildText(),
          ),
          onPressed: func);
    } else {
      if (newStyle) {
        return ElevatedButton(
            onPressed: func,
            child: Row(
              children: [
                Expanded(
                  child: _buildIcon(),
                  flex: 1,
                ),
                Expanded(
                  child: _buildText(),
                  flex: 4,
                ),
              ],
            ));
      } else {
        if (iconOnRightSide) {
          return ElevatedButton.icon(
              onPressed: func,
              icon: Padding(
                padding: _getTextPadding(),
                child: _buildText(),
              ),
              label: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: _buildIcon(),
              ));
        } else {
          return ElevatedButton.icon(
              onPressed: func,
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: _buildIcon(),
              ),
              label: Padding(
                padding: _getTextPadding(),
                child: _buildText(),
              ));
        }
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

  Widget _buildText() {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _getChildColor(),
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }

  Color _getChildColor() {
    if (buttonColor == accentColor) {
      return whiteColor;
    } else if (borderColor != whiteColor) {
      return borderColor;
    } else {
      return accentColor;
    }
  }

  Widget _buildIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (swallow != null)
          Text(
            '+$swallow',
            style: TextStyle(
                color: _getChildColor(),
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
          ),
        Image.asset(
          icon,
          height: 14,
          color: _getChildColor(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(127, height)),
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return buttonColor.withOpacity(0.6);
            return buttonColor;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.5)),
              side: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
      ),
      child: _buildButton(),
    );
  }
}
