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

  LChoiceBox(
      {this.name,
      @required this.speech,
      @required this.options,
      @required this.onChoose,
      this.isMain = false,
      this.isThinking = false});

  Widget _buildOptionButton(Choice option, double width) {
    return Container(
      // height: 50.0,
      width: width,
      margin: EdgeInsets.only(bottom: 5),
      // margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          borderRadius: boxBorderRadius,
          border: Border.all(color: boxBorderColor, width: 2.0),
          color: Color(0xFFE7F2F7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 8,
            )
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: boxBorderRadius,
          highlightColor: Color(0xFFA3D5EC),
          onTap: () => Function.apply(onChoose, [option]),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10),
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
    return Column(
      children: [
        Container(
          // height: 50.0,
          width: width,
          decoration: BoxDecoration(
              borderRadius: boxBorderRadius,
              border: Border.all(color: Color(0xFFFFBA06), width: 2.0),
              color: Color(0xFFFFF4E0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                )
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Color(0xFFFAD289),
              onTap: () => Function.apply(onChoose, [option]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option.name.toString(),
                      style: contentTextStyle,
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
        Container(
          transform: Matrix4.translationValues(width / 2 - 20, -70, 0),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(premiumStar), fit: BoxFit.contain)),
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
    return Column(
      children: options.map((o) => buildOption(o, width)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.95;
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
