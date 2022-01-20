import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;

  const LAppBar({
    Key /*?*/ key,
    @required this.title,
    @required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        onPressed: onBack,
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
