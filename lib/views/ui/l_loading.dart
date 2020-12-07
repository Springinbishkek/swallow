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
    print(RM.get<ChapterService>().state.getLoadingPercent());
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
                    watch: (ReactiveModel<ChapterService> exposedModel) {
                      return exposedModel.state.loadingPercent;

                      //Specify the parts of the state to be monitored so that the notification is not sent unless this part changes
                    },
                    shouldRebuild:
                        (ReactiveModel<ChapterService> exposedModel) {
                      //Returns bool. if true the widget will rebuild if notified.
                      print('shouldRebuild');

                      //By default StateBuilder will rebuild only if the notifying model has data.
                      return exposedModel.hasData;
                    },
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
