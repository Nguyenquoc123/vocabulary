import 'package:flutter/material.dart';
import 'package:studyvocabulary/home.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/service/api.dart';
import 'package:studyvocabulary/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // 
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;

  void loginUser() async { // click login
    final result = await callApi.login(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    );

    if (result["success"] == true) { // thông tin đúng
      await User.saveUserData(
        token: result["token"],
        userId: int.parse(result["user"]["user_id"].toString()),
        fullName: result["user"]["full_name"],
        email: result["user"]["email"],
      );
      
      // qua trang home
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else { // thông tin sai
      String message = result["message"];
      ScaffoldMessenger.of(context).showSnackBar( // thông báo lỗi
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() { // giải phóng bộ nhớ
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360), // giới hạn độ rộng
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: const Color(0x3339b2ef),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon( // icon giao diện login
                      Icons.translate,
                      size: 40,
                      color: Color(0xff39b2ef),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff111618),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Đăng nhập 1 tài khoản để tiếp tục.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                  const SizedBox(height: 32),

                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff111618),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outlined),
                          hintText: "Nhập email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email không được để trống";
                          }
                          if (!RegExp(
                            r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$",
                          ).hasMatch(value)) {
                            return "Email không hợp lệ";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff111618),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword, // ẩn hiện ký tự
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          hintText: "Nhập mật khẩu",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mật khẩu không được để trống";
                          }
                          if (value.length < 6) {
                            return "Mật khẩu phải ít nhất 6 ký tự";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // xử lý login
                          loginUser();
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("Đăng nhập thành công!"),
                          //   ),
                          // );

                          // qua trang home
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xff39b2ef),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Chưa có tài khoản?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Signup()),
                          );
                        },
                        child: const Text(
                          "Đăng ký ngay",
                          style: TextStyle(
                            color: Color(0xff39b2ef),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
