import 'dart:convert';

import 'Name.dart';

class Choice {
  final Name name;
  final String link;
  final String pid;
  Choice({
    this.name,
    this.link,
    this.pid,
  });

  Choice copyWith({
    Name name,
    String link,
    String pid,
  }) {
    return Choice(
      name: name ?? this.name,
      link: link ?? this.link,
      pid: pid ?? this.pid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name?.toMap(),
      'link': link,
      'pid': pid,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    // TODO use common translation
    Map<String, dynamic> name = {};
    String nameStr = map['name'];
    List langs = nameStr.split("(");
    langs.removeAt(0);
    langs.forEach((element) {
      List value = element.split(")");
      name[value[0]] = value[1];
    });
    return Choice(
      name: Name.fromMap(name),
      link: map['link'],
      pid: map['pid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Choice.fromJson(String source) => Choice.fromMap(json.decode(source));

  @override
  String toString() => 'Choice(name: $name, link: $link, pid: $pid)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Choice && o.name == name && o.link == link && o.pid == pid;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode ^ pid.hashCode;
}
