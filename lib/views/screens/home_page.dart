import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/ui/l_action.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../theme.dart';
import '../translation.dart';

final Name loading = Name(
  ru: 'Загрузка',
  kg: 'Загрузка',
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    RM.get<ChapterService>().setState((s) => s.loadGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateBuilder(
          observe: () => RM.get<ChapterService>(),
          onSetState: (context, model) {
            print('reset');
          },
          builder: (context, chapterRM) {
            print('rebuild');
            return (chapterRM.state.loadingPercent != null ||
                    chapterRM.state.gameInfo == null)
                ? buildLoading(chapterRM.state.getLoadingPercent())
                : buildChapter(chapterRM.state.currentChapter);
          }),
    );
  }

  void startGame() {
    // TODO
  }

  Widget buildChapter(Chapter ch) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/loading_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
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
                          '30', // TODO
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 18,
                              height: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {}),
              ),
            ]),
        body: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 7,
                child: Center(),
              ),
              Flexible(
                flex: 8,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: menuBgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(48, 90, 48, 20),
                        child: Column(
                          children: [
                            Text('Глава ${ch.number}', // TODO
                                style: subtitleTextStyle),
                            SizedBox(height: 10),
                            Text(ch.title.toString(),
                                style: titleLightTextStyle),
                            SizedBox(height: 34),
                            LButton(
                              text: 'начать игру',
                              func: startGame,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildItem(aboutGame.toString(), () {
                              // TODO
                            }, Image.asset(aboutIcon)),
                            buildItem(settings.toString(), () {
                              Navigator.of(context).pushNamed('/settings');
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
    );
  }

  Widget buildItem(String text, Function onTap, Widget icon) {
    return FlatButton.icon(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: onTap,
      icon: SizedBox(height: 14, child: icon),
      label: Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  Widget buildLoading(double percent) {
    print('percent $percent');
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/loading_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$loading...',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 10),
            SizedBox(
                width: 200,
                height: 10,
                child: StateBuilder(
                    observe: () => RM.get<ChapterService>(),
                    builder: (context, chapterRM) {
                      print('chapterRM.state.loadingPercent');
                      return LinearProgressIndicator(
                        value: chapterRM.state
                            .getLoadingPercent(), // TODO fix percent bug
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
