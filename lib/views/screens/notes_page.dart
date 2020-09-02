import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/services/note_service.dart';
import 'package:lastochki/views/screens/test_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_note_card.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../translation.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Name bottom = Name(
      ru: 'Хочешь больше ласточек?', kg: 'Көбүрөөк чабалекей алгың келеби?');
  Name title = Name(ru: 'Тест', kg: 'Тест');
  Name content = Name(
      ru: 'Ответь правильно на все вопросы и получи новую стаю ласточек!',
      kg: 'Бардык суроолорго туура жооп берип, чабалекейлердин үйүрүн толукта!');
  Name startTest = Name(ru: 'Начать тест', kg: 'Тестти баштоо');
  final Name noNotes =
      Name(ru: 'Скоро будут ещё!', kg: 'Жакында дагы жаңысы болот!');

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

  Widget _buildBottom() {
    return BottomAppBar(
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
    );
  }

  Widget _buildOneNoteBody(ReactiveModel<NoteService> noteService) {
    return Container(
      child: Column(
        children: [
          LNoteCard(
              index: 0,
              note: noteService.state.notes[0],
              isRead: noteService.state.notes[0].isRead ?? false,
              onTap: () =>
                  noteService.setState((s) => s.notes[0].isRead = true)),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(bottom: 80.0),
            child: Center(
              child: Text(
                noNotes.toString(),
                style: TextStyle(
                    color: textColor.withOpacity(0.6), fontSize: 17.0),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildNotesBody(ReactiveModel<NoteService> noteService) {
    return Container(
        child: Scrollbar(
            child: ListView.builder(
                itemCount: noteService.state.notes.length,
                itemBuilder: (context, index) => LNoteCard(
                    index: index,
                    note: noteService.state.notes[index],
                    isRead: noteService.state.notes[index].isRead ?? false,
                    onTap: () => noteService
                        .setState((s) => s.notes[index].isRead = true)))));
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder<NoteService>(
      observe: () => RM.get<NoteService>(),
      initState: (context, noteServiceRM) {
        noteServiceRM.setState((s) => s.loadNotes());
      },
      builder: (context, noteService) {
        return Scaffold(
          backgroundColor: scaffoldBgColor,
          appBar: LAppbar(
              title: notes.toString(),
              func: () {
                Navigator.pop(context);
              }),
          body: noteService.state.notes.length > 1
              ? _buildNotesBody(noteService)
              : _buildOneNoteBody(noteService),
          bottomNavigationBar:
              noteService.state.notes.length > 1 ? _buildBottom() : null,
        );
      },
    );
  }
}
