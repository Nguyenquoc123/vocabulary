class MyWord {
  final int id;
  final String english;
  final String meaning;

  MyWord({
    required this.id,
    required this.english,
    required this.meaning,
  });

  factory MyWord.fromJson(Map<String, dynamic> json) {
  return MyWord(
    id: int.parse(json['myword_id'].toString()),
    english: json['word'],
    meaning: json['meaning'],
  );
}

}
