import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/models/entities/Note.dart';
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
  final String testImg = 'assets/icons/mw_test.png';

  //TODO: получение теста
  void _openInfoPopup(Note note) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
              image: testImg,
              title: title.toString(),
              content: content.toString(),
              actions: LButton(
                  text: startTest.toString(),
                  func: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TestPage(
                                  test: note.test,
                                )));
                  }),
            ));
  }

  Widget _buildBottom(Note note) {
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
                  func: () => _openInfoPopup(note),
                  icon: forwardIcon)
            ],
          ),
        ),
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
                      title: noteService.state.notes[index].title.toString(),
                      isRead: noteService.state.notes[index].isRead ?? false,
                    ))));
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
          body: Stack(
            children: [
              noteService.state.notes.length == 1
                  ? Center(
                      child: Text(
                      noNotes.toString(),
                      style: TextStyle(
                          color: textColor.withOpacity(0.6), fontSize: 17.0),
                    ))
                  : Container(),
              _buildNotesBody(noteService)
            ],
          ),
          bottomNavigationBar: noteService.state.notes.length > 1
              ? _buildBottom(noteService.state.notes[1])
              : null,
        );
      },
    );
  }
}
