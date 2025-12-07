import 'package:flutter/material.dart';
import 'package:studyvocabulary/home.dart';
import 'package:studyvocabulary/login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
            const SizedBox(height: 16),

            const Text(
              "Tên người dùng",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("Bài đã hoàn thành", "32"),
                _buildStat("Từ đã học", "450"),
                _buildStat("XP", "1280"),
              ],
            ),

            const SizedBox(height: 30),

            // Button Thông tin cá nhân
            _buildMenuButton(
              icon: Icons.person,
              text: "Thông tin cá nhân",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              icon: Icons.store,
              text: "Mua bản Pro",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // Button Logout
            _buildMenuButton(
              icon: Icons.logout,
              text: "Đăng xuất",
              onTap: () {
                // Xử lý logout
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              color: Colors.redAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Luôn highlight tab cuối (index 2)
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            // Mở trang cá nhân khi click tab cuối
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {}
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
  static Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  // Widget button menu
  static Widget _buildMenuButton({
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
          border: color == Colors.white
              ? Border.all(color: Colors.grey.shade300)
              : null,
          boxShadow: [
            if (color == Colors.white)
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
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
                  fontWeight: FontWeight.w500,
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
