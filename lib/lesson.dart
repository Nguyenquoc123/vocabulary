import 'package:flutter/material.dart';
import 'package:studyvocabulary/flashcards.dart';
import 'package:studyvocabulary/listenning.dart';

import 'package:studyvocabulary/matching.dart';
import 'package:studyvocabulary/missingletter.dart';
import 'package:studyvocabulary/model/lesson.dart';
import 'package:studyvocabulary/quiz.dart';
import 'package:studyvocabulary/sentencearrange.dart';
import 'package:studyvocabulary/service/api.dart';
// giả sử bạn có file quiz_page.dart chứa QuizPage

// Mock data cho các lesson

List<Lesson> lessons = [];

class LessonSelectionPage extends StatefulWidget {
  final String initialMode;
  const LessonSelectionPage({super.key, required this.initialMode});

  @override
  State<LessonSelectionPage> createState() => _LessonSelectionPageState();
}

class _LessonSelectionPageState extends State<LessonSelectionPage> {
  late String currentMode;
  late IconData currentIcon;

  @override
  void initState() {
    super.initState();
    currentMode = widget.initialMode;
    currentIcon = Icons.quiz; // mặc định
    loadLessons();
  }

  Future<void> loadLessons() async {
    lessons = await callApi.getLessons();
    setState(() {});
  }

  final List<Map<String, dynamic>> modes = [
    {'name': 'Quiz', 'icon': Icons.quiz, 'color': Colors.blue},
    {'name': 'Flashcards', 'icon': Icons.style, 'color': Colors.teal},
    {'name': 'Match Words', 'icon': Icons.link, 'color': Colors.orange},
    {'name': 'Missing Letters', 'icon': Icons.pin, 'color': Colors.purple},
    {'name': 'Sentence Arrage', 'icon': Icons.edit_note, 'color': Colors.lime},
    {'name': 'Listening', 'icon': Icons.headphones, 'color': Colors.pink},
  ];

  void onLessonTap(Lesson lesson) {
    if (currentMode == 'Quiz') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizPage(lessonId: lesson.id,)),
      );
    } else if (currentMode == 'Flashcards') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FlashcardScreen()),
      );
    } else if (currentMode == 'Match Words') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MatchingScreen()),
      );
    } else if (currentMode == 'Missing Letters') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MissingLetterInputScreen()),
      );
    } else if (currentMode == 'Listening') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListeningScreen()),
      );
    } else if (currentMode == 'Sentence Arrage') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SentenceArrangeScreen()),
      );
    } else {
      // TODO: Thêm chuyển qua các page khác cho mode khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selected: ${lesson.title} (Mode: $currentMode) – page chưa triển khai',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$currentMode – Choose a Lesson'),
        backgroundColor: Colors.white,

        // elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return GestureDetector(
            onTap: () => onLessonTap(lesson),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      34,
                      34,
                      34,
                    ).withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(218, 34, 248, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(lesson.icon, color: const Color.fromARGB(255, 7, 143, 255)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${lesson.words} words',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '|',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                lesson.level,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Current Mode:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(currentIcon, color: Colors.blue, size: 16),

                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: currentMode,
                    underline: const SizedBox(),
                    items: modes.map((mode) {
                      return DropdownMenuItem<String>(
                        value: mode['name'],
                        child: Text(mode['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selected = modes.firstWhere(
                        (mode) => mode['name'] == value,
                      );
                      setState(() {
                        currentMode = selected['name'];
                        currentIcon = selected['icon'];
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
