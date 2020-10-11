import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';

extension NameTransform on String {
  Name toName() {
    Map<String, dynamic> name = {};
    var r = RegExp(r"\(\w\w\)");
    var matches = r.allMatches(this);
    int startValueIndex;
    String lang;
    matches.forEach((el) {
      if (startValueIndex != null) {
        String value = this.substring(startValueIndex, el.start);
        name[lang] = value;
      }
      lang = this.substring(el.start + 1, el.end - 1);
      startValueIndex = el.end;
    });
    name[lang] = this.substring(startValueIndex);

    return Name.fromMap(name);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
