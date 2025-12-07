import 'package:flutter/material.dart';

class MissingLetterQuestion {
  final String word;
  final List<int> missingIndexes;
  final String meaning;

  MissingLetterQuestion({
    required this.word,
    required this.missingIndexes,
    required this.meaning,
  });
}

List<MissingLetterQuestion> mockQuestions = [
  MissingLetterQuestion(
    word: "VOCABULARY",
    missingIndexes: [5],
    meaning: "A collection of words.",
  ),
  MissingLetterQuestion(
    word: "EPHEMERAL",
    missingIndexes: [2, 6],
    meaning: "Lasting for a very short time.",
  ),
  MissingLetterQuestion(
    word: "DILIGENT",
    missingIndexes: [1, 4],
    meaning: "Hard-working.",
  ),
];

class MissingLetterInputScreen extends StatefulWidget {
  const MissingLetterInputScreen({super.key});

  @override
  State<MissingLetterInputScreen> createState() =>
      _MissingLetterInputScreenState();
}

class _MissingLetterInputScreenState extends State<MissingLetterInputScreen> {
  int index = 0;
  List<String?> inputs = [];
  bool answered = false;
  bool isCorrect = false;
  // Tạo danh sách FocusNode cho mỗi ô
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    _initInputs();
  }

  bool checked = false;
  void _initInputs() {
    checked = false;
    final q = mockQuestions[index];
    inputs = List.generate(q.missingIndexes.length, (i) => null);

    // Dispose các focusNode cũ nếu cần
    for (var node in focusNodes) {
      node.dispose();
    }
    
    // Khởi tạo FocusNode mới
    focusNodes = List.generate(q.missingIndexes.length, (i) => FocusNode());

    answered = false;
    isCorrect = false;

    // Tự focus ô đầu tiên khi hiển thị
    Future.delayed(Duration.zero, () {
      if (focusNodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(focusNodes[0]);
      }
    });
  }

  @override
  void dispose() {
    // Dispose hết các FocusNode
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _checkAnswer() {
    checked = true;
    final q = mockQuestions[index];

    bool correct = true;
    for (int i = 0; i < q.missingIndexes.length; i++) {
      String correctChar = q.word[q.missingIndexes[i]];
      // nếu người dùng không nhập gì -> xem như sai
      if (inputs[i] == null ||
          inputs[i]!.isEmpty ||
          inputs[i]!.toUpperCase() != correctChar.toUpperCase()) {
        correct = false;
      }
    }

    setState(() {
      answered = true;
      isCorrect = correct;
    });

    // Auto next sau 1s
    Future.delayed(const Duration(seconds: 1), () {
      if (index < mockQuestions.length - 1) {
        setState(() {
          index++;
        });
        _initInputs();
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = mockQuestions[index];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Question ${index + 1}/${mockQuestions.length}"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (index + 1) / mockQuestions.length,
              backgroundColor: Colors.grey.shade300,
              color: Colors.red,
              minHeight: 6,
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // <--- căn giữa theo trục chính
                crossAxisAlignment: CrossAxisAlignment.center, //

                children: [
                  Text(
                    "Điền ký tự còn thiếu cho đúng!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    q.meaning,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    children: List.generate(q.word.length, (i) {
                      if (q.missingIndexes.contains(i)) {
                        int missingPos = q.missingIndexes.indexOf(i);

                        Color border = Colors.grey.shade400;
                        Color bg = Colors.white;

                        if (answered) {
                          if (isCorrect) {
                            bg = Colors.green.shade100;
                            border = Colors.green;
                          } else {
                            bg = Colors.red.shade100;
                            border = Colors.red;
                          }
                        }

                        return Container(
                          width: 55,
                          height: 55,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          child: TextField(
                            focusNode: focusNodes[missingPos],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                            onChanged: (v) {
                              inputs[missingPos] = v.toLowerCase();

                              if (v.length == 1 &&
                                  missingPos < focusNodes.length - 1) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[missingPos + 1]);
                              }

                              if (missingPos == focusNodes.length - 1 &&
                                  v.length == 1) {
                                focusNodes[missingPos].unfocus();
                              }
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: bg,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          q.word[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: !checked? _checkAnswer : null,
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                if (index < mockQuestions.length - 1) {
                  setState(() => index++);
                  _initInputs();
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 204, 255),
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
