import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/AnswerOption.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/Question.dart';
import 'package:lastochki/models/entities/Test.dart';

typedef TestPassFunction = Function({bool successful});

class ArgumentsNotePage {
  final Note note;
  final Function onRead;

  ArgumentsNotePage({@required this.note, @required this.onRead});
}

class ArgumentsTestPage {
  final Test test;
  final TestPassFunction onTestPassed;

  ArgumentsTestPage({@required this.test, @required this.onTestPassed});
}

class ArgumentsTestResultPage {
  final List<Question> questions;
  final List<AnswerOption> userAnswers;

  ArgumentsTestResultPage(
      {@required this.questions, @required this.userAnswers});
}
