import 'package:dio/dio.dart';
import 'package:studyvocabulary/model/lesson.dart';
import 'package:studyvocabulary/model/question.dart';

class Api {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost/vocabulary/index.php", // đổi theo host của bạn
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  // ==========================
  // REGISTER
  // ==========================
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
    print(response.data);
    return response.data;
  }

  // ==========================
  // LOGIN
  // ==========================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      "?action=login",
      data: {"email": email, "password": password},
    );
    print(response.data);
    return response.data;
  }

  // get All lesson
  Future<List<Lesson>> getLessons() async {
    final response = await _dio.get("?action=get_lessons");

    if (response.data["status"] == true) {
      List<dynamic> data = response.data["data"];
      print(data);
      return data.map((e) => Lesson.fromJson(e)).toList();
    }

    return [];
  }

  Future<List<Question>> getQuestions(int lessonId) async {
    print('chạy thôi ' + lessonId.toString());
    final response = await _dio.get("?action=get_questions&lesson_id=$lessonId");
    print(response.data);
    if (response.data["status"] == true) {
      List<dynamic> data = response.data["questions"];
      return data.map((q) => Question.fromJson(q)).toList();
    }
    return [];
  }

}

var callApi = Api();
