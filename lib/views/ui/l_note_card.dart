import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/route_arguments.dart';
import 'package:lastochki/views/theme.dart';

class LNoteCard extends StatelessWidget {
  final List<String> backgrounds = [
    'assets/backgrounds/note_background1.png',
    'assets/backgrounds/note_background2.png'
  ];

  final int index;
  final Note note;

  LNoteCard({@required this.index, @required this.note});

  Widget _buildReadIcon() {
    return Container(
      height: 24.0,
      margin: EdgeInsets.only(top: 10, right: 0),
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
      child: CircleAvatar(
        backgroundColor: accentColor,
        child: Image.asset(
          checkIcon,
          height: 14,
        ),
      ),
    );
  }

  Widget _buildUnreadIcon({@required int profit}) {
    Color blueColor = Color(0xFF2589F6);
    return Container(
      height: 26,
      width: 60,
      margin: EdgeInsets.only(top: 10, right: 8, left: 16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: blueColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              '+$profit',
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                height: 0.95,
              ),
              textAlign: TextAlign.center,
            ),
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
        margin: EdgeInsets.symmetric(horizontal: 24),
      );
    } else if (isRead) {
      return _buildReadIcon();
    }
    return _buildUnreadIcon(profit: note.swallow);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/note',
              arguments: ArgumentsNotePage(note: note));
        },
        child: Container(
            height: 85,
            padding: EdgeInsets.symmetric(horizontal: 8),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: ,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 8),
                    child: Text(
                      '${index + 1}. ${note.title}',
                      maxLines: 3,
                      style: note.isRead ?? false
                          ? TextStyle(
                              color: textColor.withOpacity(0.6),
                              fontSize: 17,
                              fontWeight: FontWeight.bold)
                          : subtitleTextStyle,
                    ),
                  ),
                ),
                Align(alignment: Alignment.topCenter, child: _buildIcon())
              ],
            )),
      ),
    );
  }
}
