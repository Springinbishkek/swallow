import 'dart:convert';

import 'Name.dart';
import 'Story.dart';

class Chapter {
  final int number;
  final int version;
  final Name title;
  final Name description;
  final double mBytes;
  final String mediaUri;
  final String noteUri;
  final String storyUri;
  Story story;
  Chapter({
    this.number,
    this.version,
    this.title,
    this.description,
    this.mBytes,
    this.mediaUri,
    this.noteUri,
    this.storyUri,
    this.story,
  });

  Chapter copyWith({
    int number,
    int version,
    Name title,
    Name description,
    double mBytes,
    String mediaUri,
    String noteUri,
    String storyUri,
    Story story,
  }) {
    return Chapter(
      number: number ?? this.number,
      version: version ?? this.version,
      title: title ?? this.title,
      description: description ?? this.description,
      mBytes: mBytes ?? this.mBytes,
      mediaUri: mediaUri ?? this.mediaUri,
      noteUri: noteUri ?? this.noteUri,
      storyUri: storyUri ?? this.storyUri,
      story: story ?? this.story,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'version': version,
      'title': title?.toMap(),
      'description': description?.toMap(),
      'mBytes': mBytes,
      'mediaUri': mediaUri,
      'noteUri': noteUri,
      'storyUri': storyUri,
      'story': story?.toMap(),
    };
  }

  static Map<String, dynamic> getPrepared(Map m) {
    Map<String, dynamic> map = Map.from(m);
    if (map['title_kg'].runtimeType == String) {
      map['title'] = {
        'ru': m['title'],
        'kg': m['title_kg'],
      };
    }
    if (map['description_kg'].runtimeType == String) {
      map['description'] = {
        'ru': m['description'],
        'kg': m['description_kg'],
      };
    }
    return map;
  }

  static Chapter fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    map = getPrepared(map);

    return Chapter(
      number: map['number'],
      version: map['version'],
      title: Name.fromMap(map['title']),
      description: Name.fromMap(map['description']),
      mBytes: double.parse(map['mBytes'].toString()),
      mediaUri: map['uri'],
      noteUri: map['note_uri'],
      storyUri: map['story_uri'],
      story: Story.fromMap(map['story']),
    );
  }

  String toJson() => json.encode(toMap());

  Chapter fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chapter(number: $number, version: $version, title: $title, description: $description, mBytes: $mBytes, mediaUri: $mediaUri, noteUri: $noteUri, storyUri: $storyUri, story: $story)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Chapter &&
        o.number == number &&
        o.version == version &&
        o.title == title &&
        o.description == description &&
        o.mBytes == mBytes &&
        o.mediaUri == mediaUri &&
        o.noteUri == noteUri &&
        o.storyUri == storyUri &&
        o.story == story;
  }

  @override
  int get hashCode {
    return number.hashCode ^
        version.hashCode ^
        title.hashCode ^
        description.hashCode ^
        mBytes.hashCode ^
        mediaUri.hashCode ^
        noteUri.hashCode ^
        storyUri.hashCode ^
        story.hashCode;
  }
}
