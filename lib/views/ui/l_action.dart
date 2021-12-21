import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LAction extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final Color buttonColor;
  final Color borderColor;

  final double h = 38;
  final double minWidth;

  LAction(
      {this.child,
      this.onTap,
      this.minWidth = 60,
      this.buttonColor = accentColor,
      this.borderColor = accentColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(h / 2),
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxHeight: h, minWidth: minWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h / 2),
          color: buttonColor,
        ),
        height: h,
        padding: EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
