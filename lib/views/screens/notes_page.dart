import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/models/entities/Test.dart';
import 'package:lastochki/models/route_arguments.dart';
import 'package:lastochki/services/note_service.dart';
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
  final String noteImg = 'assets/icons/mw_note.png';

  void _navigateBack() {
    Navigator.pop(context);
  }

  void _navigateToNewTest(Test test, Function onPassed) {
    Navigator.of(context).popAndPushNamed('/test',
        arguments: ArgumentsTestPage(test: test, onTestPassed: onPassed));
  }

  void _openNoTestPopup(PopupText popupText) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: noteImg,
            title: (popupText.title ?? '').toString(),
            content: (popupText.content ?? '').toString(),
            actions: LButton(text: toNotes.toString(), func: _navigateBack)));
  }

  void _openTestPopup(Test test, Function onPassed) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
              image: testImg,
              title: title.toString(),
              content: content.toString(),
              actions: LButton(
                  text: startTest.toString(),
                  func: () => _navigateToNewTest(test, onPassed)),
            ));
  }

  Function _getPopupToOpen(ReactiveModel<NoteService> service) {
    Test test = service.state.getTest();
    if (test == null) {
      return () => _openNoTestPopup(service.state.getPopupText());
    }
    return () => _openTestPopup(test, () {
          service.setState((s) => s.onTestPassed());
        });
  }

  Widget _buildBottom() {
    return BottomAppBar(
      color: scaffoldBgColor,
      child: SizedBox(
        height: 160,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(bottomBanner), fit: BoxFit.contain),
              borderRadius: BorderRadius.circular(20)),
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
                  func: _getPopupToOpen(RM.get<NoteService>()),
                  icon: forwardIcon)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesBody() {
    final ReactiveModel<NoteService> service = RM.get<NoteService>();
    return Container(
        child: Scrollbar(
            child: ListView.builder(
                itemCount: service.state.notes.length,
                itemBuilder: (context, index) => LNoteCard(
                    index: index,
                    note: service.state.notes[index],
                    onRead: () {
                      service.setState((s) {
                        if (s.notes[index].isRead == null) {
                          s.onNewNoteRead(index);
                        }
                      });
                    }))));
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder<NoteService>(
      observe: () => RM.get<NoteService>(),
      initState: (context, noteServiceRM) {
        noteServiceRM.setState((s) => s.loadNotes());
      },
      builder: (context, noteService) {
        bool isOneNote = noteService.state.notes.length == 1;
        return Scaffold(
          backgroundColor: scaffoldBgColor,
          appBar: LAppbar(title: notes.toString(), func: _navigateBack),
          body: Stack(
            children: [
              if (isOneNote)
                Center(
                    child: Text(
                  noNotes.toString(),
                  style: TextStyle(
                      color: textColor.withOpacity(0.6), fontSize: 17.0),
                )),
              _buildNotesBody()
            ],
          ),
          bottomNavigationBar: !isOneNote ? _buildBottom() : null,
        );
      },
    );
  }
}
