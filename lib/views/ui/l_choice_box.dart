import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_speech_panel.dart';

class LChoiceBox extends StatelessWidget {
  final String premiumStar = 'assets/icons/premium_star.png';
  final String name;
  final String speech;
  final String option1;
  final String option2;
  final String premiumOption;
  final bool withPremium;

  LChoiceBox(
      {@required this.name,
      @required this.speech,
      @required this.option1,
      @required this.option2,
      this.premiumOption,
      this.withPremium = false});

  Widget _buildOptionButton(String option, Function func, double width) {
    return Container(
      height: 50.0,
      width: width,
      margin: EdgeInsets.only(bottom: 8.0),
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
          highlightColor: Color(0xFFA3D5EC),
          onTap: func,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0),
            child: Text(
              option,
              style: contentTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumOptionButton(String option, Function func, double width) {
    return Column(
      children: [
        Container(
          height: 50.0,
          width: width,
          margin: EdgeInsets.only(bottom: 8.0),
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
              onTap: func,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
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
                            '-15',
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
          transform: Matrix4.translationValues(width / 2 - 15, -75, 0),
          child: Image.asset(
            premiumStar,
            height: 55.0,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(double width) {
    if (withPremium) {
      return Column(
        children: [
          _buildOptionButton(option1, () {
            debugPrint('first option');
          }, width),
          _buildOptionButton(option2, () {
            debugPrint('second option');
          }, width),
          _buildPremiumOptionButton(premiumOption, () {
            debugPrint('premium option');
          }, width)
        ],
      );
    }
    return Column(
      children: [
        _buildOptionButton(option1, () {
          debugPrint('first option');
        }, width),
        _buildOptionButton(option2, () {
          debugPrint('second option');
        }, width),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          LSpeechPanel(name: name, speech: speech),
          Container(
              padding: EdgeInsets.all(16.0),
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              child: _buildButtons(width))
        ],
      ),
    );
  }
}
