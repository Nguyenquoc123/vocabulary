import 'package:flutter/material.dart';
import 'package:studyvocabulary/home.dart';
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

  void registerUser() async {
    final result = await callApi.register(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirm: _confirmController.text,
    );

    if (result["status"] == true) {
      print("Đăng ký thành công");
      // qua trang home
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      print("Lỗi: ${result["message"]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: const Color(0x3339b2ef),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.translate,
                    size: 40,
                    color: Color(0xff39b2ef),
                  ),
                ),

                // Title
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Đăng ký tài khoản",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                // name
                buildInputLabel("Họ tên"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _fullNameController,
                  decoration: buildDecoration(
                    hint: "Nhập họ tên",
                    icon: Icons.mail_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập họ tên";
                    }
                    final nameRegex = RegExp(r"^[A-Za-zÀ-ỹ\s]{2,50}$");
                    if (!nameRegex.hasMatch(value)) {
                      return "Họ tên không hợp lệ";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 18),
                // Email
                buildInputLabel("Email"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  decoration: buildDecoration(
                    hint: "Nhập email",
                    icon: Icons.mail_outlined,
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

                // Password
                buildInputLabel("Mật khẩu"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !showPassword,
                  decoration: buildPasswordDecoration(
                    hint: "Nhập mật khẩu",
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

                const SizedBox(height: 24),

                // Confirm Password
                buildInputLabel("Nhập lại mật khẩu"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmController,
                  obscureText: !showConfirmPassword,
                  decoration: buildPasswordDecoration(
                    hint: "Nhập lại mật khẩu",
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

                // Create Account
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
                      if (_formKey.currentState!.validate()) {
                        // TODO: handle signup logic
                        print("Signup success");
                        registerUser();
                      }
                    },
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Already have account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Đã có tài khoản?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
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

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================== Helper Widgets ===================

  Widget buildInputLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xff111618),
        ),
      ),
    );
  }

  InputDecoration buildDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  InputDecoration buildPasswordDecoration({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade500),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade500,
        ),
        onPressed: onToggle,
      ),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
