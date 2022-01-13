import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/services/analytics_service.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/utils/utility.dart';
import 'package:lastochki/views/screens/cover_page.dart';
import 'package:lastochki/views/ui/l_action.dart';
import 'package:lastochki/views/ui/l_button.dart';
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
    return StateBuilder<ChapterService>(
      observe: () => RM.get<ChapterService>('ChapterService'),
      builder: (context, chapterRM) => AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        child: chapterRM.state.isNeedLoader()
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
                    title: chapterRM.state.loadingTitle,
                  )
            : _Chapter(
                chapter: chapterRM.state.currentChapter,
                gameInfo: chapterRM.state.gameInfo,
                onSettingsClosed: () {
                  setState(() {
                    // TODO fix language update
                  });
                },
              ),
      ),
    );
  }
}

class _Chapter extends StatelessWidget {
  final Chapter chapter;
  final GameInfo gameInfo;
  final VoidCallback onSettingsClosed;

  const _Chapter({
    Key key,
    @required this.chapter,
    @required this.gameInfo,
    @required this.onSettingsClosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CoverPage(
      key: Key(chapter.number.toString()),
      appBarActions: [
        FittedBox(
          fit: BoxFit.none,
          child: _SwallowCount(
            swallowCount: gameInfo.swallowCount,
          ),
        ),
      ],
      bodyContent: Column(
        children: [
          Spacer(flex: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: _ChapterInfo(
              chapter: chapter,
              gameInfo: gameInfo,
            ),
          ),
          Spacer(flex: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _GameActions(
              onSettingsClosed: onSettingsClosed,
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _SwallowCount extends StatelessWidget {
  final int swallowCount;

  const _SwallowCount({
    Key key,
    @required this.swallowCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LAction(
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
            swallowCount.toString(),
            style: TextStyle(
              color: whiteColor,
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: null,
    );
  }
}

class _ChapterInfo extends StatelessWidget {
  final Chapter chapter;
  final GameInfo gameInfo;

  const _ChapterInfo({
    Key key,
    @required this.chapter,
    @required this.gameInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int lastChapterNumber = RM.get<ChapterService>().state.lastChapterNumber;
    int totalChapterNumber = RM.get<ChapterService>().state.totalChapterNumber;
    Name futureChapterText = RM.get<ChapterService>().state.futureChapterText;
    if (totalChapterNumber < gameInfo.currentChapterId) {
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
            func: () => onRestartGame(context),
          )
        ],
      );
    }
    if (lastChapterNumber < gameInfo.currentChapterId) {
      return Center(
        child: Text(futureChapterText.toString(), style: titleLightTextStyle),
      );
    }
    return Column(
      children: [
        Align(
          child: Text(
            numberChapter.toStringWithVar(variables: {
              'number': chapter?.number ?? 0,
            }),
            style: subtitleTextStyle,
          ),
        ),
        SizedBox(height: 10),
        Text(chapter.title.toString(), style: titleLightTextStyle),
        SizedBox(height: 34),
        LButton(
          text: gameInfo.currentPassage == null
              ? letsPlay.toString()
              : continueGame.toString(),
          func: () => Navigator.of(context).pushReplacementNamed('/game'),
        )
      ],
    );
  }
}

class _GameActions extends StatelessWidget {
  final VoidCallback onSettingsClosed;

  const _GameActions({
    Key key,
    @required this.onSettingsClosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _GameActionsItem(
          text: aboutGame.toString(),
          onTap: () {
            RM.get<AnalyticsService>().state.log(
              name: 'about_open',
            );
            Navigator.of(context).pushNamed('/about');
          },
          icon: Image.asset(aboutIcon, color: accentColor),
        ),
        _GameActionsItem(
          text: settings.toString(),
          onTap: () async {
            await Navigator.of(context).pushNamed('/settings');
            onSettingsClosed();
          },
          icon: Image.asset(settingsIcon, color: accentColor),
        ),
        _GameActionsItem(
          text: notes.toString(),
          onTap: () {
            Navigator.of(context).pushNamed('/notes');
          },
          icon: NotesIcon(),
        ),
      ],
    );
  }
}

class _GameActionsItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget icon;

  const _GameActionsItem({
    Key key,
    @required this.text,
    @required this.onTap,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
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
