import 'package:flutter/material.dart';

class Lesson {
  final int id;
  final String title;
  final int words;
  final String level;
  final IconData icon;

  Lesson({
    required this.id,
    required this.title,
    required this.words,
    required this.level,

    required this.icon,
  });


  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      words: int.tryParse(json['total_words'].toString()) ?? 0,
      level: json['level_name'] ?? '',
      icon: Icons.translate,
    );
  }
}