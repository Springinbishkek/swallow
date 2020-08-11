import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LLanguageCheckbox extends StatefulWidget {
  @override
  _LLanguageCheckboxState createState() => _LLanguageCheckboxState();
}

class _LLanguageCheckboxState extends State<LLanguageCheckbox> {
  final String _kgIcon = 'assets/icons/kg_icon.png';
  final String _ruIcon = 'assets/icons/ru_icon.png';
  int _radioVal = 0;

  @override
  void initState() {
    //if(Name.curLocale==Locale('kg')) _radioVal=1;
    super.initState();
  }

  void _onCheckboxTap(int val, String language) {
    setState(() {
      _radioVal = val;
//      if (language == 'Русский' && Name.curLocale == Locale('kg')) {
//        Name.setLocale(Locale('ru'));
//      } else if (language == 'Кыргызча' && Name.curLocale == Locale('ru')) {
//        Name.setLocale(Locale('kg'));
//      }
    });
  }

  Widget _getCheckbox(int val, String flag, String language) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        height: 55,
        decoration: BoxDecoration(
          color: menuBgColor,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Radio(
                activeColor: textColor,
                  value: val,
                  groupValue: _radioVal,
                  onChanged: (int value) => _onCheckboxTap(value, language)),
            ),
            Image.asset(
              flag,
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                language,
                style: contentTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _getCheckbox(0, _ruIcon, 'Русский'),
          _getCheckbox(1, _kgIcon, 'Кыргызча')
        ],
      ),
    );
  }
}
