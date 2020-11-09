import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Choice.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_speech_panel.dart';

class LChoiceBox extends StatelessWidget {
  final String premiumStar = 'assets/icons/premium_star.png';
  final String name;
  final String speech;
  final bool isMain;
  final bool isThinking;
  final List<Choice> options;
  final Function onChoose;
  final Function onEndAnimation; //TODO

  LChoiceBox(
      {this.name,
      @required this.speech,
      @required this.options,
      @required this.onChoose,
      this.onEndAnimation,
      this.isMain = false,
      this.isThinking = false});

  Widget _buildOptionButton(Choice option, double width) {
    return Container(
      width: width,
      margin: EdgeInsets.only(bottom: 5),
      // margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          borderRadius: boxBorderRadius,
          border: Border.all(color: boxBorderColor, width: 2.0),
          color: Color(0xFFE7F2F7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(4, 4),
              blurRadius: 8,
            )
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: boxBorderRadius,
          highlightColor: Color(0xFFA3D5EC),
          onTap: () {
            debugPrint('simple');
            debugPrint(option.toString());
            onChoose(option);
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: Text(
              option.name.toString(),
              style: contentTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumOptionButton(Choice option, double width) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          width: width,
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              borderRadius: boxBorderRadius,
              border: Border.all(color: Color(0xFFFFBA06), width: 2.0),
              color: Color(0xFFFFF4E0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(8, 8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 8,
                )
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Color(0xFFFAD289),
              onTap: () {
                print('option $option');
                onChoose(option);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        option.name.toString(),
                        style: contentTextStyle,
                      ),
                    ),
                    Container(
                      height: 25.0,
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Color(0xFFEDC06B)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '-${option.swallow}',
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          Image.asset(
                            swallowIcon,
                            color: whiteColor,
                            height: 16.0,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -13,
          right: -25,
          child: IgnorePointer(
            child: Image.asset(
              premiumStar,
              fit: BoxFit.contain,
              width: 60,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOption(Choice option, double width) {
    if (option.swallow != null && option.swallow > 0) {
      return _buildPremiumOptionButton(option, width);
    }
    return _buildOptionButton(option, width);
  }

  Widget _buildButtons(double width) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 300),
        builder: (BuildContext context, double size, Widget child) {
          List<Widget> children = [];
          options.forEach((o) {
            children.add(Transform.scale(
              scale: size,
              origin: Offset(0, 0),
              child: buildOption(o, width),
            ));
          });
          return Column(
            children: children,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double widgetWidth = MediaQuery.of(context).size.width;
    double width = widgetWidth * 0.95;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LSpeechPanel(
            name: name,
            speech: speech,
            isLeftSide: isMain,
            isThinking: isThinking),
        if (options != null)
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              transform: Matrix4.translationValues(0.0, -7, 0.0),
              child: _buildButtons(width))
      ],
    );
  }
}
