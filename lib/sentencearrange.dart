// lib/main.dart
import 'package:flutter/material.dart';

class SentenceArrangeScreen extends StatefulWidget {
  const SentenceArrangeScreen({super.key});

  @override
  State<SentenceArrangeScreen> createState() => _SentenceArrangeScreenState();
}

class _SentenceArrangeScreenState extends State<SentenceArrangeScreen> {
  final List<String> sentences = [
    "There is a cat on the mat.",
    "She likes to drink coffee in the morning",
    "My brother plays football every weekend",
    "They are going to the supermarket",
    "Learning Flutter is fun and useful",
    "He will arrive at the station soon",
    "Please close the window before you leave",
    "I studied hard and passed the exam",
    "We enjoyed a lovely picnic by the river",
    "The sun sets beautifully over the hills",
  ];

  int currentIndex = 0;

  late List<String> words;
  late List<String> wordBank;
  late List<String?> slots;

  bool checked = false;
  bool lastCheckCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadSentence(currentIndex);
  }

  void _loadSentence(int index, {bool shuffle = true}) {
    final sentence = sentences[index];
    words = sentence.split(' ').where((w) => w.isNotEmpty).toList();
    wordBank = List<String>.from(words);
    if (shuffle) wordBank.shuffle();
    slots = List<String?>.filled(words.length, null);
    checked = false;
    lastCheckCorrect = false;
    setState(() {});
  }

  void _returnWordToBankDirect(String word) {
    setState(() {
      final idx = slots.indexOf(word);
      if (idx != -1) slots[idx] = null;
      if (!wordBank.contains(word)) wordBank.add(word);
    });
  }

  bool get _allPlaced => !slots.contains(null);

  void _checkAnswer() {
    final placed = slots.map((s) => s ?? '').toList();
    final isCorrect = _listEquals(placed, words);
    setState(() {
      checked = true;
      lastCheckCorrect = isCorrect;
    });

    if (isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 63, 223, 0),
          content: Text("Chính xác!!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _nextSentence() {
    if (currentIndex < sentences.length - 1) {
      currentIndex++;
    } else {
      currentIndex = 0;
    }
    _loadSentence(currentIndex);
  }

  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Color get primaryColor => const Color(0xFF427CF0);

  @override
  Widget build(BuildContext context) {
    final progress = ((currentIndex + 1) / sentences.length).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surfaceVariant.withOpacity(0.03),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop())
                        Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${currentIndex + 1} / ${sentences.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  color: primaryColor,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              Text(
                'Arrange the words to form a correct sentence',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              // Target sentence area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(slots.length, (index) {
                      final placed = slots[index];
                      return GestureDetector(
                        onTap: () {
                          if (placed != null) _returnWordToBankDirect(placed);
                        },
                        child: IntrinsicWidth(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 48,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            constraints: const BoxConstraints(
                              minWidth: 60, // độ rộng tối thiểu, chỉnh tuỳ ý
                            ),
                            decoration: BoxDecoration(
                              color: placed != null
                                  ? primaryColor.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: placed != null
                                    ? primaryColor.withOpacity(0.25)
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Text(
                              placed ?? '',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (checked && !lastCheckCorrect)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.yellow.shade200),
                  ),
                  child: Text(
                    'Sai rồi!! \nĐáp án:\n${words.join(' ')}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Expanded(
                child: Column(
                  children: [
                    // Word bank
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: wordBank.map((w) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  final emptyIndex = slots.indexOf(null);
                                  if (emptyIndex != -1) {
                                    slots[emptyIndex] = w;
                                    wordBank.remove(w);
                                  }
                                });
                              },
                              child: _wordPill(w),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: _allPlaced && !checked ? _checkAnswer : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allPlaced
                            ? primaryColor
                            : const Color.fromARGB(255, 212, 212, 212),
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 38,
                          vertical: 20,
                        ),
                      ),
                      child: const Text(
                        'Check Answer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: _nextSentence,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 204, 255),
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 38,
                          vertical: 20,
                        ),
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wordPill(String text, {bool hovered = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: hovered ? Colors.grey.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6),
        ],
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
