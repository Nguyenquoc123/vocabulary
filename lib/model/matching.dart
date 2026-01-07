

class Matching {
  final String word;
  final String meaning;


  Matching({
    required this.word,
    required this.meaning,
  });

  
  factory Matching.fromJson(Map<String, dynamic> json) {
    return Matching(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }

}