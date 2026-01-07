class ListeningQuestion {
  final String sentence;
  final String answer;
  final String meaning;

  ListeningQuestion({
    required this.sentence,
    required this.answer,
    required this.meaning,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) {
    return ListeningQuestion(
      sentence: json['sentence'] ?? '',
      answer: json['answer'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }
}
