import 'dart:convert';

import 'package:lastochki/utils/extentions.dart';

import 'Name.dart';

class Choice {
  final Name name;
  final String link;
  final String pid;
  final int swallow;
  Choice({
    this.name,
    this.link,
    this.pid,
    this.swallow,
  });

  Choice copyWith({
    Name name,
    String link,
    String pid,
    int swallow,
  }) {
    return Choice(
      name: name ?? this.name,
      link: link ?? this.link,
      pid: pid ?? this.pid,
      swallow: swallow ?? this.swallow,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name?.toMap(),
      'link': link,
      'pid': pid,
      'swallow': swallow,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var parsed = map['name'].split('|swallow:');
    // TODO
    String nameString = parsed[0];
    int swallow = parsed.length == 2 ? int.parse(parsed[1]) : 0;

    return Choice(
      name: nameString.toName(),
      link: map['link'],
      pid: map['pid'],
      swallow: swallow,
    );
  }

  String toJson() => json.encode(toMap());

  factory Choice.fromJson(String source) => Choice.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Choice(name: $name, link: $link, pid: $pid, swallow: $swallow)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Choice &&
        o.name == name &&
        o.link == link &&
        o.pid == pid &&
        o.swallow == swallow;
  }

  @override
  int get hashCode {
    return name.hashCode ^ link.hashCode ^ pid.hashCode ^ swallow.hashCode;
  }
}
