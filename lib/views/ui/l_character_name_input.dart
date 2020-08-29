import 'package:flutter/material.dart';
import 'package:lastochki/views/ui/l_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LCharacterNameInput extends StatefulWidget {
  final TextEditingController controller;

  LCharacterNameInput(this.controller);

  @override
  _LCharacterNameInputState createState() => _LCharacterNameInputState();
}

class _LCharacterNameInputState extends State<LCharacterNameInput> {
  SharedPreferences prefs;
  String currentName;

  void onChanged(String name) {
    prefs.setString('mainCharacterName', name.isEmpty ? currentName : name);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context,
            AsyncSnapshot<SharedPreferences> prefSnapshot) {
          prefs = prefSnapshot.data;
          currentName = prefs?.getString('mainCharacterName') ?? 'Бегайым';
          return LTextField(widget.controller, currentName, 12, onChanged);
        });
  }
}
