import 'package:flutter/material.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/translation.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class LLoading extends StatelessWidget {
  const LLoading({
    Key key,
    @required this.percent,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
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
