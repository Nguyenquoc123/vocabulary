import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Model và mock data
class MatchItem {
  final String word;
  final String meaning;

  MatchItem({
    required this.word,
    required this.meaning,
  });
}

final List<MatchItem> mockMatchList = [
  MatchItem(word: "Ephemeral", meaning: "Lasting for a very short time"),
  MatchItem(word: "Ubiquitous", meaning: "Present, appearing, or found everywhere"),
  MatchItem(word: "Mellifluous", meaning: "Pleasant to hear"),
  MatchItem(word: "Pulchritudinous", meaning: "Having great physical beauty"),
  MatchItem(word: "Ebullient", meaning: "Cheerful and full of energy"),
  MatchItem(word: "Ineffable", meaning: "Too great to be expressed in words"),
  MatchItem(word: "Ephemeral", meaning: "Lasting for a very short time"),
  MatchItem(word: "Ubiquitous", meaning: "Present, appearing, or found everywhere"),
  MatchItem(word: "Mellifluous", meaning: "Pleasant to hear"),
  MatchItem(word: "Pulchritudinous", meaning: "Having great physical beauty"),
  MatchItem(word: "Ebullient", meaning: "Cheerful and full of energy"),
  MatchItem(word: "Ineffable", meaning: "Too great to be expressed in words")
];

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  List<Map<String, dynamic>> gridItems = [];
  int? firstSelectedIndex;
  bool _isProcessing = false;
  Timer? _resetTimer;

  // =============================
  // Round logic
  // =============================
  int round = 0;
  final int pairsPerRound = 4;

  List<MatchItem> getCurrentRoundItems() {
    int start = round * pairsPerRound;
    int end = min(start + pairsPerRound, mockMatchList.length);
    return mockMatchList.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    setupGrid();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  // =============================
  // Setup round grid (4 cặp)
  // =============================
  void setupGrid() {
    final List<Map<String, dynamic>> temp = [];

    for (var item in getCurrentRoundItems()) {
      temp.add({"text": item.word, "pair": item.meaning, "type": "word"});
      temp.add({"text": item.meaning, "pair": item.word, "type": "meaning"});
    }

    temp.shuffle(Random());

    gridItems = temp.map((e) => {
          "text": e["text"],
          "pair": e["pair"],
          "type": e["type"],
          "state": "default",
        }).toList();

    firstSelectedIndex = null;
    _isProcessing = false;
    _resetTimer?.cancel();
    setState(() {});
  }

  // =============================
  // Card tap logic
  // =============================
  void onCardTap(int index) {
    if (_isProcessing) return;
    if (gridItems[index]["state"] == "correct") return;

    setState(() {
      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
        gridItems[index]["state"] = "selected";
        return;
      }

      if (firstSelectedIndex == index) {
        gridItems[index]["state"] = "default";
        firstSelectedIndex = null;
        return;
      }

      final first = gridItems[firstSelectedIndex!];
      final second = gridItems[index];

      // cùng loại (word-word hoặc meaning-meaning)
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
      } else {
        gridItems[firstSelectedIndex!]["state"] = "wrong";
        gridItems[index]["state"] = "wrong";
        _startResetForPair(firstSelectedIndex!, index);
      }
    });
  }

  void _startResetForPair(int a, int b) {
    _resetTimer?.cancel();
    _isProcessing = true;

    _resetTimer = Timer(const Duration(milliseconds: 650), () {
      setState(() {
        if (gridItems[a]["state"] != "correct") gridItems[a]["state"] = "default";
        if (gridItems[b]["state"] != "correct") gridItems[b]["state"] = "default";
        _isProcessing = false;
        firstSelectedIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final int correctCount =
        gridItems.where((e) => e["state"] == "correct").length ~/ 2;
    final int totalPairs = getCurrentRoundItems().length;
    final double progress = totalPairs == 0 ? 0 : correctCount / totalPairs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Matching – Round ${round + 1}",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
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
              onPressed: correctCount == totalPairs ? () {
                int nextStart = (round + 1) * pairsPerRound;

                if (nextStart < mockMatchList.length) {
                  // còn cặp → sang round mới
                  print("con gà");
                  setState(() {
                    round++;
                  });
                  setupGrid();
                } else {
                  // hết → thoát
                  Navigator.pop(context);
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                disabledBackgroundColor: const Color.fromARGB(255, 135, 227, 255).withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // Card UI builder
  // =============================
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
            fontWeight:
                item["type"] == "meaning" ? FontWeight.w500 : FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
