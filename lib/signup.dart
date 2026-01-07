import 'package:flutter/material.dart';
import 'package:studyvocabulary/login.dart';
import 'package:studyvocabulary/service/api.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  void registerUser() async { // click đăng ký
    final result = await callApi.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirm: _confirmController.text,
    );

    if (result["success"] == true) { // thành công
      ScaffoldMessenger.of(context).showSnackBar( // thông báo
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Đăng ký thành công!",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.push( // qua trang login
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar( // thông báo lỗi
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Đăng ký thất bại! Vui lòng thử lại",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Icon
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: const Color(0x3339b2ef),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon( // icon 
                    Icons.translate,
                    size: 40,
                    color: Color(0xff39b2ef),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Đăng ký tài khoản",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                // Họ tên
                TextFormField(
                  controller: _fullNameController,
                  decoration: buildDecoration(
                    label: "Họ tên",
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập họ tên";
                    }
                    final regex = RegExp(r"^[A-Za-zÀ-ỹ\s]{2,50}$");
                    if (!regex.hasMatch(value)) {
                      return "Họ tên không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: buildDecoration(
                    label: "Email",
                    icon: Icons.mail_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  obscureText: !showPassword, // ẩn hiện ký tự
                  decoration: buildPasswordDecoration(
                    label: "Mật khẩu",
                    obscure: !showPassword,
                    onToggle: () {
                      setState(() => showPassword = !showPassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    if (value.length < 6) {
                      return "Mật khẩu phải từ 6 ký tự";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Nhập lại mật khẩu
                TextFormField(
                  controller: _confirmController,
                  obscureText: !showConfirmPassword, // ẩn hiện ký tự
                  decoration: buildPasswordDecoration(
                    label: "Nhập lại mật khẩu",
                    obscure: !showConfirmPassword,
                    onToggle: () {
                      setState(
                        () => showConfirmPassword = !showConfirmPassword,
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập lại mật khẩu";
                    }
                    if (value != _passwordController.text) {
                      return "Mật khẩu không khớp";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Button
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff39b2ef),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) { // validate dữ liệu nhập vào
                        registerUser(); // gọi hàm đăng ký
                      }
                    },
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Đã có tài khoản?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Đăng nhập",
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
    );
  }

  // ================= Decorations =================

  InputDecoration buildDecoration({// input bình thường
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  InputDecoration buildPasswordDecoration({ // input password
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade500),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade500,
        ),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
