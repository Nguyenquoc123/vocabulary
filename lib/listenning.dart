import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:studyvocabulary/model/listeningquestion.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/service/api.dart';

// Mô phỏng dữ liệu

class ListeningScreen extends StatefulWidget {
  final int lessonId;
  const ListeningScreen({super.key, required this.lessonId});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final FlutterTts tts = FlutterTts();
  int currentIndex = 0;
  final TextEditingController controller = TextEditingController();
  List<ListeningQuestion> mockQuestions = [];
  bool loading = true;
  int score = 0;

  Future<void> _loadListennings() async {
    //load câu hỏi
    mockQuestions = await callApi.getListeningQuestions(widget.lessonId);
    setState(() => loading = false);
  }

  Future<void> luuDiem(int lessonId, int score) async {
    // lưu điểm
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
  void initState() {
    // chạy lần đầu
    super.initState();
    _loadListennings();
  }

  @override
  void dispose() {
    // xóa bộ nhớ
    tts.stop();
    controller.dispose();
    super.dispose();
  }

  void _playAudio() async {
    //phát âm thanh
    await tts.stop(); // dừng âm thanh đang phát
    await tts.speak(mockQuestions[currentIndex].sentence); // phát
  }

  void _checkAnswer() {
    // check đáp án
    final userInput = controller.text.trim(); // người dùng trả lời
    final correctAnswer = mockQuestions[currentIndex].answer
        .trim(); // đáp án đúng

    bool isCorrect =
        userInput.toLowerCase() == correctAnswer.toLowerCase(); // true or false
    if (isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 0, 255, 8),
          content: Text("Chính xác!", style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      score += 10;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          content: Text(
            "Sai rồi! $correctAnswer mới đúng.",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    // câu hỏi tiếp theo
    if (currentIndex < mockQuestions.length - 1) {
      setState(() {
        currentIndex++;
        controller.clear();
      });
    } else {
      // Hết câu hỏi
      luuDiem(widget.lessonId, score);
      showDialog(
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      // đang load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "${currentIndex + 1}/${mockQuestions.length}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              "Nghe và viết lại!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            Text(
              mockQuestions[currentIndex].meaning,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            // Nút phát âm thanh
            GestureDetector(
              onTap: _playAudio,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade500, Colors.green.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.volume_up_rounded,
                  size: 68,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              "Nhấn để nghe!",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 50),

            // Ô nhập
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Nhập đáp án...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Nút check
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color.fromARGB(255, 57, 199, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Check Answer",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                if (currentIndex < mockQuestions.length - 1) {
                  // setState(() => currentIndex++);
                  _nextQuestion();
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
