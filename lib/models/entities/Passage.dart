import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/utils/extentions.dart';

import 'package:lastochki/models/entities/Choice.dart';

import 'Name.dart';

class Passage {
  final Name text;
  final String pid;
  final String name;
  final List<Choice> links;
  final List<String> tags;
  final PopupText popup;
  Passage({
    this.text,
    this.pid,
    this.name,
    this.links,
    this.tags,
    this.popup,
  });

  Passage copyWith({
    Name text,
    String pid,
    String name,
    List<Choice> links,
    List<String> tags,
  }) {
    return Passage(
      text: text ?? this.text,
      pid: pid ?? this.pid,
      name: name ?? this.name,
      links: links ?? this.links,
      tags: tags ?? this.tags,
      popup: popup ?? this.popup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text?.toMap(),
      'pid': pid,
      'name': name,
      'links': links?.map((x) => x?.toMap())?.toList(),
      'tags': tags,
      'popup': popup.toMap(),
    };
  }

  factory Passage.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Map choiceLinks = {};
    for (var item in (map['links'] ?? {})) {
      if (choiceLinks[item['pid']] == null) {
        choiceLinks[item['pid']] = item;
      } else {
        choiceLinks[item['pid']]['name'] += item['name'];
      }
    }
    var params = map['text'].split('____');
    PopupText popup;
    String nameStr = params[0];
    if (map['popup'] == null && params.length > 1) {
      // TODO
      // var popupParams = params[]
      popup = PopupText.fromMap({
        'title': {
          'ru': 'ihygnuh',
          'kg': 'ihygnuh',
        },
        'context': {
          'ru': ';;,[',
          'kg': 'ihygnuh',
        },
      });
    }

    return Passage(
      text: nameStr.toName(),
      pid: map['pid'],
      name: map['name'],
      links: List<Choice>.from(
          choiceLinks.values.map<Choice>((x) => Choice.fromMap(x))),
      tags: List<String>.from(map['tags']),
      popup: popup,
    );
  }

  String toJson() => json.encode(toMap());

  factory Passage.fromJson(String source) =>
      Passage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Passage(text: $text, pid: $pid, name: $name, links: $links, tags: $tags, popup: $popup)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Passage &&
        o.text == text &&
        o.pid == pid &&
        o.name == name &&
        listEquals(o.links, links) &&
        listEquals(o.tags, tags);
  }

  @override
  int get hashCode {
    return text.hashCode ^
        pid.hashCode ^
        name.hashCode ^
        links.hashCode ^
        tags.hashCode;
  }
}
