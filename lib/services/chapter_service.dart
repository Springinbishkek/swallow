import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Passage.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/services/chapter_repository.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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

  loadGame() async {
    // TODO
    List values = await Future.wait([
      SharedPreferences.getInstance()
          .then((value) => value.getString('gameInfo')),
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

  loadChapter() async {
    // TODO check free space
    int currentChapterId = gameInfo.currentPassage == null
        ? gameInfo.currentChapterId + 1
        : gameInfo.currentChapterId;
    currentChapter =
        chapters.firstWhere((element) => element.number == currentChapterId);
    Story s = await _repository.getStory(
        currentChapter,
        (i, j) =>
            this.onReceive(i, j, total: currentChapter.mBytes * 1024 * 1024));
    currentChapter.story = s;
    gameInfo.currentChapterId = currentChapterId;
    loadingPercent = null;
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
  }

  void initGame() {
    if (gameInfo.currentPassage == null) {
      String pid = currentChapter.story.firstPid;
      //
      // pid = '1106';
      gameInfo.currentPassage = currentChapter.story.script[pid];
    }
  }
}
