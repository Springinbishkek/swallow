import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/views/screens/note_page.dart';
import 'package:lastochki/views/theme.dart';

class LNoteCard extends StatelessWidget {
  final List<String> backgrounds = [
    'assets/backgrounds/note_background1.png',
    'assets/backgrounds/note_background2.png'
  ];

  final int index;
  final String title;
  final bool isRead;

  LNoteCard(
      {@required this.index, @required this.title, @required this.isRead});

  Widget _readIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 24.0,
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
          child: CircleAvatar(
            backgroundColor: accentColor,
            child: Image.asset(
              checkIcon,
              height: 14,
            ),
          )),
    );
  }

  Widget _unreadIcon() {
    Color unread = Color(0xFF2589F6);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30.0,
        width: 60.0,
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: unread, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '+15',
              style: TextStyle(
                  color: unread, fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            Image.asset(swallowIcon)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => NotePage()));
          debugPrint('tap on ${index + 1} note');
        },
        child: Container(
            height: 85.0,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: boxBorderRadius,
              image: DecorationImage(
                  image: AssetImage(backgrounds[index % 2]), fit: BoxFit.cover),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 250,
                    child: Text(
                      (index + 1).toString() + '. ' + title,
                      style: isRead
                          ? TextStyle(
                              color: textColor.withOpacity(0.6),
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)
                          : subtitleTextStyle,
                    ),
                  ),
                ),
                isRead ? _readIcon() : _unreadIcon()
              ],
            )),
      ),
    );
  }
}
