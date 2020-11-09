import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/Passage.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/models/entities/Test.dart';
import 'package:lastochki/services/chapter_repository.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

const gameInfoName = 'gameInfo';

class ChapterService {
  final ChapterRepository _repository;
  static const int minQuestionBaseLength = 15;
  static const int maxNumberOfAttempt = 3;
  static const int numberOfTestQuestion = 10;

  ChapterService({
    ChapterRepository repository,
  }) : _repository = repository;

  List<Chapter> chapters;
  Chapter currentChapter;
  GameInfo gameInfo;
  double loadingPercent;
  int lastChapterVersion = 0;
  List<Note> notes = [];
  List<Question> _questionBase = [];
  int _numberOfNewQuestions = 0;
  int _numberOfAttempt = 0;
  int _accessNoteId = 0;

  void onReceive(int loaded, int info, {double total}) {
    loadingPercent = loaded / (total ?? loaded);
    print(loadingPercent);
    // print('$loaded  $info $total $loadingPercent');
  }

  Chapter getCurrentChapter() {
    return currentChapter;
  }

  double getLoadingPercent() {
    return loadingPercent;
  }

  loadNotes() async {
    // TODO load if need
  }

  loadGame() async {
    // TODO
    List values = await Future.wait([
      SharedPreferences.getInstance()
          .then((value) => value.getString(gameInfoName)),
      _repository.getChapters(),
    ]);
    print(values);

    chapters = values[1];
    // TODO calc last
    lastChapterVersion = chapters.length;
    if (gameInfo == null) {
      // TODO
      if (values[0] == null) {
        gameInfo = GameInfo();
      } else {
        gameInfo = GameInfo.fromJson(values[0]);
      }
    }

    await loadChapter();
  }

  loadChapter({int id}) async {
    // TODO check free space
    int currentChapterId = id ??
        (gameInfo.currentPassage == null
            ? gameInfo.currentChapterId + 1
            : gameInfo.currentChapterId);
    currentChapter =
        chapters.firstWhere((element) => element.number == currentChapterId);
    Map data = await _repository.getStory(
        currentChapter,
        (i, j) =>
            this.onReceive(i, j, total: currentChapter.mBytes * 1024 * 1024));
    Story s = data['story'];
    currentChapter.story = s;
    gameInfo.currentChapterId = currentChapterId;
    loadingPercent = null;
    var uniqNotes = notes.toSet();
    uniqNotes.addAll(data['notes']);
    notes = uniqNotes.toList();
    notes.sort((Note a, Note b) => a.id.compareTo(b.id));
    // TODO clean logic
    initGame();
  }

  void goNext(String step) {
    if (step != null || gameInfo.currentPassage.links.length == 1) {
      int nextPid = int.parse(step ?? gameInfo.currentPassage.links[0].pid);
      Passage p;
      while (p == null) {
        // if cant find step
        p = currentChapter.story.script[nextPid.toString()];
        nextPid++;
      }
      gameInfo.currentPassage = p;
    }
    if (gameInfo.currentPassage.links.length == 0) {
      int diffLastChapter = lastChapterVersion - currentChapter.number;
      String contentText = diffLastChapter > 0
          ? chapterContinue.toString()
          : chapterNoContinue.toString();
      // story end
      RM.navigate.toDialog(
        LInfoPopup(
            isCloseEnable: false,
            image: endImg,
            title: chapterEnd
                .toStringWithVar(variables: {'chapter': currentChapter.number}),
            content: contentText,
            actions: Column(
              children: [
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        bottom: 10, left: 20, right: 20, top: 20),
                    child: LButton(
                        text: continueGame.toString(),
                        swallow: 2, //TODO
                        icon: swallowIcon,
                        func: () {
                          RM.get<ChapterService>().setState((s) {
                            s.gameInfo.currentPassage = null;
                          });
                          RM.get<ChapterService>().setState((s) async {
                            await s.loadChapter();
                          });
                          RM.navigate.back();
                        })),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 0, left: 20, right: 20),
                  child: LButton(
                      buttonColor: whiteColor,
                      text: replayChapter.toString(),
                      icon: refreshIcon,
                      func: () {
                        RM.get<ChapterService>().setState((s) {
                          s.gameInfo.currentPassage = null;
                          s.initGame();
                        });
                        RM.navigate.back();
                      }),
                ),
                LButton(
                    icon: homeIcon,
                    buttonColor: whiteColor,
                    text: toHomePage.toString(),
                    fontSize: 10,
                    height: 30,
                    func: () {
                      RM.navigate.toReplacementNamed('/home');
                    }),
              ],
            )),
      );
    }
    if (gameInfo.currentPassage.tags.length > 0) {
      gameInfo.currentPassage.tags.forEach((element) {
        var setting = element.split(':');
        if (setting[0] == 'SetAccessToNote') {
          _accessNoteId = int.parse(setting[1]);
        }
      });
    }
    SharedPreferences.getInstance()
        .then((value) => value.setString(gameInfoName, gameInfo.toJson()));
  }

  void initGame() {
    if (gameInfo.currentPassage == null) {
      String pid = currentChapter.story.firstPid;
      gameInfo.currentPassage = currentChapter.story.script[pid];
    }
    SharedPreferences.getInstance()
        .then((value) => value.setString(gameInfoName, gameInfo.toJson()));
  }

  getNotes() {
    return notes.takeWhile((value) => value.id <= _accessNoteId).toList();
  }

  bool _isAllRead() {
    return !notes.any((element) => element.isRead == null);
  }

  bool _isTestAvailable() => _questionBase.length >= minQuestionBaseLength;

  bool _isAttemptLeft() => _numberOfAttempt < maxNumberOfAttempt;

  void onNewNoteRead(int noteId) {
    _numberOfAttempt = 0;
    Note note = notes.firstWhere((element) => element.id == noteId);
    note.isRead = true;
    if (note.questions != null) {
      _numberOfNewQuestions += note.questions.length;
      _questionBase.addAll(note.questions);
    }
  }

  void onTestPassed() {
    _numberOfAttempt++;
  }

  PopupText getPopupText() {
    Name title;
    Name content;
    if (!_isTestAvailable()) {
      title = noTestTitle;
      content = noTestContent;
    }
    if (!_isAllRead()) {
      content = haveUnreadNote;
    }
    if (!_isAttemptLeft()) {
      content = haveToReadNewNote;
    }
    return PopupText(title: title, content: content);
  }

  Test getTest() {
    if (!_isAllRead() || !_isTestAvailable() || !_isAttemptLeft()) return null;
    List<Question> testQuestion = [];
    int _numberOfOldQuestions = _numberOfNewQuestions >= numberOfTestQuestion
        ? 0
        : numberOfTestQuestion - _numberOfNewQuestions;
    _questionBase.shuffle();
    for (Question q in _questionBase) {
      if (q.isNew && _numberOfNewQuestions != 0) {
        testQuestion.add(q);
        q.isNew = false;
        _numberOfNewQuestions--;
      }
      if (!q.isNew && _numberOfOldQuestions != 0) {
        testQuestion.add(q);
        _numberOfOldQuestions--;
      }
      if (testQuestion.length == numberOfTestQuestion) break;
    }
    return Test(questions: testQuestion);
  }
}
