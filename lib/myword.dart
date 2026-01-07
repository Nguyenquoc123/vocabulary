import 'package:flutter/material.dart';
import 'package:studyvocabulary/flashcards.dart';
import 'package:studyvocabulary/service/api.dart';
import 'package:studyvocabulary/model/myword.dart';

class MyWordPage extends StatefulWidget {
  final int userId;
  const MyWordPage({super.key, required this.userId});

  @override
  State<MyWordPage> createState() => _MyWordPageState();
}

class _MyWordPageState extends State<MyWordPage> {
  List<MyWord> words = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    if (!mounted) return;// đã dispose
    
    setState(() => isLoading = true);

    final data = await callApi.getMyWords(widget.userId);
    
    if (!mounted) return;
    setState(() {
      words = data;
      isLoading = false;
    });
  }

  void _showWordDialog({MyWord? word}) {
    final englishController = TextEditingController(text: word?.english ?? '');
    final meaningController = TextEditingController(text: word?.meaning ?? '');

    showDialog(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(word == null ? "Thêm từ mới" : "Chỉnh sửa từ"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: englishController,
              decoration: const InputDecoration(labelText: "Từ tiếng Anh"),
            ),
            TextField(
              controller: meaningController,
              decoration: const InputDecoration(labelText: "Nghĩa"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (englishController.text.isEmpty ||
                  meaningController.text.isEmpty)
                return;

              if (word == null) {
                await callApi.addMyWord(
                  userId: widget.userId,
                  englishWord: englishController.text,
                  meaning: meaningController.text,
                );
              } else {
                await callApi.updateMyWord(
                  mywordId: word.id,
                  userId: widget.userId,
                  englishWord: englishController.text,
                  meaning: meaningController.text,
                );
              }
              if (!mounted) {
                return;
              }
              _loadWords();
              Navigator.pop(dialog);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _deleteWord(MyWord word) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text("Xóa từ"),
        content: Text("Bạn có chắc muốn xóa \"${word.english}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (ok == true) {
      await callApi.deleteMyWord(word.id, widget.userId);
      _loadWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Từ vựng của tôi")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWordDialog(),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : words.isEmpty
          ? const Center(child: Text("Chưa có từ nào"))
          : ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      word.english,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      word.meaning,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showWordDialog(word: word),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteWord(word),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.school),
            label: const Text("Ôn tập", style: TextStyle(fontSize: 16)),
            onPressed: words.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashcardScreen(lessonId: -1, myword: true,),
                      ),
                    );
                    print("Ôn tập ${words.length} từ");
                  },
          ),
        ),
      ),
    );
  }
}
