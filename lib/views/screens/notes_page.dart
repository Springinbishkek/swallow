import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/screens/test_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_note_card.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Name notes = Name(ru: 'Блокнот');
  Name firstNote = Name(ru: 'Что такое Заметки и зачем они нужны для игры?');
  Name secondNote = Name(ru: 'Что делать, если идешь одна поздно ночью домой?');
  Name thirdNote = Name(ru: 'Куда звонить, если что-то случилось?');
  Name bottom = Name(ru: 'Хочешь больше ласточек?');
  Name test = Name(ru: 'Пройти тест');
  Name title = Name(ru: 'Тест');
  Name content =
      Name(ru: 'Ответь правильно на все вопросы и получи новую стаю ласточек!');
  Name startTest = Name(ru: 'Начать тест');

  final String bottomBanner = 'assets/backgrounds/note_bottom_banner.png';
  final String rocketImg = 'assets/icons/mw_rocket.png';

  void _openInfoPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
              image: rocketImg,
              title: title.toString(),
              content: content.toString(),
              actions: LButton(
                  text: startTest.toString(),
                  func: () {
                    debugPrint('start test');
                  }),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: LAppbar(
          title: notes.toString(),
          func: () {
            Navigator.pop(context);
          }),
      body: Container(
          child: Scrollbar(
              child: ListView(
        children: <Widget>[
          LNoteCard(index: 0, title: firstNote.toString(), isRead: true),
          LNoteCard(
            index: 1,
            title: secondNote.toString(),
            isRead: true,
          ),
          LNoteCard(
            index: 2,
            title: thirdNote.toString(),
            isRead: false,
          ),
          LNoteCard(index: 3, title: firstNote.toString(), isRead: false),
          LNoteCard(index: 4, title: firstNote.toString(), isRead: false),
          LNoteCard(index: 5, title: firstNote.toString(), isRead: false),
          LNoteCard(index: 6, title: firstNote.toString(), isRead: false),
        ],
      ))),
      bottomNavigationBar: BottomAppBar(
        color: scaffoldBgColor,
        child: Container(
          height: 160,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(bottomBanner), fit: BoxFit.cover),
                borderRadius: boxBorderRadius),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    bottom.toString(),
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                LButton(
                    text: test.toString(),
                    func: _openInfoPopup,
                    icon: forwardIcon)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
