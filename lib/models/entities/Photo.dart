import 'dart:convert';

class Photo {
  int id;
  int chapterId;
  String photoName;
  String imgPath;

  Photo(
    this.id,
    this.chapterId,
    this.photoName,
    this.imgPath,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'photoName': photoName,
      'imgPath': imgPath,
    };
  }

  Photo copyWith({
    int id,
    int chapterId,
    String photoName,
    String imgPath,
  }) {
    return Photo(
      id ?? this.id,
      chapterId ?? this.chapterId,
      photoName ?? this.photoName,
      imgPath ?? this.imgPath,
    );
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Photo(
      map['id'],
      map['chapterId'],
      map['photoName'],
      map['imgPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Photo.fromJson(String source) => Photo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Photo(id: $id, chapterId: $chapterId, photoName: $photoName, imgPath: $imgPath)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Photo &&
        o.id == id &&
        o.chapterId == chapterId &&
        o.photoName == photoName &&
        o.imgPath == imgPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterId.hashCode ^
        photoName.hashCode ^
        imgPath.hashCode;
  }
}
