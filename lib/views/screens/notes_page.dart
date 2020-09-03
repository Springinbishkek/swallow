import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/views/screens/test_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_note_card.dart';

import '../translation.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Name firstNote =
      Name(ru: 'Что такое Заметки и зачем они нужны для игры?', kg: 'test');
  Name secondNote =
      Name(ru: 'Что делать, если идешь одна поздно ночью домой?', kg: 'test');
  Name thirdNote = Name(ru: 'Куда звонить, если что-то случилось?', kg: 'test');
  Name bottom = Name(
      ru: 'Хочешь больше ласточек?', kg: 'Көбүрөөк чабалекей алгың келеби?');
  Name title = Name(ru: 'Тест', kg: 'Тест');
  Name content = Name(
      ru: 'Ответь правильно на все вопросы и получи новую стаю ласточек!',
      kg: 'Бардык суроолорго туура жооп берип, чабалекейлердин үйүрүн толукта!');
  Name startTest = Name(ru: 'Начать тест', kg: 'Тестти баштоо');

  final String bottomBanner = 'assets/backgrounds/note_bottom_banner.png';
  final String rocketImg = 'assets/icons/mw_rocket.png';

  List<Question> questions = [
    Question(),
    Question(),
    Question(),
    Question(),
    Question(),
    Question(),
    Question(),
    Question(),
    Question(),
    Question(),
  ];

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TestPage(
                                  questions: questions,
                                )));
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
                    text: takeTest.toString(),
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
