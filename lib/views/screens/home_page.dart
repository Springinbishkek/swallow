import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/utils/utility.dart';
import 'package:lastochki/views/ui/l_action.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_loading.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../theme.dart';
import '../translation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    RM.get<ChapterService>('ChapterService').setState((s) => s.loadGame());
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
        observe: () => RM.get<ChapterService>('ChapterService'),
        builder: (context, chapterRM) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              child: (chapterRM.state.isNeedLoader())
                  ? chapterRM.state.wasLoadingError
                      ? Container(
                          color: Colors.white,
                          child: Center(
                            child: LButton(
                              icon: refreshIcon,
                              buttonColor: whiteColor,
                              text: repeatLoading.toString(),
                              func: () => chapterRM.state.loadGame(),
                            ),
                          ),
                        )
                      : LLoading(
                          key: Key('loading home page'),
                          percent: chapterRM.state.getLoadingPercent(),
                          title: chapterRM.state.loadingTitle)
                  : buildChapter(chapterRM.state.currentChapter,
                      chapterRM.state.gameInfo));
        });
  }

  void startGame() {
    Navigator.of(context).pushReplacementNamed('/game');
  }

  Widget buildChapter(Chapter ch, GameInfo g) {
    return Container(
      key: Key(ch.number.toString()),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/chapter_home_background.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              actions: [
                FittedBox(
                  fit: BoxFit.none,
                  child: LAction(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            swallowIcon,
                            height: 18,
                            color: whiteColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            g.swallowCount.toString(),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: null),
                ),
              ]),
          body: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Center(),
                ),
                Flexible(
                  flex: 7,
                  child: Image.asset('assets/backgrounds/chapter_book.png'),
                ),
                Flexible(
                  flex: MediaQuery.of(context).size.height < 800 ? 7 : 6,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: menuBgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(48, 40, 48, 20),
                          child: buildChapterInfo(ch, g),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildItem(aboutGame.toString(), () {
                                Navigator.of(context).pushNamed('/about');
                              }, Image.asset(aboutIcon)),
                              buildItem(settings.toString(), () async {
                                await Navigator.of(context)
                                    .pushNamed('/settings');
                                setState(() {
                                  // TODO fix language update
                                });
                              }, Image.asset(settingsIcon)),
                              buildItem(notes.toString(), () {
                                Navigator.of(context).pushNamed('/notes');
                              }, Image.asset(notesIcon)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChapterInfo(Chapter ch, GameInfo g) {
    int lastChapterNumber = RM.get<ChapterService>().state.lastChapterNumber;
    int totalChapterNumber = RM.get<ChapterService>().state.totalChapterNumber;
    Name futureChapterText = RM.get<ChapterService>().state.futureChapterText;
    if (totalChapterNumber < g.currentChapterId)
      return Column(
        children: [
          Text(
            gameEndTitle.toString(),
            style: titleTextStyle,
          ),
          SizedBox(height: 10),
          Text(restartGameText.toString(), style: subtitleLightTextStyle),
          SizedBox(height: 34),
          LButton(
            text: restartGame.toString(),
            func: onRestartGame,
          )
        ],
      );
    if (lastChapterNumber < g.currentChapterId) {
      return Center(
          child:
              Text(futureChapterText.toString(), style: titleLightTextStyle));
    }
    return Column(
      children: [
        Align(
          child: Text(
              numberChapter
                  .toStringWithVar(variables: {'number': ch?.number ?? 0}),
              style: subtitleTextStyle),
        ),
        SizedBox(height: 10),
        Text(ch.title.toString(), style: titleLightTextStyle),
        SizedBox(height: 34),
        LButton(
          text: g.currentPassage == null
              ? letsPlay.toString()
              : continueGame.toString(),
          func: (){
            final bool isLast = true;
            final bool isLastTotal = true;
            String contentText = !isLast
                ? chapterContinue.toString()
                : isLastTotal
                ? chapterEndGame.toString()
                : chapterNoContinue.toString();
            // story end
            RM.navigate.toDialog(
              LInfoPopup(
                  isCloseEnable: false,
                  image: endImg,
                  title: chapterEnd
                      .toStringWithVar(variables: {'chapter': 5}),
                  content: contentText,
                  actions: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!isLast)
                          LButton(
                              text: continueGame.toString(),
                              swallow: END_SWALLOW_BONUS, //TODO
                              icon: swallowIcon,
                              func: () {
                                RM.get<ChapterService>().setState((s) {
                                  s.gameInfo.currentPassage = null;
                                  s.gameInfo.swallowCount += END_SWALLOW_BONUS;
                                });
                                RM.get<ChapterService>().setState((s) async {
                                  await s.prepareChapter(
                                      id: s.gameInfo.currentChapterId + 1);
                                });
                                RM.navigate.back();
                              }),
                        SizedBox(height: 10),
                        LButton(
                            buttonColor: whiteColor,
                            text: replayChapter.toString(),
                            icon: refreshIcon,
                            func: () {
                              RM.get<ChapterService>().setState((s) {
                                s.initGame();
                              });
                              RM.navigate.back();
                            }),
                        SizedBox(height: 5),
                        LButton(
                            icon: homeIcon,
                            buttonColor: whiteColor,
                            text: toHomePage.toString(),
                            // fontSize: 10,
                            // height: 30,
                            func: () {
                              RM.navigate.toReplacementNamed('/home');
                            }),
                      ],
                    ),
                  )),
            );
          }
          ,
        )
      ],
    );
  }

  Widget buildItem(String text, Function onTap, Widget icon) {
    return TextButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 5, vertical: 10)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      ),
      onPressed: onTap,
      icon: SizedBox(height: 14, child: icon),
      label: Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 13),
      ),
    );
  }


}
