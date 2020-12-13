import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Choice.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/utils/extentions.dart';

import 'package:lastochki/models/entities/Passage.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/ui/l_action.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_character_image.dart';
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
  bool isStepDisabled = false;
  String currentPassagePid = '';

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
          debugPrint('onrebuild');
          var popup = model.state.gameInfo.currentPassage?.popup;
          if (popup != null &&
              currentPassagePid != model.state.gameInfo.currentPassage.pid) {
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
          currentPassagePid = model.state.gameInfo.currentPassage.pid;
        },
        builder: (context, chapterRM) {
          debugPrint('rebuild');
          return buildChapter(chapterRM.state.gameInfo);
        });
  }

  void goNext(String step) {
    RM.get<ChapterService>().setState((s) => s.goNext(step));
    setState(() {
      isStepDisabled = true;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        isStepDisabled = false;
      });
    }); //TODO bring deeper
  }

  Function getTapHandler(Passage p) {
    if (isStepDisabled) return null;
    return p.links.length <= 1 ? (details) => goNext(null) : null;
  }

  Widget buildChapter(GameInfo g) {
    if (g.currentPassage == null) {
      return LLoading(percent: null);
    }
    ImageProvider bgImage = RM.get<ChapterService>().state.bgImage;
    ImageProvider bgPreviousImage =
        RM.get<ChapterService>().state.bgPreviousImage;

    return GestureDetector(
      onTapUp: getTapHandler(g.currentPassage),
      child: Stack(children: [
        Container(
          height: double.infinity,
          child: FadeInImage(
            placeholder: bgPreviousImage,
            image: bgImage,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
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
                            g.swallowCount.toString(), // TODO
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
      ]),
    );
  }

  Widget buildBody() {
    Passage p = RM.get<ChapterService>().state.gameInfo.currentPassage;
    Map<String, dynamic> variables =
        RM.get<ChapterService>().state.gameInfo.gameVariables ?? {'': ''};
    Map<String, ImageProvider> images = RM.get<ChapterService>().state.images;
    List<ImageProvider> characterImages;
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
        case 'CharacterName':
          {
            // vars contain name
            if (!(t[1].contains('\$'))) {
              String nameStr = t[1];

              characterName = nameStr.toName().toString();
            } else {
              characterName = variables['Main']; // TODO

            }
            break;
          }
        case 'CharacterImage':
          {
            characterImages = t.skip(1).map((e) {
              // if (e.startsWith('Base_')) {
              //   return 'assets/Base/$e.png';
              // }
              //  TODO
              return images['$e.png'];
            }).toList();
            break;
          }
        case 'MainCharacter':
          {
            isMain = true;
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
          pid: p.pid,
          characterImages: characterImages,
          characterName: characterName,
          speech: p.text.toStringWithVar(variables: variables),
          options: p.links.length > 1 ? p.links : null,
        ));
  }

  void chooseOption(Choice o) {
    ReactiveModel chapterService = RM.get<ChapterService>();
    print(o.pid);
    if (chapterService.state.gameInfo.swallowCount < o.swallow) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LInfoPopup(
          image: alertImg,
          title: needMoreSwallowTitle.toString(),
          content: needMoreSwallowContent.toString(),
          actions: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LButton(
                  text: takeTest.toString(),
                  func: () => Navigator.pushNamed(context, '/test'),
                ),
                LButton(
                  text: backToChapter.toString(),
                  func: () => Navigator.pop(context),
                  buttonColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      chapterService.state.changeSwallowDelta(-o.swallow);
      goNext(o.pid);
    }
  }

  Widget buildScene({
    bool isThinking,
    bool isMain,
    List<ImageProvider> characterImages,
    String speech,
    String pid,
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
                      LCharacterImage(
                        photoImages: characterImages,
                        key: Key(pid.toString()),
                        isMain: isMain,
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
                          onEndAnimation: () {
                            setState(() {
                              isStepDisabled = false;
                            });
                          }),
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
