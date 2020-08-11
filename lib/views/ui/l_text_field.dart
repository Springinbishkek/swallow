import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/models/entities/Heroine.dart';

class LTextField extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        hintText: HeroineName.getState().initName,
      ),
      maxLength: 12,
      autofocus: false,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp('[а-яА-Я]'))
      ],
      onSaved: (String value){
        HeroineName.getState().setName(value);
      },
    );
  }
}
