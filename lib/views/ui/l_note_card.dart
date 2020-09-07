import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/views/screens/note_page.dart';
import 'package:lastochki/views/theme.dart';

class LNoteCard extends StatelessWidget {
  final List<String> backgrounds = [
    'assets/backgrounds/note_background1.png',
    'assets/backgrounds/note_background2.png'
  ];

  final int index;
  final Note note;
  final Function onRead;

  LNoteCard({@required this.index, @required this.note, @required this.onRead});

  Widget _buildReadIcon() {
    return Container(
        height: 24.0,
        margin: EdgeInsets.only(top: 8.0, right: 8.0),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundColor: accentColor,
          child: Image.asset(
            checkIcon,
            height: 14,
          ),
        ));
  }

  Widget _buildUnreadIcon({int profit}) {
    Color blueColor = Color(0xFF2589F6);
    return Container(
      height: 30.0,
      width: 60.0,
      margin: EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: blueColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '+$profit',
            style: TextStyle(
                color: blueColor, fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Image.asset(swallowIcon)
        ],
      ),
    );
  }

  Widget _buildIcon() {
    bool isRead = note.isRead ?? false;
    if (note.swallow == 0 && !isRead) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0),
      );
    } else if (isRead) {
      return _buildReadIcon();
    }
    return _buildUnreadIcon(profit: note.swallow);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NotePage(
                        note: note,
                        onRead: onRead,
                      )));
        },
        child: Container(
            height: 85,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Center(
                      child: Text(
                        '${index + 1}. ${note.title}',
                        maxLines: 3,
                        style: note.isRead ?? false
                            ? TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)
                            : subtitleTextStyle,
                      ),
                    ),
                  ),
                ),
                _buildIcon()
              ],
            )),
      ),
    );
  }
}
