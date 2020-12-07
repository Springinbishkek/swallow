import 'dart:convert';

class Photo {
  int id;
  int chapterId;
  String photoName;
  String base64;

  Photo(
    this.id,
    this.chapterId,
    this.photoName,
    this.base64,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'photoName': photoName,
      'base64': base64,
    };
  }

  Photo copyWith({
    int id,
    int chapterId,
    String photoName,
    String base64,
  }) {
    return Photo(
      id ?? this.id,
      chapterId ?? this.chapterId,
      photoName ?? this.photoName,
      base64 ?? this.base64,
    );
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Photo(
      map['id'],
      map['chapterId'],
      map['photoName'],
      map['base64'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Photo.fromJson(String source) => Photo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Photo(id: $id, chapterId: $chapterId, photoName: $photoName, base64: $base64)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Photo &&
        o.id == id &&
        o.chapterId == chapterId &&
        o.photoName == photoName &&
        o.base64 == base64;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterId.hashCode ^
        photoName.hashCode ^
        base64.hashCode;
  }
}
