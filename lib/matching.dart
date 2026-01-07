import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:studyvocabulary/model/Matching.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/service/api.dart';

// Model và mock data

class MatchingScreen extends StatefulWidget {
  final int lessonId;
  const MatchingScreen({super.key, required this.lessonId});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  List<Map<String, dynamic>> gridItems = [];
  List<Matching> mockMatchList = [];
  int? firstSelectedIndex;
  bool _isProcessing = false;
  Timer? _resetTimer;
  bool loading = true;
  int score = 0;

  int round = 0;
  final int pairsPerRound = 4;

  Future<void> _loadMatchings() async {// load ds câu hỏi
    mockMatchList = await callApi.getMatchings(widget.lessonId);
    setState(() => loading = false);
    setupGrid();
  }

  List<Matching> getCurrentRoundItems() {// lấy ds câu hỏi trong 1 round
    int start = round * pairsPerRound;
    int end = min(start + pairsPerRound, mockMatchList.length);
    return mockMatchList.sublist(start, end);
  }

  Future<void> luuDiem(int lessonId, int score) async {
    final userId = await User.getUserId();
    print("start save score");
    if (userId == null) return;
    print("start save score 2");
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
  void initState() {// chạy lần đầu
    super.initState();
    _loadMatchings();
  }

  @override
  void dispose() {// giải phòng bộ nhớ
    _resetTimer?.cancel();
    super.dispose();
  }

  
  void setupGrid() {// tạo cặp từ
    final List<Map<String, dynamic>> temp = [];

    for (var item in getCurrentRoundItems()) {
      temp.add({"text": item.word, "pair": item.meaning, "type": "word"});
      temp.add({"text": item.meaning, "pair": item.word, "type": "meaning"});
    }

    temp.shuffle(Random());

    gridItems = temp
        .map(
          (e) => {
            "text": e["text"],
            "pair": e["pair"],
            "type": e["type"],
            "state": "default",
          },
        )
        .toList();

    firstSelectedIndex = null;
    _isProcessing = false;
    _resetTimer?.cancel();
    setState(() {});
  }

  
  void onCardTap(int index) {
    if (_isProcessing) return;// đang reset
    if (gridItems[index]["state"] == "correct") return;// đã trả lời đứng

    setState(() {
      if (firstSelectedIndex == null) {// chọn thẻ đầu tiên
        firstSelectedIndex = index;
        gridItems[index]["state"] = "selected";
        return;
      }

      if (firstSelectedIndex == index) {// chọn lại thẻ đầu tiên
        gridItems[index]["state"] = "default";
        firstSelectedIndex = null;
        return;
      }

      final first = gridItems[firstSelectedIndex!];// thẻ thứ nhất
      final second = gridItems[index];// thẻ thứ 2

      // cùng loại 
      if (first["type"] == second["type"]) {
        gridItems[firstSelectedIndex!]["state"] = "wrong";
        gridItems[index]["state"] = "wrong";
        _startResetForPair(firstSelectedIndex!, index);
        return;
      }

      // check đúng/sai
      if (first["pair"] == second["text"]) {
        gridItems[firstSelectedIndex!]["state"] = "correct";
        gridItems[index]["state"] = "correct";
        firstSelectedIndex = null;
        score += 10;
      } else {
        gridItems[firstSelectedIndex!]["state"] = "wrong";
        gridItems[index]["state"] = "wrong";
        _startResetForPair(firstSelectedIndex!, index);
        score = score - 5 < 0 ? 0 : score - 5;
      }
    });
  }

  void _startResetForPair(int a, int b) {
    _resetTimer?.cancel();
    _isProcessing = true;

    _resetTimer = Timer(const Duration(milliseconds: 650), () {
      setState(() {
        if (gridItems[a]["state"] != "correct")
          gridItems[a]["state"] = "default";
        if (gridItems[b]["state"] != "correct")
          gridItems[b]["state"] = "default";
        _isProcessing = false;
        firstSelectedIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {// đang load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final int correctCount =
        gridItems.where((e) => e["state"] == "correct").length ~/ 2;
    final int totalPairs = getCurrentRoundItems().length;
    final double progress = totalPairs == 0 ? 0 : correctCount / totalPairs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        
        title: Text(
          "Round ${round + 1}",
          style: const TextStyle(color: Colors.black),
        ),
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

      body: Column(
        children: [
          // Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: Colors.purple,
                backgroundColor: Colors.purple.withOpacity(0.2),
              ),
            ),
          ),

          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: gridItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(// chia theo số cột cố định
                  crossAxisCount: 2,//2 cột
                  mainAxisSpacing: 14, // khoảng cách dòng
                  crossAxisSpacing: 14,// khoảng cách cột
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) => _buildCard(index),
              ),
            ),
          ),

          // Bottom button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: ElevatedButton(
              onPressed: correctCount == totalPairs
                  ? () {
                      int nextStart = (round + 1) * pairsPerRound;

                      if (nextStart < mockMatchList.length) {
                        
                        
                        setState(() {
                          round++;
                        });
                        setupGrid();
                      } else {
                        // hết
                        luuDiem(widget.lessonId, score);
                        showDialog(
                          context: context,
                          builder: (dialog) => AlertDialog(
                            backgroundColor: const Color.fromARGB(
                              255,
                              0,
                              255,
                              76,
                            ),

                            title: Icon(
                              Icons.emoji_events,
                              size: 60,
                              color: Colors.white,
                            ),
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
                        // Navigator.pop(context);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                disabledBackgroundColor: const Color.fromARGB(
                  255,
                  135,
                  227,
                  255,
                ).withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Tiếp",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildCard(int index) {
    final item = gridItems[index];
    final state = item["state"];

    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    if (state == "selected") {
      borderColor = Colors.purple;
    } else if (state == "correct") {
      borderColor = Colors.green;
      bgColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green.shade700;
    } else if (state == "wrong") {
      borderColor = Colors.red;
      bgColor = Colors.red.withOpacity(0.05);
      textColor = Colors.red.shade800;
    }

    return GestureDetector(
      onTap: () => onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          color: bgColor,
          boxShadow: [
            if (state != "correct")
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          item["text"],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: item["type"] == "meaning"
                ? FontWeight.w500
                : FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
