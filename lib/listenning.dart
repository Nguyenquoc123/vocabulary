import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListeningQuestion {
  final String sentence;
  final String answer;
  final String meaning;

  ListeningQuestion({required this.sentence, required this.answer, required this.meaning});
}

// Mô phỏng dữ liệu
final List<ListeningQuestion> mockQuestions = [
  ListeningQuestion(
    sentence: "Hello, how are you?",
    answer: "Hello, how are you?",
    meaning: "Xin chào, ní khỏe không!"
  ),
  ListeningQuestion(
    sentence: "I like learning Flutter.",
    answer: "I like learning Flutter.",
    meaning: "Tôi thích học Flutter."
  ),
  ListeningQuestion(
    sentence: "Flutter is awesome!",
    answer: "Flutter is awesome!",
    meaning: "Flutter là con gà!"
  ),
];

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final FlutterTts tts = FlutterTts();
  int currentIndex = 0;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    tts.stop();
    controller.dispose();
    super.dispose();
  }

  void _playAudio() async {
    await tts.stop();
    await tts.speak(mockQuestions[currentIndex].sentence);
  }

  void _checkAnswer() {
    final userInput = controller.text.trim();
    final correctAnswer = mockQuestions[currentIndex].answer.trim();

    bool isCorrect = userInput.toLowerCase() == correctAnswer.toLowerCase();

    showDialog(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Incorrect"),
        content: Text("Correct answer:\n$correctAnswer"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialog).pop();
              _nextQuestion();
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (currentIndex < mockQuestions.length - 1) {
      setState(() {
        currentIndex++;
        controller.clear();
      });
    } else {
      // Hết câu hỏi
      showDialog(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text("Completed"),
          content: const Text("You have completed all questions."),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(dialog).pop(),
                Navigator.of(context).pop(),
              },

              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Listening Practice  ${currentIndex + 1}/${mockQuestions.length}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
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
            // Nút phát âm thanh — đẹp hơn
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

            // Ô nhập — style hiện đại
            TextField(
              controller: controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Nhập đáp án...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Nút check — đẹp hơn
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
