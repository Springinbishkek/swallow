import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' show parse;

import 'package:lastochki/models/entities/Choice.dart';
import 'package:lastochki/models/entities/PopupText.dart';
import 'package:lastochki/utils/extentions.dart';

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
    PopupText popup,
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
      'popup': popup?.toMap(),
    };
  }

  static String getText(String tag, doc) {
    var nodes = doc.getElementsByTagName(tag);
    if (nodes.length > 0) {
      return nodes[0].innerHtml;
    }
    return '';
  }

  factory Passage.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Passage(
      text: Name.fromMap(map['text']),
      pid: map['pid'],
      name: map['name'],
      links: List<Choice>.from(map['links']?.map((x) => Choice.fromMap(x))),
      tags: List<String>.from(map['tags']),
      popup: PopupText.fromMap(map['popup']),
    );
  }

  factory Passage.fromBackendMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Map choiceLinks = {};
    for (var item in (map['links'] ?? {})) {
      if (choiceLinks[item['pid']] == null) {
        choiceLinks[item['pid']] = item;
        var parsed = item['name'].split('|swallow:');
        choiceLinks[item['pid']]['name'] = parsed[0];
        choiceLinks[item['pid']]['swallow'] =
            (parsed.length > 1) ? int.parse(parsed[1]) : 0;
      } else {
        var parsed = item['name'].split('|swallow:');
        choiceLinks[item['pid']]['name'] += parsed[0];
      }
    }
    var params = map['text'].split('____');
    PopupText popup;
    String nameStr = params[0];
    print(map['pid']);
    if (map['popup'] == null && params.length > 1 && params[1] != '') {
      var document = parse(params[1]);
      var ruTitle = getText('TitleRu', document);
      var ruText = getText('TextRu', document);
      var kgTitle = getText('TitleKg', document);
      var kgText = getText('TextKg', document);

      popup = PopupText.fromMap({
        'title': {
          'ru': ruTitle,
          'kg': kgTitle,
        },
        'content': {
          'ru': ruText,
          'kg': kgText,
        },
      });
    }

    return Passage(
      text: nameStr.toName(),
      pid: map['pid'],
      name: map['name'],
      links: List<Choice>.from(
          choiceLinks.values.map<Choice>((x) => Choice.fromBackendMap(x))),
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
        listEquals(o.tags, tags) &&
        o.popup == popup;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        pid.hashCode ^
        name.hashCode ^
        links.hashCode ^
        tags.hashCode ^
        popup.hashCode;
  }
}
