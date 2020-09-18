import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Test.dart';
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
  final Name noTestTitle =
      Name(ru: 'Тест появится чуть позже', kg: 'Тест кийинчерээк пайда болот');
  final Name noTestContent = Name(
      ru: 'Чтобы открыть тест, нужно собрать больше Заметок. Продолжай играть!',
      kg: 'Тестти ачуу үчүн, көбүрөөк Эскертүүлөрдү чогултуу керек. Оюнду улант!');
  final Name haveUnreadNote = Name(
      ru: 'Прочитай все свои заметки, прежде чем проходить тест!',
      kg: 'Тесттен өтөөрдөн мурун, өзүңдүн бардык эскертүүлөрүңдү окуп чык!');
  final Name haveToReadNewNote = Name(
      ru: 'Ты уже эксперт! Найди и прочитай новые заметки, прежде чем проходить тест снова.',
      kg: 'Сен эми экспертсиң! Кайрадан тесттен өтөөрдүн алдында, жаңы эскертүүлөрдү таап, оку.');

  final String bottomBanner = 'assets/backgrounds/note_bottom_banner.png';
  final String testImg = 'assets/icons/mw_test.png';
  final String noteImg = 'assets/icons/mw_note.png';

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
                  func: () {
                    Navigator.of(context).popAndPushNamed('/test',
                        arguments: note.test);
                  }),
            ));
  }

  void _openNoTestPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: noteImg,
            title: noTestTitle.toString(),
            content: noTestContent.toString(),
            actions: LButton(
                text: toNotes.toString(),
                func: () {
                  Navigator.pop(context);
                })));
  }

  void _openUnreadNotesPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: noteImg,
            title: '',
            content: haveUnreadNote.toString(),
            actions: LButton(
                text: toNotes.toString(),
                func: () {
                  Navigator.pop(context);
                })));
  }

  void _openNoAttemptsPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
            image: noteImg,
            title: '',
            content: haveToReadNewNote.toString(),
            actions: LButton(
                text: toNotes.toString(),
                func: () {
                  Navigator.pop(context);
                })));
  }

  Widget _buildBottom(ReactiveModel<NoteService> noteService) {
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
                  func: () {
                    if (!noteService.state.isTestAvailable()) {
                      _openNoTestPopup();
                    } else if (!noteService.state.isAllRead()) {
                      _openUnreadNotesPopup();
                    } else if (!noteService.state.isAttemptLeft()) {
                      _openNoAttemptsPopup();
                    } else {
                      _openTestPopup(noteService.state.getTest(), () {
                        noteService.setState((s) => s.onTestPassed());
                      });
                    }
                  },
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
                    note: noteService.state.notes[index],
                    onRead: () {
                          noteService.setState((s) {
                            if (s.notes[index].isRead==null) {
                              s.onNewNoteRead(s.notes[index].questions);
                              s.notes[index].isRead = true;
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
          appBar: LAppbar(
              title: notes.toString(),
              func: () {
                Navigator.pop(context);
              }),
          body: Stack(
            children: [
              if (isOneNote)
                Center(
                    child: Text(
                  noNotes.toString(),
                  style: TextStyle(
                      color: textColor.withOpacity(0.6), fontSize: 17.0),
                )),
              _buildNotesBody(noteService)
            ],
          ),
          bottomNavigationBar: !isOneNote ? _buildBottom(noteService) : null,
        );
      },
    );
  }
}
