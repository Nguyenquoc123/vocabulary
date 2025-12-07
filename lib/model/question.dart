import 'dart:math';

class Question {
  final String questionText;
  final String correctAnswer;
  final List<String> wrongAnswers;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.wrongAnswers,
  });

  List<String> getShuffledAnswers() {
    final allAnswers = [correctAnswer, ...wrongAnswers];
    allAnswers.shuffle(Random());
    return allAnswers;
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      correctAnswer: json['correctAnswer'],
      wrongAnswers: List<String>.from(json['wrongAnswers']),
    );
  }
}