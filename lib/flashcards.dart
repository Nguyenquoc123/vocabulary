import 'dart:math';
import 'package:flutter/material.dart';
import 'package:studyvocabulary/model/flashcard.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/service/api.dart';

class FlashcardScreen extends StatefulWidget {
  final int lessonId;
  final bool myword;
  const FlashcardScreen({super.key, required this.lessonId, required this.myword});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {

  int currentIndex = 0;
  bool isFront = true;
  bool loading = true;

  List<FlashCard> flashcards = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() { // chạy lần đầu
    super.initState();

    _controller = AnimationController( // quản lý chạy hiệu ứng
      vsync: this,
      duration: const Duration(milliseconds: 300), // trong 300mili
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(_controller); // xoay 180

    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async { // load ds từ
    if(widget.myword){ // nếu là từ của tôi
      final userId = await User.getUserId();
      flashcards = await callApi.getMyWordFlashcards(userId!);
    }
    else{ // bài có sẵn
      flashcards = await callApi.getFlashCards(widget.lessonId);
    }
    setState(() => loading = false);
  }

  void _flipCard() {
    if (_controller.isAnimating) return; // hiệu ứng đang chạy

    isFront ? _controller.forward() : _controller.reverse();
    setState(() => isFront = !isFront);
  }

  void _nextCard() {// từ tiếp theo
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        isFront = true;
        _controller.reset();
      });
    } else { // hết từ
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {// đang load
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (flashcards.isEmpty) { // ko có từ nào
      return const Scaffold(
        body: Center(child: Text("Bài học chưa có flashcard")),
      );
    }

    final card = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("${currentIndex + 1}/${flashcards.length}"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / flashcards.length,
            ),
          ),

          Expanded(
            child: GestureDetector(// có thể nhấn như button
              onTap: _flipCard,
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (_, __) {
                    final isBack = _animation.value > pi / 2;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        // ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value),
                      child: _buildCard(isBack ? _back(card) : _front(card)),
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity, // Làm cho nút dài hết chiều ngang
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _nextCard,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hiển thị chữ "Finish" nếu là thẻ cuối cùng
                    Text(
                      currentIndex < flashcards.length - 1 
                        ? "Next" 
                        : "Finish",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      width: 280,
      height: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Colors.black12),
        ],
      ),
      child: child,
    );
  }

  Widget _front(FlashCard card) {// mặt trước
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          card.word,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text("Nhấn để xem nghĩa"),
      ],
    );
  }

  Widget _back(FlashCard card) {// mặt sau
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.word,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            card.meaning,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
