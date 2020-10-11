import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Choice.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/utils/extentions.dart';

import 'package:lastochki/models/entities/Passage.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/ui/l_action.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_choice_box.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_loading.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../theme.dart';
import '../translation.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    RM.get<ChapterService>().setState((s) => s.initGame());
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
        observe: () => RM.get<ChapterService>(),
        onRebuildState: (context, model) async {
          print('onrebuild');
          var popup = model.state.gameInfo.currentPassage?.popup;
          if (popup != null) {
            Future.delayed(
              Duration(milliseconds: 500),
              () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => LInfoPopup(
                      image: alertImg,
                      title: popup.title.toString(),
                      content: popup.content.toString(),
                      actions: LButton(
                          text: understood.toString(),
                          func: () => Navigator.pop(context)))),
            );
          }
        },
        builder: (context, chapterRM) {
          print('rebuild');
          return buildChapter(chapterRM.state.gameInfo);
        });
  }

  void goNext(String step) {
    RM.get<ChapterService>().setState((s) => s.goNext(step));
  }

  Function getTapHandler(Passage p) {
    return p.links.length <= 1 ? (details) => goNext(null) : null;
  }

  Widget buildChapter(GameInfo g) {
    if (g.currentPassage == null) {
      return LLoading(percent: null);
    }

    return GestureDetector(
      onTapUp: getTapHandler(g.currentPassage),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/loading_background.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.black,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildNotes(),
            ],
          ),
          appBar: AppBar(
              leading: FittedBox(
                fit: BoxFit.none,
                child: LAction(
                  child: Image.asset(
                    homeIcon,
                    height: 18,
                    color: whiteColor,
                  ),
                  minWidth: 20,
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/home');
                  },
                ),
              ),
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
                      onTap: () {
                        // TODO
                      }),
                ),
              ]),
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    Passage p = RM.get<ChapterService>().state.gameInfo.currentPassage;
    Map<String, dynamic> variables =
        RM.get<ChapterService>().state.gameInfo.gameVariables ?? {'': ''};
    List<String> characterImages;
    String bgImage = 'assets/backgrounds/loading_background.png';
    bool isThinking = false;
    bool isMain = false;
    String characterName; // TODO

    p.tags.forEach((tag) {
      var t = tag.split(':');
      switch (t[0]) {
        case 'SceneType':
          {
            switch (t[1]) {
              case 'Think':
                isThinking = true;
                break;
              default:
            }
            break;
          }
        case 'SceneImage':
          {
            // TODO
            break;
          }
        case 'CharacterName':
          {
            // vars contain name
            if (!(t[1].contains('\$'))) {
              String nameStr = t[1];

              characterName = nameStr.toName().toString();
            } else {
              characterName = 'Бегайым'; // TODO

            }
            break;
          }
        case 'CharacterImage':
          {
            characterImages =
                t.skip(1).map((e) => 'assets/Base/$e.png').toList();
            break;
          }
        case 'MainCharacter':
          {
            isMain = true;
            break;
          }
        case 'SetAccessToNote':
          {
            // TODO
            break;
          }
        default:
      }
    });

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: buildScene(
          isThinking: isThinking,
          isMain: isMain,
          characterImages: characterImages,
          characterName: characterName,
          bgImage: bgImage,
          speech: p.text.toStringWithVar(variables: variables),
          options: p.links.length > 1 ? p.links : null,
        ));
  }

  void chooseOption(Choice o) {
    print(o.pid);
    goNext(o.pid);
  }

  Widget buildScene({
    bool isThinking,
    bool isMain,
    List<String> characterImages,
    String speech,
    String bgImage,
    String characterName,
    List<Choice> options,
  }) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: characterName != null,
          child: Opacity(
            opacity: characterName == null ? 1 : 0,
            child: Center(
              child: LChoiceBox(
                name: characterName,
                speech: speech,
                options: options,
                onChoose: chooseOption,
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: characterName == null,
          child: Opacity(
            opacity: characterName == null ? 0 : 1,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Flexible(
                flex: 1,
                child: Center(),
              ),
              Flexible(
                  flex: 3,
                  child: Column(children: [
                    if (characterImages != null && characterImages.length > 0)
                      Align(
                        alignment:
                            isMain ? Alignment.topLeft : Alignment.topRight,
                        child: Image.asset(
                          characterImages[0],
                          key: Key(characterImages[0]),
                          width: 220,
                          height: 205,
                          errorBuilder: (context, error, stackTrace) =>
                              SizedBox(
                            width: 220,
                            height: 205,
                            child: Placeholder(),
                          ),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: LChoiceBox(
                        name: characterName,
                        speech: speech,
                        isMain: isMain,
                        isThinking: isThinking,
                        options: options,
                        onChoose: chooseOption,
                      ),
                    ),
                  ]))
            ]),
          ),
        ),
      ],
    );
  }

  Widget buildNotes() {
    return FlatButton.icon(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: () => Navigator.of(context).pushNamed('/notes'),
      icon: SizedBox(height: 44, child: Image.asset(notesIcon)),
      label: Text(''),
    );
  }
}
