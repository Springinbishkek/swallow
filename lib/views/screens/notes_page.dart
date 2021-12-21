import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/models/entities/Test.dart';
import 'package:lastochki/models/route_arguments.dart';
import 'package:lastochki/services/chapter_service.dart';
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

  Function _getPopupToOpen() {
    var service = RM.get<ChapterService>('ChapterService');
    Test test = service.state.getTest();
    if (test == null) {
      return () => _openNoTestPopup(service.state.getPopupText());
    }
    return () => _openTestPopup(test, ({bool successful}) {
          service
              .setState((s) => s.onTestPassed(successful: successful ?? false));
        });
  }

  Widget _buildBottom() {
    return BottomAppBar(
      color: scaffoldBgColor,
      child: SizedBox(
        height: 160,
        width: MediaQuery.of(context).size.width,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: LButton(
                    text: takeTest.toString(),
                    func: _getPopupToOpen(),
                    icon: forwardIcon),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesBody() {
    final ReactiveModel<ChapterService> service = RM.get<ChapterService>();
    List<Note> notes = service.state.getNotes();
    return Container(
        child: Scrollbar(
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => LNoteCard(
                    index: index,
                    note: notes[index],
                    onRead: () {
                      service.setState((s) {
                        if (notes[index].isRead == null) {
                          s.onNewNoteRead(notes[index].id);
                        }
                      });
                    }))));
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder<ChapterService>(
      observe: () => RM.get<ChapterService>(),
      initState: (context, chapterServiceRM) {
        chapterServiceRM.setState((s) => s.loadNotes());
      },
      builder: (context, chapterService) {
        bool isOneNote = chapterService.state.getNotes().length == 1;
        return Scaffold(
          backgroundColor: scaffoldBgColor,
          appBar: lAppbar(title: notes.toString(), func: _navigateBack),
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
          bottomNavigationBar: _buildBottom(),
        );
      },
    );
  }
}
