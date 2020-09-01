import 'dart:convert';

import 'Name.dart';

class Story {
  final Name title;
  Story({
    this.title,
  });

  Story copyWith({
    Name title,
  }) {
    return Story(
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title?.toMap(),
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Story(
      title: Name.fromMap(map['title']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));

  @override
  String toString() => 'Story(title: $title)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Story && o.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
