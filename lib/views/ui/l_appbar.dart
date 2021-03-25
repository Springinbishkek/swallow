import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

AppBar lAppbar({@required String title, @required Function func}) {
  return AppBar(
    backgroundColor: appbarBgColor,
    title: Text(
      title,
      style: appbarTextStyle,
    ),
    centerTitle: true,
    leading: IconButton(
        icon: Image.asset(
          backIcon,
          height: 24,
        ),
        onPressed: func),
  );
}
