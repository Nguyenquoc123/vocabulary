import 'package:flutter/material.dart';
import 'dart:async';
import 'package:studyvocabulary/model/question.dart';
import 'package:studyvocabulary/model/user.dart';
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

  // 1. Khai báo biến lưu trữ điểm số
  int score = 0;

  Future<void> loadQuestions() async {// load câu hỏi
    questions = await callApi.getQuestions(widget.lessonId);
    setState(() {
      loading = false;
    });
    _shuffleCurrentQuestion(); // trộn đáp án
  }

  Future<void> luuDiem(int lessonId, int score) async { // lưu điểm
    final userId = await User.getUserId();
    if (userId == null) return;
    final success = await callApi.saveScore(
      userId: userId,
      lessonId: lessonId,
      score: score,
    );

    if (success) {
      print("Lưu điểm thành công");
    } else {
      print("Lưu điểm thất bại");
    }
  }

  @override
  void initState() { // chạy lần đầu
    super.initState();
    loadQuestions();
  }

  void _shuffleCurrentQuestion() { // trộn câu hỏi
    shuffledAnswers = questions[currentIndex].getShuffledAnswers();
  }

  void nextQuestion() { // qua câu hỏi tiếp theo
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        answered = false;
        selectedAnswer = null;
        _shuffleCurrentQuestion();
      });
    } else {
      luuDiem(widget.lessonId, score); // lưu điểm
      
      showDialog( // thông báo
        context: context,
        builder: (dialog) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 0, 255, 76),

          title: Icon(Icons.emoji_events, size: 60, color: Colors.white),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Hoàn thành!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Nhận được $score điểm.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(dialog).pop();
                  Navigator.of(context).pop(true);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Đóng",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void selectAnswer(String ans, Question question) {// check đáp án
    if (answered) return;// đã trả lời

    setState(() {
      selectedAnswer = ans;
      answered = true;

      // 
      if (ans == question.correctAnswer) {
        score += 10;
      }
    });

    Timer(const Duration(milliseconds: 800), () { // chờ qua câu tiếp theo
      nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) { // đang load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final question = questions[currentIndex]; 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Câu hỏi ${currentIndex + 1}/${questions.length}"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Score: $score",
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + (answered ? 1 : 0)) / questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 8,
            ),

            const SizedBox(height: 34),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Chọn đáp án đúng?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question.questionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ...shuffledAnswers.map((ans) {
                    Color? buttonColor;
                    if (answered) {
                      if (ans == question.correctAnswer) {
                        buttonColor = Colors.green;
                      } else if (ans == selectedAnswer) {
                        buttonColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        onPressed: () => selectAnswer(ans, question),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor ?? Colors.orange,
                          minimumSize: const Size.fromHeight(60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          ans,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: nextQuestion,
              child: const Text(
                "Bỏ qua câu này",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
