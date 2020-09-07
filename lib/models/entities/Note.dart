import 'dart:convert';

import 'Name.dart';
import 'Test.dart';

class Note {
  final int id;
  final int chapterNumber;
  final Name title;
  final Name text;
  final int swallow;
  final Test test;
  bool isRead;
  Note({
    this.id,
    this.chapterNumber,
    this.title,
    this.text,
    this.swallow,
    this.test,
    this.isRead,
  });

  Note copyWith({
    int id,
    int chapterNumber,
    Name title,
    Name text,
    int swallow,
    Test test,
    bool isRead,
  }) {
    return Note(
      id: id ?? this.id,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      text: text ?? this.text,
      swallow: swallow ?? this.swallow,
      test: test ?? this.test,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterNumber': chapterNumber,
      'title': title?.toMap(),
      'text': text?.toMap(),
      'swallow': swallow,
      'test': test?.toMap(),
      'isRead': isRead,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Note(
      id: map['id'],
      chapterNumber: map['chapterNumber'],
      title: Name.fromMap(map['title']),
      text: Name.fromMap(map['text']),
      swallow: map['swallow'],
      test: Test.fromMap(map['test']),
      isRead: map['isRead'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, chapterNumber: $chapterNumber, title: $title, text: $text, swallow: $swallow, test: $test, isRead: $isRead)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Note &&
        o.id == id &&
        o.chapterNumber == chapterNumber &&
        o.title == title &&
        o.text == text &&
        o.swallow == swallow &&
        o.test == test &&
        o.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterNumber.hashCode ^
        title.hashCode ^
        text.hashCode ^
        swallow.hashCode ^
        test.hashCode ^
        isRead.hashCode;
  }
}
