import 'dart:convert';

import 'Name.dart';

class AnswerOption {
  final Name title;
  final bool isRight;
  AnswerOption({
    this.title,
    this.isRight,
  });

  AnswerOption copyWith({
    Name title,
    bool isRight,
  }) {
    return AnswerOption(
      title: title ?? this.title,
      isRight: isRight ?? this.isRight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title?.toMap(),
      'isRight': isRight,
    };
  }

  factory AnswerOption.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AnswerOption(
      title: Name.fromMap(map['title']),
      isRight: map['isRight'],
    );
  }

  factory AnswerOption.fromBackendMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AnswerOption(
      title: Name(ru: map['title'], kg: map['title_kg']),
      isRight: map['right'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerOption.fromJson(String source) =>
      AnswerOption.fromMap(json.decode(source));

  @override
  String toString() => 'AnswerOption(title: $title, isRight: $isRight)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AnswerOption && o.title == title && o.isRight == isRight;
  }

  @override
  int get hashCode => title.hashCode ^ isRight.hashCode;
}
