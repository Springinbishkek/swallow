import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lastochki/views/theme.dart';

class LAction extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final Color buttonColor;
  final Color borderColor;

  final double h = 38;

  LAction(
      {this.child,
      this.onTap,
      this.buttonColor = accentColor,
      this.borderColor = accentColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: buttonColor,
      highlightColor: buttonColor.withOpacity(0.6),
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxHeight: h, minWidth: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h / 2),
          color: buttonColor,
        ),
        // width: 70,
        height: h,
        padding: EdgeInsets.all(10),
        child: child,
      ),
    );
    // ButtonTheme(
    //   height: 40,
    //   minWidth: 50,
    //   buttonColor: buttonColor,
    //   disabledColor: buttonColor.withOpacity(0.6),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(22.5)),
    //     side: BorderSide(color: borderColor, width: 2.0),
    //   ),
    //   child:
    // );
  }
}
