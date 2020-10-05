import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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
    RM.get<ChapterService>().state.loadGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateBuilder(
          observe: () => RM.get<ChapterService>(),
          builder: (context, chapterRM) {
            return (chapterRM.state.loadingPercent != null ||
                    chapterRM.state.gameInfo == null)
                ? buildLoading()
                : buildChapter(chapterRM.state.currentStory);
          }),
    );
  }

  Widget buildChapter(Story s) {
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
              s.title.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    ReactiveModel<ChapterService> chapterRM = RM.get<ChapterService>();
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
              child: LinearProgressIndicator(
                value: chapterRM.state.loadingPercent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
