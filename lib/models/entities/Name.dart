import 'dart:convert';

import 'package:flutter/material.dart';

class Name {
  static Locale curLocale = Locale('ru');
  final String ru;
  final String kg;

  Name({
    this.ru,
    this.kg,
  });

  Name copyWith({
    String ru,
    String kg,
  }) {
    return Name(
      ru: ru ?? this.ru,
      kg: kg ?? this.kg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ru': ru,
      'kg': kg,
    };
  }

  static Name fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Name(
      ru: map['ru'],
      kg: map['kg'],
    );
  }

  String toJson() => json.encode(toMap());

  static void setLocale(Locale l) {
    curLocale = l;
  }

  static Name fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    switch (curLocale.languageCode) {
      case 'kg':
        return kg;
      default:
        return ru;
    }
  }

  String toStringWithVar({Map<String, dynamic> variables}) {
    String text = toString();
    variables.forEach((key, value) {
      text = text.replaceAll('@$key', value.toString());
    });
    return text;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Name && o.ru == ru && o.kg == kg;
  }

  @override
  int get hashCode => ru.hashCode ^ kg.hashCode;
}
