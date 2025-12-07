import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:studyvocabulary/model/question.dart';
import 'package:studyvocabulary/service/api.dart';

class QuizPage extends StatefulWidget {
  final int lessonId;

  const QuizPage({super.key, required this.lessonId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [];
  bool loading = true;

  int currentIndex = 0;
  bool answered = false;
  String? selectedAnswer;
  late List<String> shuffledAnswers;

  Future<void> loadQuestions() async {
    print(widget.lessonId);
    print('Con gà nè=====================================');
    questions = await callApi.getQuestions(widget.lessonId);
    setState(() {
      loading = false;
    });
    _shuffleCurrentQuestion();
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void _shuffleCurrentQuestion() {
    shuffledAnswers = questions[currentIndex].getShuffledAnswers();
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        answered = false;
        selectedAnswer = null;
        _shuffleCurrentQuestion();
      });
    } else {
      showDialog(
        context: context, // context của page gốc
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 192, 19),
          title: const Text(
            "Hoàn thành!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Bạn đã hoàn thành bài học!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // màu chữ
                backgroundColor: Colors.blue, // màu nền
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // bo cong
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // đóng dialog
                Navigator.of(context).pop(); // quay về trang danh sách lesson
              },
              child: const Text(
                "Đóng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }
  }

  void selectAnswer(String ans, Question question) {
    if (answered) return;

    setState(() {
      selectedAnswer = ans;
      answered = true;
    });

    Timer(const Duration(milliseconds: 500), () {
      nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final question = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Question ${currentIndex + 1}/${questions.length}"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + (answered ? 1 : 0)) / questions.length,
            ),

            const SizedBox(height: 34),

            // Căn giữa nội dung bằng Expanded
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Câu hỏi căn giữa
                  Text(
                    "Chọn đáp án đúng?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    question.questionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Danh sách đáp án cũng căn giữa
                  ...shuffledAnswers.map((ans) {
                    Color? buttonColor;
                    if (answered) {
                      if (ans == question.correctAnswer) {
                        buttonColor = const Color.fromARGB(255, 0, 255, 13);
                      } else if (ans == selectedAnswer &&
                          ans != question.correctAnswer) {
                        buttonColor = const Color.fromARGB(255, 255, 0, 0);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        onPressed: () => selectAnswer(ans, question),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor ?? Colors.orange,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: Text(
                          ans,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Nút Skip
            ElevatedButton(
              onPressed: nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 204, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 38,
                  vertical: 20,
                ),
              ),
              child: const Text("Skip"),
            ),
          ],
        ),
      ),
    );
  }
}
