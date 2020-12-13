import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Choice.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/Passage.dart';
import 'package:lastochki/models/entities/Photo.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/models/entities/Test.dart';
import 'package:lastochki/services/chapter_repository.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'db_helper.dart';

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
  Name futureChapterText;
  Chapter currentChapter;
  GameInfo gameInfo;
  double loadingPercent;
  Stream loadingPercentStream;
  int lastChapterNumber = 0;
  List<Note> notes = [];
  List<Question> questionBase = [];
  DBHelper dbHelper = DBHelper();
  Map<String, ImageProvider> images = {};
  String previousBgName;

  void onReceive(int loaded, int info, {double total}) {
    // TODO
    // RM
    //     .get<ChapterService>()
    //     .setState((s) => s.loadingPercent = loaded / (total ?? loaded));
    loadingPercent = loaded / (total ?? loaded);
    print('loadingPercent $loadingPercent');
    // print('$loaded  $info $total $loadingPercent');
  }

  Chapter getCurrentChapter() {
    return currentChapter;
  }

  double getLoadingPercent() {
    return loadingPercent;
  }

  get bgImage {
    return images['${gameInfo.currentBgName}.jpg'] ??
        AssetImage('assets/backgrounds/loading_background.jpg');
  }

  get bgPreviousImage {
    return images['$previousBgName.jpg'] ??
        AssetImage('assets/backgrounds/loading_background.jpg');
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

    chapters = values[1]['chapters'];
    futureChapterText = values[1]['futureChapterText'];
    // TODO calc last
    lastChapterNumber = chapters.length;
    final SharedPreferences prefs = values[0];

    final gameString = prefs.getString(gameInfoName);
    if (gameString == null) {
      gameInfo = GameInfo();
    } else {
      gameInfo = GameInfo.fromJson(gameString);
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
    int currentChapterId = id ??
        (gameInfo.currentPassage == null
            ? gameInfo.currentChapterId + 1
            : gameInfo.currentChapterId);
    currentChapter =
        chapters.firstWhere((element) => element.number == currentChapterId);
    if (currentChapter?.number != currentChapterId ||
        currentChapter?.version != gameInfo.currentChapterVersion ||
        dbHelper.version != gameInfo.currentDBVersion) {
      double freeSpaceMB = await DiskSpace.getFreeDiskSpace;
      print(freeSpaceMB);
      print(await DiskSpace.getTotalDiskSpace);
      if (currentChapter.mBytes >= freeSpaceMB) {
        // try to clean all except base data
        await dbHelper.cleanChapterExcept(0);
      }
      freeSpaceMB = await DiskSpace.getFreeDiskSpace;
      print(freeSpaceMB);
      if (currentChapter.mBytes >= freeSpaceMB) {
        RM.navigate.toDialog(
          LInfoPopup(
              isCloseEnable: false,
              image: alertImg,
              title: noPlace.toString(),
              content: noPlaceText.toString(),
              actions: Column(
                children: [
                  LButton(
                      buttonColor: whiteColor,
                      text: understood.toString(),
                      icon: refreshIcon,
                      func: () {
                        RM.navigate.back();
                      }),
                ],
              )),
        );
        print('no enought memory');
      } else {
        await loadChapterInfo(currentChapterId: currentChapterId);
      }
    }

    List<Photo> p = await dbHelper.getPhotos();
    Iterable<MapEntry<String, ImageProvider>> pairs = p.map((e) {
      File photoFile = File(e.imgPath);
      var image = FileImage(photoFile);
      return MapEntry(e.photoName, image);
    });
    images.addEntries(pairs);
    currentChapter.story = await dbHelper.getStory(currentChapterId);
    gameInfo.currentChapterId = currentChapterId;
    gameInfo.currentChapterVersion = currentChapter.version;
    gameInfo.currentDBVersion = dbHelper.version;
    loadingPercent = null;
    saveGameInfo();
    // TODO clean logic
    initGame();
  }

  Future<void> loadChapterInfo({int currentChapterId}) async {
    Map data = await _repository.getStory(
        currentChapter,
        (i, j) =>
            this.onReceive(i, j, total: currentChapter.mBytes * 1024 * 1024));
    final zipFile = File(data['zipPath']);
    final Directory dir = await getApplicationDocumentsDirectory();

    Directory destinationDir;
    final Directory probablyDir = Directory('${dir.path}/Base');
    if (!await probablyDir.exists()) {
      destinationDir = await probablyDir.create();
    } else {
      destinationDir = probablyDir;
    }

    await dir.create();
    print('destinationChapterDir $destinationDir');
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: (zipEntry, progress) {
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ExtractOperation.extract;
          });
      List<FileSystemEntity> files = destinationDir.listSync();
      await Future.forEach(files, (element) async {
        if (element is File) {
          String name = element.path.split("/")?.last;
          int photoChapterId = name.contains('Base_') ? 0 : currentChapterId;
          String imgPath = element.path;
          Photo photo = Photo(0, photoChapterId, name, imgPath);
          await dbHelper.save(photo);
        }
      });
    } catch (e) {
      print(e);
    }
    Story s = data['story'];
    await dbHelper.saveStory(s);
    var uniqNotes = notes.toSet();
    uniqNotes.addAll(data['notes']);
    notes = uniqNotes.toList();
    notes.sort((Note a, Note b) => a.id.compareTo(b.id));
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
              .firstWhere((tag) => tag.startsWith('Hide:'), orElse: () => null);
          if (hideCommand != null) {
            List<String> hideCommandParsed = hideCommand.split(':');
            var variableHide = gameInfo.gameVariables[hideCommandParsed[1]];
            if (variableHide != null) {
              String sign = hideCommandParsed[2];
              String value = hideCommandParsed[3];
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
          String showCommand = potentialNextPassage.tags.firstWhere(
              (tag) => tag.startsWith('ShowOnly:'),
              orElse: () => null);
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
      final bool isLast = lastChapterNumber == currentChapter.number;
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
          case 'SceneImage':
            previousBgName = gameInfo.currentBgName;
            gameInfo.currentBgName = setting[1];
            break;
          default:
        }
      });
    }
    saveGameInfo();
  }

  void initGame() {
    if (gameInfo.currentPassage == null) {
      String pid = currentChapter?.story?.firstPid;
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
    return notes.every((note) =>
        note.id > gameInfo.accessNoteId ||
        (note.isRead != null && note.isRead));
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

  dynamic getGameVariable(String name) {
    if (gameInfo == null) {
      gameInfo = GameInfo();
    }
    return gameInfo.gameVariables[name];
  }

  setGameParam({String name, dynamic value}) {
    gameInfo.gameVariables[name] = value;
    saveGameInfo();
  }
}
