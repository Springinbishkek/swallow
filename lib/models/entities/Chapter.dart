import 'dart:convert';

import 'Name.dart';

class Chapter {
  final int number;
  final int version;
  final Name title;
  final Name description;
  final double mBytes;
  final String mediaUri;
  final String noteUri;
  final String storyUri;
  Note note;
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
    this.note,
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
    Note note,
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
      note: note ?? this.note,
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
      'note': note?.toMap(),
      'story': story?.toMap(),
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Chapter(
      number: map['number'],
      version: map['version'],
      title: Name.fromMap(map['title']),
      description: Name.fromMap(map['description']),
      mBytes: map['mBytes'],
      mediaUri: map['mediaUri'],
      noteUri: map['noteUri'],
      storyUri: map['storyUri'],
      note: Note.fromMap(map['note']),
      story: Story.fromMap(map['story']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chapter(number: $number, version: $version, title: $title, description: $description, mBytes: $mBytes, mediaUri: $mediaUri, noteUri: $noteUri, storyUri: $storyUri, note: $note, story: $story)';
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
        o.note == note &&
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
        note.hashCode ^
        story.hashCode;
  }
}
