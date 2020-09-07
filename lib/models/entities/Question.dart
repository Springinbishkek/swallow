import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lastochki/models/entities/Name.dart';

import 'AnswerOption.dart';

class Question {
  Name title;
  List<AnswerOption> answers;
  Question({
    this.title,
    this.answers,
  });

  Question copyWith({
    Name question,
    List<AnswerOption> answers,
  }) {
    return Question(
      title: question ?? this.title,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': title?.toMap(),
      'answers': answers?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Question(
      title: Name.fromMap(map['question']),
      answers: List<AnswerOption>.from(
          map['answers']?.map((x) => AnswerOption.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));

  @override
  String toString() => 'Question(question: $title, answers: $answers)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Question &&
        o.title == title &&
        listEquals(o.answers, answers);
  }

  @override
  int get hashCode => title.hashCode ^ answers.hashCode;
}
