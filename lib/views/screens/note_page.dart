import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final Function onRead;

  NotePage({@required this.note, @required this.onRead});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final String bottomBG = 'assets/backgrounds/note_bottom_background.png';
  final String topBG = 'assets/backgrounds/note_top_background.jpg';

  void navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
          child: ListView(
        padding: EdgeInsets.only(top: 0.0),
        children: <Widget>[
          Container(
            height: 180.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(topBG), fit: BoxFit.cover)),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Image.asset(
                    closeIcon,
                    height: 14.0,
                  ),
                  onPressed: navigateBack),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  widget.note.title.toString(),
                  style: titleTextStyle,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  // TODO make text selectable!
                  child: Html(
                    data: widget.note.text.toString().replaceAll('\n', '<br>'),
                    style: {
                      "body": Style(color: textColor, fontSize: FontSize(17.0))
                    },
                  ))
            ],
          ),
          Container(
            height: 175,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(bottomBG), fit: BoxFit.cover)),
            child: Center(
              child: LButton(
                  text: understood.toString(),
                  func: () {
                    widget.onRead();
                    navigateBack();
                  }),
            ),
          )
        ],
      )),
    );
  }
}
