import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/services/analytics_service.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class NotePage extends StatefulWidget {
  final Note note;

  void onRead() {
    RM.get<AnalyticsService>().state.log(
          name: 'about_open',
        );
    RM.get<ChapterService>().setState((s) {
      if (note.isRead == null) {
        s.onNewNoteRead(note.id);
      }
    });
  }

  NotePage({@required this.note});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final String bottomBG = 'assets/backgrounds/note_bottom_background.png';
  final String topBG = 'assets/backgrounds/note_top_background.jpg';
  DateTime openTime;

  void navigateBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    openTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              expandedHeight: 180.0,
              floating: true,
              automaticallyImplyLeading: false,
              pinned: true,
              actions: [
                IconButton(
                    icon: Image.asset(
                      closeIcon,
                      height: 14.0,
                    ),
                    onPressed: navigateBack),
              ],
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                topBG,
                fit: BoxFit.cover,
              )),
            ),
          ];
        },
        body: Scrollbar(
            child: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: <Widget>[
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
                      data:
                          widget.note.text.toString().replaceAll('\n', '<br>'),
                      style: {
                        "body":
                            Style(color: textColor, fontSize: FontSize(17.0))
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
                      RM
                          .get<AnalyticsService>()
                          .state
                          .log(name: 'note_read', parameters: {
                        'carefully':
                            openTime.difference(DateTime.now()).inSeconds > 30,
                        'duration':
                            openTime.difference(DateTime.now()).inSeconds,
                        'note_id': widget.note.id,
                      });
                      navigateBack();
                    }),
              ),
            )
          ],
        )),
      ),
    );
  }
}
