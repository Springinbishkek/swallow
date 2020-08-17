import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/views/theme.dart';

class LTextField extends StatelessWidget {
  final TextEditingController controller;

  LTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: boxBorderColor)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        filled: true,
        fillColor: menuBgColor,
        hintText: 'Бегайым',
      ),
      maxLength: 12,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp('[а-яА-Я]'))
      ],
      controller: controller,
    );
  }
}
