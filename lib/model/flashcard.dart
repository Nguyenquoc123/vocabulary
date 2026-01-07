import 'dart:math';

class FlashCard {
  final String word;
  final String meaning;


  FlashCard({
    required this.word,
    required this.meaning,
  });

  // Chuyển đổi từ Map (JSON) sang đối tượng FlashCard
  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }

}