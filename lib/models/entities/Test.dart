import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'Question.dart';

class Test {
  final List<Question> questions;
  int result; // number of right answers
  Test({
    this.questions,
  });

  Test copyWith({
    List<Question> questions,
  }) {
    return Test(
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questions': questions?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Test(
      questions: List<Question>.from(
          map['questions']?.map((x) => Question.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Test.fromJson(String source) => Test.fromMap(json.decode(source));

  @override
  String toString() => 'Test(questions: $questions)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Test && listEquals(o.questions, questions);
  }

  @override
  int get hashCode => questions.hashCode;
}
