import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_language_checkbox.dart';
import 'package:lastochki/views/ui/l_text_field.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Name settings = Name(ru: 'Настройки');
  Name changeLanguage = Name(ru: 'Сменить язык');
  Name changeName = Name(ru: 'Сменить имя героини');
  Name saveSettings = Name(ru: 'Сохранить настройки');

  TextEditingController _textNameController = TextEditingController();

  @override
  void dispose() {
    _textNameController.clear();
    _textNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: appbarBgColor,
        title: Text(
          settings.toString(),
          style: appbarTextStyle,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset(backIcon, height: 24,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
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
                    child: LTextField(_textNameController),
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
                    debugPrint('button tapped');
                  },
                  icon: checkIcon,
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
