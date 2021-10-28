import 'package:flutter/material.dart';

const Color menuBgColor = Color(0xFFFAFAFA);
const Color appbarBgColor = Color(0xFFFFFDF5);
const Color scaffoldBgColor = Color(0xFFFFFAE9);
const Color textColor = Color(0xFF093A67);
const Color accentColor = Color(0xFF1675CC);
const Color whiteColor = Color(0xFFFFFFFF);
const Color boxBorderColor = Color(0xFF1675CC);
const Color errorColor = Color(0xFFD83E58);

const TextStyle titleTextStyle =
    TextStyle(color: textColor, fontSize: 24.0, fontWeight: FontWeight.bold);
const TextStyle titleLightTextStyle =
    TextStyle(color: textColor, fontSize: 24.0);
const TextStyle subtitleTextStyle =
    TextStyle(color: textColor, fontSize: 17.0, fontWeight: FontWeight.bold);
const TextStyle subtitleLightTextStyle = TextStyle(
  color: textColor,
  fontSize: 17.0,
);
const TextStyle contentTextStyle = TextStyle(color: textColor, fontSize: 21.0);
const TextStyle appbarTextStyle =
    TextStyle(color: textColor, fontSize: 21.0, fontWeight: FontWeight.bold);
const TextStyle noteTextStyle = TextStyle(color: textColor, fontSize: 17.0);

const boxBorderRadius = BorderRadius.all(Radius.circular(12.0));

final String alertImg = 'assets/icons/mw_alert.png';
final String endImg = 'assets/icons/mw_end_book.png';

final String homeIcon = 'assets/icons/home.png';
final String notesIconBg = 'assets/icons/notes_bg.png';
final String notesIconFg = 'assets/icons/notes_fg.png';
final String aboutIcon = 'assets/icons/about.png';
final String settingsIcon = 'assets/icons/settings_home_icon.png';
final String instagramIcon = 'assets/icons/instagram.png';
final String infoIcon = 'assets/icons/info.png';
final String forwardIcon = 'assets/icons/forward_arrow.png';
final String backIcon = 'assets/icons/back_arrow.png';
final String checkIcon = 'assets/icons/check_icon.png';
final String closeIcon = 'assets/icons/close_icon.png';
final String swallowIcon = 'assets/icons/swallow.png';
final String refreshIcon = 'assets/icons/refresh_icon.png';
final String testBG = 'assets/backgrounds/test_bottom_background.png';

final String bottomBanner = 'assets/backgrounds/note_bottom_banner.png';
final String testImg = 'assets/icons/mw_test.png';
final String noteImg = 'assets/icons/mw_note.png';
final String swallowImg = 'assets/icons/mw_swallow.png';
final String sponsoesImg = 'assets/icons/sponsors.png';

class NotesIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(notesIconBg, color: whiteColor),
        Image.asset(notesIconFg, color: accentColor),
      ],
    );
  }
}

