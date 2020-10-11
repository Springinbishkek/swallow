import 'dart:convert';

import 'Name.dart';

class PopupText {
  final Name title;
  final Name content;

  PopupText({
    this.title,
    this.content,
  });

  PopupText copyWith({
    Name title,
    Name content,
  }) {
    return PopupText(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title?.toMap(),
      'content': content?.toMap(),
    };
  }

  factory PopupText.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PopupText(
      title: Name.fromMap(map['title']),
      content: Name.fromMap(map['content']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PopupText.fromJson(String source) =>
      PopupText.fromMap(json.decode(source));

  @override
  String toString() => 'PopupText(title: $title, content: $content)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PopupText && o.title == title && o.content == content;
  }

  @override
  int get hashCode => title.hashCode ^ content.hashCode;
}
