import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/utils/utility.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_character_name_input.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../translation.dart';

Name changeLanguage = Name(ru: 'Сменить язык', kg: 'Тилди өзгөртүү');
Name changeName =
    Name(ru: 'Сменить имя героини', kg: 'Каармандын атын өзгөртүү');
Name saveSettings = Name(ru: 'Сохранить настройки', kg: 'Баптоолорду сактоо');
Name restartGame =
    Name(ru: 'Начать игру заново', kg: 'Оюнду өчүрүп-күйгүзүңүз');

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String languageCode = Name.curLocale.toString();
  bool isLoading = false;
  TextEditingController _textNameController = TextEditingController();

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

  VoidCallback /*?*/ getOnSaveSettingsTap(context) {
    if (_textNameController.text.trim() == '') {
      return null;
    }
    return () => onSaveSettingsTap(context);
  }

  void onSaveSettingsTap(BuildContext context) async {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('languageCode', languageCode));
    setState(() {
      Name.curLocale = Locale(languageCode);
    });
    String name = _textNameController.text;
    RM
        .get<ChapterService>('ChapterService')
        .setState((s) => s.setGameParam(name: 'Main', value: name));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(confirmChange.toString()),
      ),
    );
    if (name.startsWith('#')) {
      ReactiveModel<ChapterService> chapterService =
          RM.get<ChapterService>('ChapterService');
      var cheat = name.substring(1).split(' ');
      if (cheat.length == 2) {
        await chapterService.state.prepareChapter(id: int.parse(cheat[1]));
      }
      chapterService.state.goNext(cheat[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBgColor,
      appBar: lAppbar(
          title: settings.toString(),
          func: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
                      child: LCharacterNameInput(
                        _textNameController,
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: LButton(
                        text: restartGame.toString(),
                        func: () => onRestartGame(context),
                        icon: refreshIcon,
                        buttonColor: Colors.white,
                        borderColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 145.0,
            color: whiteColor,
            child: Center(
              child: Builder(
                builder: (context) => LButton(
                  text: saveSettings.toString(),
                  func: getOnSaveSettingsTap(context),
                  icon: checkIcon,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
