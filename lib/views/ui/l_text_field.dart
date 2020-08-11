import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LTextField extends StatelessWidget{
  final TextEditingController controller;

  LTextField(this.controller);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        hintText: 'Бегайым',
      ),
      maxLength: 12,
      autofocus: false,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp('[а-яА-Я]'))
      ],
      controller: controller,
    );
  }
}
