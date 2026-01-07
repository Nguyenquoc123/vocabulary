import 'package:flutter/material.dart';
import 'package:studyvocabulary/home.dart';
import 'package:studyvocabulary/login.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/rank.dart';
import 'package:studyvocabulary/service/api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = "-";
  String completed = "-";
  String xp = "-";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final name = await User.getFullName();
    final userId = await User.getUserId();

    if (userId == null) return;

    final summary = await callApi.getUserScoreSummary(userId);

    setState(() {
      fullName = name ?? "-";
      if (summary != null) {
        completed = summary.totalAttempts.toString();
        xp = summary.totalScore.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatarChar = fullName.isNotEmpty ? fullName[0].toUpperCase() : "?";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar chữ cái đầu
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  avatarChar,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tên user
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat("Lần học", completed),
                  _buildStat("XP", xp),
                ],
              ),

              const SizedBox(height: 30),

              // Logout
              _buildMenuButton(
                icon: Icons.logout,
                text: "Đăng xuất",
                onTap: () async {
                  await User.clear();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                color: Colors.redAccent,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),

      // Bottom bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          } else if (index == 1) {
            // tab "Cá nhân"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RankPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: "Rank",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Cá nhân",
          ),
        ],
      ),
    );
  }

  // Widget thống kê
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  // Button
  Widget _buildMenuButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color textColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: textColor),
          ],
        ),
      ),
    );
  }
}
