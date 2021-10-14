import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lastochki/models/entities/Passage.dart';

class GameInfo {
  int currentChapterId;
  int currentDBVersion;
  int currentChapterVersion;
  String currentBgName;
  int accessNoteId;
  int numberOfTestAttempt;
  Passage currentPassage;
  int swallowCount;
  String languageCode;
  Map<String, dynamic> gameVariables;

  String currentBg;

  GameInfo({
    this.currentChapterId = 1,
    this.currentDBVersion = 0,
    this.currentChapterVersion = 0,
    this.currentBgName,
    this.accessNoteId = 0,
    this.numberOfTestAttempt = 0,
    this.currentPassage,
    this.swallowCount = 30,
    this.languageCode,
    gameVariables,
    this.currentBg,
  }) : this.gameVariables = gameVariables ?? {'Main': 'Бегайым'};

  GameInfo copyWith({
    int currentChapterId,
    int currentDBVersion,
    int currentChapterVersion,
    String currentBgName,
    int accessNoteId,
    int numberOfTestAttempt,
    Passage currentPassage,
    int swallowCount,
    String languageCode,
    Map<String, dynamic> gameVariables,
    String currentBg,
  }) {
    return GameInfo(
      currentChapterId: currentChapterId ?? this.currentChapterId,
      currentDBVersion: currentDBVersion ?? this.currentDBVersion,
      currentChapterVersion:
          currentChapterVersion ?? this.currentChapterVersion,
      currentBgName: currentBgName ?? this.currentBgName,
      accessNoteId: accessNoteId ?? this.accessNoteId,
      numberOfTestAttempt: numberOfTestAttempt ?? this.numberOfTestAttempt,
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
      'currentDBVersion': currentDBVersion,
      'currentChapterVersion': currentChapterVersion,
      'currentBgName': currentBgName,
      'accessNoteId': accessNoteId,
      'numberOfTestAttempt': numberOfTestAttempt,
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
      currentDBVersion: map['currentDBVersion'],
      currentChapterVersion: map['currentChapterVersion'],
      currentBgName: map['currentBgName'],
      accessNoteId: map['accessNoteId'],
      numberOfTestAttempt: map['numberOfTestAttempt'],
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
    return 'GameInfo(currentChapterId: $currentChapterId, currentDBVersion: $currentDBVersion, currentChapterVersion: $currentChapterVersion, currentBgName: $currentBgName, accessNoteId: $accessNoteId, numberOfTestAttempt: $numberOfTestAttempt, currentPassage: $currentPassage, swallowCount: $swallowCount, languageCode: $languageCode, gameVariables: $gameVariables, currentBg: $currentBg)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GameInfo &&
        o.currentChapterId == currentChapterId &&
        o.currentDBVersion == currentDBVersion &&
        o.currentChapterVersion == currentChapterVersion &&
        o.currentBgName == currentBgName &&
        o.accessNoteId == accessNoteId &&
        o.numberOfTestAttempt == numberOfTestAttempt &&
        o.currentPassage == currentPassage &&
        o.swallowCount == swallowCount &&
        o.languageCode == languageCode &&
        mapEquals(o.gameVariables, gameVariables) &&
        o.currentBg == currentBg;
  }

  @override
  int get hashCode {
    return currentChapterId.hashCode ^
        currentDBVersion.hashCode ^
        currentChapterVersion.hashCode ^
        currentBgName.hashCode ^
        accessNoteId.hashCode ^
        numberOfTestAttempt.hashCode ^
        currentPassage.hashCode ^
        swallowCount.hashCode ^
        languageCode.hashCode ^
        gameVariables.hashCode ^
        currentBg.hashCode;
  }
}
