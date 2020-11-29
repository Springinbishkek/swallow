import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Choice.dart';
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
const int TEST_SWALLOW = 15;
const int END_SWALLOW_BONUS = 2;
const int minQuestionBaseLength = 15;
const int maxNumberOfAttempt = 3;
const int numberOfTestQuestion = 10;

class ChapterService {
  final ChapterRepository _repository;

  ChapterService({
    ChapterRepository repository,
  }) : _repository = repository;

  List<Chapter> chapters;
  Chapter currentChapter;
  GameInfo gameInfo;
  double loadingPercent;
  int lastChapterVersion = 0;
  List<Note> notes = [];
  List<Question> questionBase = [];

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
    if (chapters != null) return;
    List values = await Future.wait([
      SharedPreferences.getInstance(),
      _repository.getChapters(),
    ]);
    print(values);

    chapters = values[1];
    // TODO calc last
    lastChapterVersion = chapters.length;
    final SharedPreferences prefs = values[0];

    final gameString = prefs.getString(gameInfoName);
    if (gameInfo == null) {
      // TODO
      if (gameString == null) {
        gameInfo = GameInfo();
      } else {
        gameInfo = GameInfo.fromJson(gameString);
      }
    }
    // TODO rewrite to bd
    final List<String> notesStrings = prefs.getStringList('notes');
    if (notesStrings != null && notesStrings.length > 0) {
      notes = notesStrings.map<Note>((e) => Note.fromJson(e)).toList();
    }
    final List<String> questionsStrings = prefs.getStringList('questionBase');
    if (questionsStrings != null && questionsStrings.length > 0) {
      questionBase =
          questionsStrings.map<Question>((e) => Question.fromJson(e)).toList();
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
    saveGameInfo();
    // TODO clean logic
    initGame();
  }

