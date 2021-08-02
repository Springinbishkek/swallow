import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LInfoPopup extends StatelessWidget {
  final String image;
  final String title;
  final bool isCloseEnable;
  final String content;
  final Widget actions;

  LInfoPopup(
      {@required this.image,
      @required this.title,
      this.isCloseEnable = true,
      @required this.content,
      @required this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        side: BorderSide(color: boxBorderColor, width: 2.0),
      ),
      backgroundColor: menuBgColor,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 14.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Container(
                  constraints: BoxConstraints(minWidth: 150, minHeight: 150),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.fitHeight)),
                ),
              ),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title ?? '',
                    style: titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                child: Text(
                  content ?? '',
                  style: noteTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              //Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
                child: actions,
              )
            ],
          ),
          if (isCloseEnable)
            Positioned(
                right: 0.0,
                child: IconButton(
                    icon: Image.asset(
                      closeIcon,
                      height: 14,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }))
        ],
      ),
    );
  }
}
