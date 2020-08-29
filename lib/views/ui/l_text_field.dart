import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/views/theme.dart';

class LTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final Function onChanged;

  LTextField(this.controller, this.hintText, this.maxLength, this.onChanged);

  @override
  Widget build(BuildContext context) {
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
          hintText: hintText,
        ),
        maxLength: maxLength,
        autofocus: false,
        textCapitalization: TextCapitalization.words,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[а-яА-Я]'))
        ],
        controller: controller,
        onChanged: (String name) => onChanged(name));
  }
}