  void goNext(String step) {
    if (step != null || gameInfo.currentPassage.links.length == 1) {
      int nextPid = int.parse(step ?? gameInfo.currentPassage.links[0].pid);
      Passage p;
      while (p == null) {
        p = currentChapter.story.script[nextPid.toString()];
        // if cant find step
        nextPid++;
      }
      List<Choice> availableLinks = p.links.where((Choice link) {
        Passage potentialNextPassage = currentChapter.story.script[link.pid];
        bool isHidden = false;
        if (potentialNextPassage != null) {
          String hideCommand = potentialNextPassage.tags
              .firstWhere((tag) => tag.startsWith('Hide:'));
          if (hideCommand != null) {
            List<String> hideCommandParsed = hideCommand.split(':');
            var variableHide = gameInfo.gameVariables[hideCommandParsed[1]];
            if (variableHide != null) {
              String sign = gameInfo.gameVariables[hideCommandParsed[2]];
              String value = gameInfo.gameVariables[hideCommandParsed[3]];
              switch (sign) {
                case '=':
                  isHidden = (variableHide.toString() == value);
                  break;
                case '!=':
                  isHidden = (variableHide.toString() != value);

                  break;
                case '>':
                  // can operate only int
                  isHidden = (variableHide > int.parse(value));

                  break;
                case '<':
                  isHidden = (variableHide < int.parse(value));

                  break;
                case '<=':
                  isHidden = (variableHide <= int.parse(value));

                  break;
                case '>=':
                  isHidden = (variableHide >= int.parse(value));

                  break;
                default:
              }
            }
          }
          String showCommand = potentialNextPassage.tags
              .firstWhere((tag) => tag.startsWith('ShowOnly:'));
          if (showCommand != null) {
            List<String> showCommandParsed = showCommand.split(':');
            var variableShow = gameInfo.gameVariables[showCommandParsed[1]];
            if (variableShow != null) {
              String sign = gameInfo.gameVariables[showCommandParsed[2]];
              String value = gameInfo.gameVariables[showCommandParsed[3]];
              switch (sign) {
                case '=':
                  isHidden = (variableShow.toString() != value);
                  break;
                case '!=':
                  isHidden = (variableShow.toString() == value);

                  break;
                case '>':
                  // can operate only int
                  isHidden = (variableShow <= int.parse(value));

                  break;
                case '<':
                  isHidden = (variableShow >= int.parse(value));

                  break;
                case '<=':
                  isHidden = (variableShow > int.parse(value));

                  break;
                case '>=':
                  isHidden = (variableShow < int.parse(value));

                  break;
                default:
              }
            }
          }
        }
        return !isHidden;
      }).toList();
      gameInfo.currentPassage = p.copyWith(links: availableLinks);
    }
    if (gameInfo.currentPassage.links.length == 0) {
      int diffLastChapter = lastChapterVersion - currentChapter.number;
      final bool isLast = diffLastChapter > 0;
      String contentText =
          !isLast ? chapterContinue.toString() : chapterNoContinue.toString();
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
                if (!isLast)
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          bottom: 10, left: 20, right: 20, top: 20),
                      child: LButton(
                          text: continueGame.toString(),
                          swallow: END_SWALLOW_BONUS, //TODO
                          icon: swallowIcon,
                          func: () {
                            RM.get<ChapterService>().setState((s) {
                              s.gameInfo.currentPassage = null;
                              s.gameInfo.swallowCount += END_SWALLOW_BONUS;
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
        switch (setting[0]) {
          case 'SetAccessToNote':
            gameInfo.accessNoteId = int.parse(setting[1]);
            break;
          case 'SetIntVar':
            gameInfo.gameVariables[setting[1]] = int.parse(setting[2]);
            break;
          case 'SetTextVar':
            gameInfo.gameVariables[setting[1]] = setting[2];
            break;
          default:
        }
      });
    }
    saveGameInfo();
  }

  void initGame() {
    if (gameInfo.currentPassage == null) {
      String pid = currentChapter.story.firstPid;
      gameInfo.currentPassage = currentChapter.story.script[pid];
    }
    saveGameInfo();
  }

  getNotes() {
    return notes
        .takeWhile((value) => value.id <= gameInfo.accessNoteId)
        .toList();
  }

  bool _isAllRead() {
    return !notes.any((element) => element.isRead == null);
  }

  bool _isTestAvailable() => questionBase.length >= minQuestionBaseLength;

  bool _isAttemptLeft() => gameInfo.numberOfTestAttempt < maxNumberOfAttempt;

  void onNewNoteRead(int noteId) {
    gameInfo.numberOfTestAttempt = 0;
    Note note = notes.firstWhere((element) => element.id == noteId);
    if (note.isRead == null || !note.isRead) {
      gameInfo.swallowCount += note.swallow;
    }
    note.isRead = true;
    if (note.questions != null) {
      questionBase.addAll(note.questions);
    }
    saveGameInfo();
  }

  void onTestPassed({bool successful = false}) {
    gameInfo.numberOfTestAttempt++;
    if (successful) {
      gameInfo.swallowCount += TEST_SWALLOW;
    }
    saveGameInfo();
  }

  void changeSwallowDelta(int swallow) {
    gameInfo.swallowCount += swallow;
    saveGameInfo();
  }

  saveGameInfo() {
    SharedPreferences.getInstance().then((value) {
      value.setString(gameInfoName, gameInfo.toJson());
      // TODO
      value.setStringList('notes', notes.map((e) => e.toJson()).toList());
      value.setStringList(
          'questionBase', questionBase.map((e) => e.toJson()).toList());
    });
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
    questionBase.shuffle();
    questionBase.sort((a, b) {
      int a1 = a.isNew ? 0 : 1;
      int b1 = b.isNew ? 0 : 1;
      return b1 - a1;
    });
    List<Question> testQuestion = questionBase.sublist(0, numberOfTestQuestion);
    testQuestion.shuffle();
    return Test(questions: testQuestion);
  }

  getGameVariable(String name) async {
    if (chapters == null) {
      await loadGame();
    }
    return gameInfo.gameVariables[name];
  }

  setGameParam({String name, dynamic value}) {
    gameInfo.gameVariables[name] = value;
    saveGameInfo();
  }
}
