import 'package:flutter/material.dart';

class CoverPage extends StatelessWidget {
  final List<Widget> appBarActions;
  final Widget bodyContent;

  const CoverPage({
    Key key,
    this.appBarActions = const [],
    @required this.bodyContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            actions: appBarActions,
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Spacer(
                  flex: 2,
                ),
                Flexible(
                  flex: 7,
                  child: Image.asset('assets/backgrounds/chapter_book.png'),
                ),
                Flexible(
                  flex: MediaQuery.of(context).size.height < 800 ? 7 : 6,
                  child: bodyContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
