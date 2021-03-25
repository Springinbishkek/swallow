import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastochki/views/theme.dart';

class LTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final Function(String) onChanged;

  LTextField(this.controller, this.maxLength, this.onChanged);

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
      ),
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autofocus: false,
      autovalidateMode: AutovalidateMode.always,
      textCapitalization: TextCapitalization.words,
      inputFormatters: <TextInputFormatter>[
        // TODO check rule if langs added
        // LengthLimitingTextInputFormatter(maxLength),
        LengthLimitingTextFieldFormatterFixed(
            maxLength), //TODO cut then previous fixed
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

class LengthLimitingTextFieldFormatterFixed
    extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength != null &&
        maxLength > 0 &&
        newValue.text.characters.length > maxLength) {
      // If already at the maximum and tried to enter even more, keep the old
      // value.
      if (oldValue.text.characters.length == maxLength) {
        return oldValue;
      }
      // ignore: invalid_use_of_visible_for_testing_member
      return LengthLimitingTextInputFormatter.truncate(newValue, maxLength);
    }
    return newValue;
  }
}
