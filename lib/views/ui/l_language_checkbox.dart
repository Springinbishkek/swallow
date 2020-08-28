import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class LLanguageCheckbox extends StatefulWidget {
  final bool isColumn;

  LLanguageCheckbox({this.isColumn = true});

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
    return Row(
      children: <Widget>[
        Radio(
            activeColor: textColor,
            value: val,
            groupValue: _radioVal,
            onChanged: (int value) => _onCheckboxTap(value, language)),
        Image.asset(
          flag,
          height: 22,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 4.0),
          child: Text(
            language,
            style: widget.isColumn
                ? contentTextStyle
                : TextStyle(color: textColor, fontSize: 17.0),
          ),
        )
      ],
    );
  }

  Widget _getRow() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: menuBgColor,
        borderRadius: boxBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getCheckbox(0, _ruIcon, 'Русский'),
          _getCheckbox(1, _kgIcon, 'Кыргызча')
        ],
      ),
    );
  }

  Widget _getColumnCheckBox({Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 55,
        width: 220,
        decoration: BoxDecoration(
          color: menuBgColor,
          borderRadius: boxBorderRadius,
        ),
        child: child,
      ),
    );
  }

  Widget _getColumn() {
    return Container(
      child: Column(
        children: <Widget>[
          _getColumnCheckBox(child: _getCheckbox(0, _ruIcon, 'Русский')),
          _getColumnCheckBox(child: _getCheckbox(1, _kgIcon, 'Кыргызча'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isColumn ? _getColumn() : _getRow();
  }
}