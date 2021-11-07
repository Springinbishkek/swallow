import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';

class LLoading extends StatelessWidget {
  final double percent;
  final String title;
  const LLoading({
    Key key,
    this.percent,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label =
        percent == null ? '$loading...' : '${(percent * 100).floor()}%';
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/loading_background.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.bottomLeft,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? label,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: loadingTextColor),
            ),
            SizedBox(height: 10),
            SizedBox(
                width: 200,
                height: 10,
                child: LinearProgressIndicator(
                  value: percent,
                ))
          ],
        ),
      ),
    );
  }
}
