import 'package:flutter/material.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/ui/l_text_field.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

const int nameMaxLength = 24;

class LCharacterNameInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  LCharacterNameInput(this.controller, {this.onChanged});

  @override
  _LCharacterNameInputState createState() => _LCharacterNameInputState();
}

class _LCharacterNameInputState extends State<LCharacterNameInput> {
  @override
  void initState() {
    widget.controller.text =
        RM.get<ChapterService>().state.getGameVariable('Main') ?? 'Бегайым';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LTextField(widget.controller, nameMaxLength, widget.onChanged);
  }
}
