import 'dart:convert';

import 'Name.dart';

class Note {
  final int id;
  final Name title;
  final Name text;
  final int swallow;
  Note({
    this.id,
    this.title,
    this.text,
    this.swallow,
  });
  // TODO questions

  Note copyWith({
    int id,
    Name title,
    Name text,
    int swallow,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      swallow: swallow ?? this.swallow,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title?.toMap(),
      'text': text?.toMap(),
      'swallow': swallow,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Note(
      id: map['id'],
      title: Name.fromMap(map['title']),
      text: Name.fromMap(map['text']),
      swallow: map['swallow'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, text: $text, swallow: $swallow)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Note &&
        o.id == id &&
        o.title == title &&
        o.text == text &&
        o.swallow == swallow;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ text.hashCode ^ swallow.hashCode;
  }
}
