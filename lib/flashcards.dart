import 'package:flutter/material.dart';
import 'dart:math';

class FlashCard {
  final String word;
  final String meaning;
  final String example;

  FlashCard({
    required this.word,
    required this.meaning,
    required this.example,
  });
}

final List<FlashCard> mockFlashcards = [
  FlashCard(
    word: "Ephemeral",
    meaning: "Lasting for a very short time.",
    example: "The beauty of cherry blossoms is ephemeral.",
  ),
  FlashCard(
    word: "Serendipity",
    meaning: "The occurrence of finding pleasant things by chance.",
    example: "Meeting her there was pure serendipity.",
  ),
  FlashCard(
    word: "Eloquent",
    meaning: "Fluent or persuasive speaking or writing.",
    example: "He gave an eloquent speech.",
  ),
];




class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool isFront = true;

  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _flipAnimation =
        Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  void flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  void nextCard() {
    if (currentIndex < mockFlashcards.length - 1) {
      setState(() {
        currentIndex++;
        isFront = true;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = mockFlashcards[currentIndex];
    final progressPercent = ((currentIndex + 1) / mockFlashcards.length) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text("Card ${currentIndex + 1}/${mockFlashcards.length}"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [

          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / mockFlashcards.length,
                minHeight: 6,
                color: Colors.orange,
                backgroundColor: Colors.orange.withOpacity(0.2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Flashcard
          Expanded(
            child: GestureDetector(
              onTap: flipCard,
              child: Center(
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final isBack = _flipAnimation.value > pi / 2;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_flipAnimation.value),
                      child: Container(
                        width: 280,
                        height: 380,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 10,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: isBack
                            ? _buildBack(card)
                            : _buildFront(card),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: nextCard,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close),
                        SizedBox(width: 6),
                        Text("Don't Know"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: nextCard,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 6),
                        Text("Know"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFront(FlashCard card) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(card.word,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text("Tap to see meaning",
            style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildBack(FlashCard card) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.word,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(card.meaning, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 14),
          Text(
            "\"${card.example}\"",
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
