import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';

extension NameTransform on String {
  Name toName() {
    Map<String, dynamic> name = {};
    var languagesRegex = RegExp(r"\(\w\w\)");
    var languagesMatch = languagesRegex.allMatches(this);

    int startValueIndex;
    String currentLang;
    languagesMatch.forEach((langMatch) {
      if (startValueIndex != null) {
        name[currentLang] =
            this.substring(startValueIndex, langMatch.start).trim();
      }
      currentLang = this.substring(langMatch.start + 1, langMatch.end - 1);
      startValueIndex = langMatch.end;
    });
    name[currentLang] = this.substring(startValueIndex).trim();
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
