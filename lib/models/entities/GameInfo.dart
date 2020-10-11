import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lastochki/models/entities/Passage.dart';

class GameInfo {
  int currentChapterId;
  Passage currentPassage;
  int swallowCount;
  String languageCode;
  Map<String, dynamic> gameVariables;

  String currentBg;
  GameInfo({
    this.currentChapterId = 0,
    this.currentPassage,
    this.swallowCount = 0,
    this.languageCode,
    this.gameVariables,
    this.currentBg,
  });

  GameInfo copyWith({
    int currentChapterId,
    Passage currentPassage,
    int swallowCount,
    String languageCode,
    Map<String, dynamic> gameVariables,
    String currentBg,
  }) {
    return GameInfo(
      currentChapterId: currentChapterId ?? this.currentChapterId,
      currentPassage: currentPassage ?? this.currentPassage,
      swallowCount: swallowCount ?? this.swallowCount,
      languageCode: languageCode ?? this.languageCode,
      gameVariables: gameVariables ?? this.gameVariables,
      currentBg: currentBg ?? this.currentBg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentChapterId': currentChapterId,
      'currentPassage': currentPassage?.toMap(),
      'swallowCount': swallowCount,
      'languageCode': languageCode,
      'gameVariables': gameVariables,
      'currentBg': currentBg,
    };
  }

  factory GameInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameInfo(
      currentChapterId: map['currentChapterId'],
      currentPassage: Passage.fromMap(map['currentPassage']),
      swallowCount: map['swallowCount'],
      languageCode: map['languageCode'],
      gameVariables: Map<String, dynamic>.from(map['gameVariables']),
      currentBg: map['currentBg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfo.fromJson(String source) =>
      GameInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GameInfo(currentChapterId: $currentChapterId, currentPassage: $currentPassage, swallowCount: $swallowCount, languageCode: $languageCode, gameVariables: $gameVariables, currentBg: $currentBg)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GameInfo &&
        o.currentChapterId == currentChapterId &&
        o.currentPassage == currentPassage &&
        o.swallowCount == swallowCount &&
        o.languageCode == languageCode &&
        mapEquals(o.gameVariables, gameVariables) &&
        o.currentBg == currentBg;
  }

  @override
  int get hashCode {
    return currentChapterId.hashCode ^
        currentPassage.hashCode ^
        swallowCount.hashCode ^
        languageCode.hashCode ^
        gameVariables.hashCode ^
        currentBg.hashCode;
  }
}
