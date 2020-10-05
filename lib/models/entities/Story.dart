import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'Name.dart';
import 'Passage.dart';

class Story {
  final Name title;
  final int chapterId;
  final List<Passage> script;
  Story({
    this.title,
    this.chapterId,
    this.script,
  });

  Story copyWith({
    Name title,
    int chapterId,
    List<Passage> script,
  }) {
    return Story(
      title: title ?? this.title,
      chapterId: chapterId ?? this.chapterId,
      script: script ?? this.script,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title?.toMap(),
      'chapterId': chapterId,
      'script': script?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    // TODO
    var title = {
      'ru': map['name'] ?? map['title'],
      'kg': map['name'] ?? map['title'],
    };

    return Story(
      title: Name.fromMap(title),
      chapterId: map['chapterId'],
      script: map['passages']?.map<Passage>((x) {
        return Passage.fromMap(x);
      })?.toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));

  @override
  String toString() =>
      'Story(title: $title, chapterId: $chapterId, script: $script)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Story &&
        o.title == title &&
        o.chapterId == chapterId &&
        listEquals(o.script, script);
  }

  @override
  int get hashCode => title.hashCode ^ chapterId.hashCode ^ script.hashCode;
}
