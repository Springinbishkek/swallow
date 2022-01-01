import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'Name.dart';
import 'Passage.dart';

class Story {
  final Name title;
  final int chapterId;
  final String firstPid;
  final Map<String, Passage> script;
  Story({
    this.title,
    this.chapterId,
    this.firstPid,
    this.script,
  });

  Story copyWith({
    Name title,
    int chapterId,
    String firstPid,
    Map<String, Passage> script,
  }) {
    return Story(
      title: title ?? this.title,
      chapterId: chapterId ?? this.chapterId,
      firstPid: firstPid ?? this.firstPid,
      script: script ?? this.script,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title?.toMap(),
      'chapterId': chapterId,
      'firstPid': firstPid,
      'script': script,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Map<String, Passage> m = {};
    map['script'].forEach((k, v) {
      m[k] = Passage.fromMap(v is String ? json.decode(v) : v);
    });

    return Story(
      title: Name.fromMap(map['title']),
      chapterId: map['chapterId'],
      firstPid: map['firstPid'],
      script: m,
    );
  }

  factory Story.fromBackendMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Map<String, Passage> m = {};
    map['script'].forEach((k, v) {
      m[k] = Passage.fromBackendMap(v);
    });

    return Story(
      title: Name.fromMap(map['title']),
      chapterId: map['chapterId'],
      firstPid: map['firstPid'],
      script: m,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Story(title: $title, chapterId: $chapterId, firstPid: $firstPid, script: $script)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Story &&
        o.title == title &&
        o.chapterId == chapterId &&
        o.firstPid == firstPid &&
        mapEquals(o.script, script);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        chapterId.hashCode ^
        firstPid.hashCode ^
        script.hashCode;
  }
}
