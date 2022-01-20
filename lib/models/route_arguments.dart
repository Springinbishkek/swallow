import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/AnswerOption.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/Question.dart';

class ArgumentsNotePage {
  final Note note;

  ArgumentsNotePage({@required this.note});
}

class ArgumentsTestResultPage {
  final List<Question> questions;
  final List<AnswerOption> userAnswers;

  ArgumentsTestResultPage({
    @required this.questions,
    @required this.userAnswers,
  });
}
