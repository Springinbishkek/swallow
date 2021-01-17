import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_character_name_input.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../translation.dart';

class SettingsPage extends StatelessWidget {
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
      body: SettingBody(),
    );
  }
}

class SettingBody extends StatefulWidget {
  @override
  _SettingBodyState createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  String languageCode = Name.curLocale.toString();
  Name changeLanguage = Name(ru: 'Сменить язык', kg: 'Тилди өзгөртүү');
  Name changeName =
      Name(ru: 'Сменить имя героини', kg: 'Каармандын атын өзгөртүү');
  Name saveSettings = Name(ru: 'Сохранить настройки', kg: 'Баптоолорду сактоо');

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

  Function getOnSaveSettingsTap() {
    if (_textNameController.text.trim() == '') {
      return null;
    }
    return onSaveSettingsTap;
  }

  void onSaveSettingsTap() async {
    setState(() {
      Name.curLocale = Locale(languageCode);
    });
    String name = _textNameController.text;
    RM
        .get<ChapterService>()
        .setState((s) => s.setGameParam(name: 'Main', value: name));
    if (name.startsWith('#')) {
      ReactiveModel chapterService = RM.get<ChapterService>();
      var cheat = name.substring(1).split(' ');
      if (cheat.length == 2) {
        await chapterService.state.loadChapter(id: int.parse(cheat[1]));
      }
      chapterService.state.goNext(cheat[0]);
    }

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(confirmChange.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    child: LCharacterNameInput(_textNameController),
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
            child: LButton(
              text: saveSettings.toString(),
              func: getOnSaveSettingsTap(),
              icon: checkIcon,
            ),
          ),
        )
      ],
    );
  }
}
