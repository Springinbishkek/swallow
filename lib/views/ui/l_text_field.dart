import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/views/theme.dart';

class LTextField extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final int maxLength;
  final Function(String) onChanged;

  LTextField(
      this.controller, this.initialValue, this.maxLength, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: boxBorderRadius,
            borderSide: BorderSide(color: boxBorderColor)),
        border: OutlineInputBorder(
          borderRadius: boxBorderRadius,
        ),
        filled: true,
        fillColor: menuBgColor,
        hintText: initialValue,
      ),
      maxLength: maxLength,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      inputFormatters: <TextInputFormatter>[
        // TODO check rule if langs added
        LengthLimitingTextInputFormatter(maxLength),
        FilteringTextInputFormatter.allow(RegExp('[а-яА-Я#0-9 ]')),
      ],
      controller: controller,
      onChanged: (String name) {
        if (onChanged != null) {
          onChanged(name);
        }
      },
      onFieldSubmitted: (value) {
        // TODO
        print('submited');
      },
    );
  }
}
