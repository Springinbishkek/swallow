import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/utils/extentions.dart';

import 'package:lastochki/models/entities/Passage.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/ui/l_action.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_choice_box.dart';
import 'package:lastochki/views/ui/l_speech_panel.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../theme.dart';
import '../translation.dart';
import 'home_page.dart';

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
        builder: (context, chapterRM) {
          print('rebuild');
          return buildChapter(chapterRM.state.gameInfo);
        });
  }

  void goNext(String step) {
    RM.get<ChapterService>().setState((s) => s.goNext(step));
  }

  Widget buildChapter(GameInfo g) {
    return GestureDetector(
      onTapUp: (details) => goNext(null),
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
            if (t[1] != '\$Main') {
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
        ));
  }

  Widget buildScene({
    bool isThinking,
    bool isMain,
    List<String> characterImages,
    String speech,
    String bgImage,
    String characterName,
  }) {
    if (characterName == null) {
      return Center(
        child: LSpeechPanel(name: null, speech: speech),
      );
    }

    return Column(children: [
      Flexible(
        flex: 1,
        child: Center(),
      ),
      Flexible(
          flex: 3,
          child: Column(children: [
            if (characterImages != null && characterImages.length > 0)
              Align(
                alignment: isMain ? Alignment.topLeft : Alignment.topRight,
                child: Image.asset(
                  characterImages[0],
                  width: 220,
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
                options: null,
                onChoose: null,
              ),
            ),
          ]))
    ]);
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
