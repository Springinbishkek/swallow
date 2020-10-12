import 'dart:convert';

import 'Name.dart';
import 'Question.dart';

class Note {
  final int id;
  final int chapterNumber;
  final Name title;
  final Name text;
  final int swallow;
  final List<Question> questions;
  bool isRead;
  Note({
    this.id,
    this.chapterNumber,
    this.title,
    this.text,
    this.swallow,
    this.questions,
    this.isRead,
  });

  Note copyWith({
    int id,
    int chapterNumber,
    Name title,
    Name text,
    int swallow,
    List<Question> questions,
    bool isRead,
  }) {
    return Note(
      id: id ?? this.id,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      text: text ?? this.text,
      swallow: swallow ?? this.swallow,
      questions: questions ?? this.questions,
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
      'questions': questions?.map((x) => x?.toMap())?.toList(),
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
      questions: List<Question>.from(
          map['questions']?.map((x) => Question.fromMap(x))),
      isRead: map['isRead'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, chapterNumber: $chapterNumber, title: $title, text: $text, swallow: $swallow, questions: $questions, isRead: $isRead)';
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
        o.questions == questions &&
        o.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterNumber.hashCode ^
        title.hashCode ^
        text.hashCode ^
        swallow.hashCode ^
        questions.hashCode ^
        isRead.hashCode;
  }
}
