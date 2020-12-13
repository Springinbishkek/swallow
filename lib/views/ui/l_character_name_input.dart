import 'package:flutter/material.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/ui/l_text_field.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class LCharacterNameInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  LCharacterNameInput(this.controller, {this.onChanged});

  @override
  _LCharacterNameInputState createState() => _LCharacterNameInputState();
}

class _LCharacterNameInputState extends State<LCharacterNameInput> {
  final int nameMaxLength = 24;

  @override
  Widget build(BuildContext context) {
    String name =
        RM.get<ChapterService>().state.getGameVariable('Main') ?? 'Бегайым';
    return LTextField(widget.controller, name, nameMaxLength, widget.onChanged);
  }
}
