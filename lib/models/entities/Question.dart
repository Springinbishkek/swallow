import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lastochki/models/entities/Name.dart';

import 'AnswerOption.dart';

class Question {
  Name question;
  List<AnswerOption> answers;
  Question({
    this.question,
    this.answers,
  });

  Question copyWith({
    Name question,
    List<AnswerOption> answers,
  }) {
    return Question(
      question: question ?? this.question,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question?.toMap(),
      'answers': answers?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Question(
      question: Name.fromMap(map['question']),
      answers: List<AnswerOption>.from(
          map['answers']?.map((x) => AnswerOption.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));

  @override
  String toString() => 'Question(question: $question, answers: $answers)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Question &&
        o.question == question &&
        listEquals(o.answers, answers);
  }

  @override
  int get hashCode => question.hashCode ^ answers.hashCode;
}
