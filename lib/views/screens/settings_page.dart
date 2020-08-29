import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/screens/notes_page.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_character_name_input.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //TODO: вставить переводы
  Name settings = Name(ru: 'Настройки', kg: 'test');
  Name changeLanguage = Name(ru: 'Сменить язык', kg: 'test');
  Name changeName = Name(ru: 'Сменить имя героини', kg: 'test');
  Name saveSettings = Name(ru: 'Сохранить настройки', kg: 'test');

  TextEditingController _textNameController = TextEditingController();
  String languageCode = Name.curLocale.toString();

  @override
  void dispose() {
    _textNameController.clear();
    _textNameController.dispose();
    super.dispose();
  }

  void onChangeLanguageCode(String code) {
    setState(() {
      languageCode = code;
    });
  }

  void onSaveSettingsTap() {
    setState(() {
      Name.curLocale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBgColor,
      appBar: LAppbar(
          title: settings.toString(),
          func: () {
            Navigator.pop(context);
          }),
      body: Container(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    changeLanguage.toString(),
                    style: subtitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 36.0),
                  child: LLanguageCheckbox(
                    onChanged: onChangeLanguageCode,
                    isColumn: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    changeName.toString(),
                    style: subtitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 36.0),
                  child: LCharacterNameInput(_textNameController),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: 145.0,
            color: whiteColor,
            child: Center(
              child: LButton(
                text: saveSettings.toString(),
                func: () {
                  onSaveSettingsTap();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => NotesPage()));
                },
                icon: checkIcon,
              ),
            ),
          )
        ],
      )),
    );
  }
}
