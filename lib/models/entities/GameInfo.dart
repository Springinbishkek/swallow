import 'dart:convert';

import 'package:flutter/foundation.dart';

class GameInfo {
  int currentChapterId;
  String currentStep;
  int swallowCount;
  String languageCode;
  Map<String, dynamic> gameVariables;
  GameInfo({
    this.currentChapterId = 0,
    this.currentStep = '',
    this.swallowCount = 0,
    this.languageCode,
    this.gameVariables,
  });

  GameInfo copyWith({
    int currentChapterId,
    String currentStep,
    int swallowCount,
    String languageCode,
    Map<String, dynamic> gameVariables,
  }) {
    return GameInfo(
      currentChapterId: currentChapterId ?? this.currentChapterId,
      currentStep: currentStep ?? this.currentStep,
      swallowCount: swallowCount ?? this.swallowCount,
      languageCode: languageCode ?? this.languageCode,
      gameVariables: gameVariables ?? this.gameVariables,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentChapterId': currentChapterId,
      'currentStep': currentStep,
      'swallowCount': swallowCount,
      'languageCode': languageCode,
      'gameVariables': gameVariables,
    };
  }

  factory GameInfo.fromMap(Map<String, dynamic> map) {
    // default info
    if (map == null) return null;

    return GameInfo(
      currentChapterId: map['currentChapterId'],
      currentStep: map['currentStep'],
      swallowCount: map['swallowCount'],
      languageCode: map['languageCode'],
      gameVariables: Map<String, dynamic>.from(map['gameVariables']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfo.fromJson(String source) =>
      GameInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GameInfo(currentChapterId: $currentChapterId, currentStep: $currentStep, swallowCount: $swallowCount, languageCode: $languageCode, gameVariables: $gameVariables)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GameInfo &&
        o.currentChapterId == currentChapterId &&
        o.currentStep == currentStep &&
        o.swallowCount == swallowCount &&
        o.languageCode == languageCode &&
        mapEquals(o.gameVariables, gameVariables);
  }

  @override
  int get hashCode {
    return currentChapterId.hashCode ^
        currentStep.hashCode ^
        swallowCount.hashCode ^
        languageCode.hashCode ^
        gameVariables.hashCode;
  }
}
