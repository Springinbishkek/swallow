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
  String currentName;

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
        observe: () => RM.get<ChapterService>(),
        initState: (context, model) async {
          var name = await model.state.getGameVariable('Main');
          setState(() {
            currentName = name ?? 'Бегайым';
          });
        },
        builder: (context, ReactiveModel<ChapterService> chapterRM) {
          return LTextField(
              widget.controller, currentName, nameMaxLength, widget.onChanged);
        });
  }
}
