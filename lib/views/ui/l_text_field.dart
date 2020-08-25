import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/views/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LTextField extends StatelessWidget {
  final TextEditingController controller;

  LTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> prefSnapshot){
        SharedPreferences prefs = prefSnapshot.data;
        String currentName = prefs?.getString('mainCharacterName') ?? 'Бегайым';
        return TextFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: boxBorderRadius,
                borderSide: BorderSide(color: boxBorderColor)),
            border: OutlineInputBorder(
              borderRadius: boxBorderRadius,
            ),
            filled: true,
            fillColor: menuBgColor,
            hintText: currentName,
          ),
          maxLength: 12,
          autofocus: false,
          textCapitalization: TextCapitalization.words,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[а-яА-Я]'))
          ],
          controller: controller,
          onChanged: (String name) {
            if (name.isEmpty) {
              prefs.setString('mainCharacterName', currentName);
            } else {
              prefs.setString('mainCharacterName', name);
            }
          },
        );
      }
    );
  }
}
