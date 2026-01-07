import 'package:dio/dio.dart';
import 'package:studyvocabulary/model/Matching.dart';
import 'package:studyvocabulary/model/flashcard.dart';
import 'package:studyvocabulary/model/lesson.dart';
import 'package:studyvocabulary/model/listeningquestion.dart';
import 'package:studyvocabulary/model/myword.dart';
import 'package:studyvocabulary/model/question.dart';
import 'package:studyvocabulary/model/rank.dart';
import 'package:studyvocabulary/model/scoresummary.dart';

class Api {
  final Dio _dio = Dio(
    BaseOptions(// cấu hình mặc định
      baseUrl: "https://vocabulary.work.gd", // thêm vào phía trước mỗi request
      connectTimeout: Duration(seconds: 10),// thời gian tối đa để kết nối đến server
      receiveTimeout: Duration(seconds: 10),//thời gian tối đa để nhận phản hồi
      headers: {"Content-Type": "application/json"},// mặc định gửi json
    ),
  );

  // đăng ký tài khoản
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirm,
  }) async {
    final response = await _dio.post(
      "?action=register",
      data: {
        "full_name": fullName,
        "email": email,
        "password": password,
        "confirm": confirm,
      },
    );
    // print(response.data);
    return response.data;
  }

  //đăng nhập
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      "?action=login",
      data: {"email": email, "password": password},
    );
    // print(response.data);
    return response.data;
  }

  // get All lesson
  Future<List<Lesson>> getLessons() async {
    final response = await _dio.get("?action=get_lessons");

    if (response.data["success"] == true) {
      List<dynamic> data = response.data["data"];
      // print(data);
      return data.map((e) => Lesson.fromJson(e)).toList();
    }

    return [];
  }

  // get câu hỏi cho quiz
  Future<List<Question>> getQuestions(int lessonId) async {
    // print('chạy thôi ' + lessonId.toString());
    final response = await _dio.get(
      "?action=get_questions&lesson_id=$lessonId",
    );
    // print(response.data);
    if (response.data["success"] == true) {
      List<dynamic> data = response.data["questions"];
      return data.map((q) => Question.fromJson(q)).toList();
    }
    return [];
  }

  // get câu hỏi cho flashcard
  Future<List<FlashCard>> getFlashCards(int lessonId) async {
    final response = await _dio.get(
      "?action=get_flashcards&lesson_id=$lessonId",
    );

    if (response.data["status"] == true) {
      // print(response.data);
      List data = response.data["flashcards"];
      return data.map((e) => FlashCard.fromJson(e)).toList();
    }
    return [];
  }

  // get câu hỏi cho matchings
  Future<List<Matching>> getMatchings(int lessonId) async {
    final response = await _dio.get(
      "?action=get_matchings&lesson_id=$lessonId",
    );

    if (response.data["status"] == true) {
      // print(response.data);
      List data = response.data["matchings"];
      return data.map((e) => Matching.fromJson(e)).toList();
    }
    return [];
  }

  // get câu hỏi cho listenning
  Future<List<ListeningQuestion>> getListeningQuestions(int lessonId) async {
    final response = await _dio.get(
      "?action=get_listening_questions&lesson_id=$lessonId",
    );

    if (response.data["status"] == true) {
      List data = response.data["questions"];
      return data.map((e) => ListeningQuestion.fromJson(e)).toList();
    }

    return [];
  }

  // get lần học và điểm
  Future<ScoreSummary?> getUserScoreSummary(int userId) async {
    final response = await _dio.get(
      "?action=get_user_score_summary&user_id=$userId",
    );

    if (response.data["success"] == true) {
      return ScoreSummary.fromJson(response.data["data"]);
    }

    return null;
  }

  // lưu điểm
  Future<bool> saveScore({
    required int userId,
    required int lessonId,
    required int score,
  }) async {
    final response = await _dio.post(
      "?action=save_score",
      data: {"user_id": userId, "lesson_id": lessonId, "score": score},
    );

    return response.data["success"] == true;
  }

  // get all bảng xếp hạng
  Future<List<RankUser>> getRanking() async {
    final response = await _dio.get("?action=get_ranking");

    if (response.data["success"] == true) {
      List data = response.data["data"];
      // print(response.data);
      return data.map((e) => RankUser.fromJson(e)).toList();
    }

    return [];
  }

  // get từ của tôi
  Future<List<MyWord>> getMyWords(int userId) async {
    final response = await _dio.get("?action=get_myword&user_id=$userId");

    if (response.data["success"] == true) {
      List data = response.data["data"];
      return data.map((e) => MyWord.fromJson(e)).toList();
    }

    return [];
  }

  // get từ của tôi trong flashcard
  Future<List<FlashCard>> getMyWordFlashcards(int userId) async {
    final response = await _dio.get("?action=get_myword&user_id=$userId");

    if (response.data["success"] == true) {
      List data = response.data["data"];
      return data.map((e) => FlashCard.fromJson(e)).toList();
    }

    return [];
  }

  // thêm từ 
  Future<bool> addMyWord({
    required int userId,
    required String englishWord,
    required String meaning
  }) async {
    
    final response = await _dio.post(
      "?action=add_myword",
      data: {
        "user_id": userId,
        "english_word": englishWord,
        "meaning": meaning,
      },
    );

    return response.data["success"] == true;
  }

  // chỉnh sửa từ
  Future<bool> updateMyWord({
    required int mywordId,
    required int userId,
    required String englishWord,
    required String meaning,
    String? note,
  }) async {
    final response = await _dio.post(
      "?action=update_myword",
      data: {
        "myword_id": mywordId,
        "user_id": userId,
        "english_word": englishWord,
        "meaning": meaning,
        "note": note,
      },
    );

    return response.data["success"] == true;
  }

  // xóa từ
  Future<bool> deleteMyWord(int mywordId, int userId) async {
  final response = await _dio.post(
    "?action=delete_myword",
    data: {
      "myword_id": mywordId,
      "user_id": userId,
    },
  );

  return response.data["success"] == true;
}

}

var callApi = Api();
