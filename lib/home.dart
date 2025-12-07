import 'package:flutter/material.dart';
import 'package:studyvocabulary/A.dart';
import 'package:studyvocabulary/lesson.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/profile.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00A6FB),
        fontFamily: 'Lexend',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00A6FB),
      ),
      home: HomePage(),
    );
  }
}

// Mock data for recommended lessons
final List<RecommendedLesson> recommendedLessons = [
  RecommendedLesson(
    title: 'Business English Basics',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAElGEO6-q4Ujo9pqQ0JUR66MeE3QNnDwOzbRK9LO5RbPqOELH8AwTNvxQsZgQ_FoC2_o7KX6j-GFHkaUdw77h5vgpqVBKbCj2aT1JZsUK3cjzDz8Vo4xsiGAR8TzcPZiHFXLkljaWsCkcZdBcX3zEBBQ24hi4_oAj4jASAufRlUt-liEhzIYISJzLP7L37CtdTHV_jjN9i2wzn3EhsF38LTtbdgLBhJ8OyrewtFSa5kZYG_A9HJ-QOmE5Aj_quFtKwAOAviuv7l88',
  ),
  RecommendedLesson(
    title: 'Travel Vocabulary',
    level: 'Intermediate',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD3YtX5SRfrboVcUvPBiM6Jrw1ijLDfQOwPXt1R5alFHa8HUckAnavg1373iWc4xq_dNVvBWegrgnWg_7LAAe1yBMClxfUbzXpPhxa2gihQIfHMUSvti3wQrm_JqayCQMOyd2iZ1mMDmLqcUGuw19d8EPKF4XZem3UwEqcDl97Mm4EJmzX7LuEFK1aS9QMCzmUpCBOhNHOec_-ExRNnWj0_6pEyMvgRcWkymCbuEkiJgHE9_xGslwlj5udO9AZZftHPl_jsMOdmwyE',
  ),
  RecommendedLesson(
    title: 'Food & Dining',
    level: 'Beginner',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAZW-ks9Zcr_Vo528eA7QJSapMSyBiSBLzJVZF_6I7qGuZE2mmyeBY6Cdls9SKeHDUoqvlID7h2tpcZlz6vxVNU9PfnwAXzE_6gq2juEPh2JIYYCmbhfm4xp55xi2xH8jx2X0IrV822ztD97Cnxu5Ib_DPPjMvNP02g7URe921Mc-YGxYTv8KARLlru3HBzOWFJ3I84Lblry6UWk4D7Gk0aviduvopaxaqEK0tJ4MzGRnFfaALku55N9Q--Nu3y2_vpMecIj6OvSbk',
  ),
];

final List<Map<String, dynamic>> practiceModes = [
  {
    'icon': Icons.quiz,
    'title': 'Quiz',
    'color': Color.fromARGB(255, 0, 162, 255),
  }, // xanh dương
  {
    'icon': Icons.style,
    'title': 'Flashcards',
    'color': Color(0xFF50E3C2),
  }, // xanh ngọc
  {
    'icon': Icons.link,
    'title': 'Match Words',
    'color': Color(0xFFF5A623),
  }, // cam sáng
  {
    'icon': Icons.pin,
    'title': 'Missing Letters',
    'color': Color(0xFF9013FE),
  }, // tím đậm
  {
    'icon': Icons.edit_note,
    'title': 'Sentence Arrage',
    'color': Color(0xFF7ED321),
  }, // xanh lá
  {
    'icon': Icons.headphones,
    'title': 'Listening',
    'color': Color(0xFFFF2D55),
  }, // hồng tươi
];

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  String completed = "-";
  String xp = "-";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Top App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Hãy bắt đầu việc học ngay thôi nào!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              // Daily Progress Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Colors.blueGrey, // màu viền
                      width: 2,
                    ), // độ dày viền
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCard(
                          icon: Icons.local_fire_department,
                          title: 'Hoàn thành',
                          value: completed,
                          color: Colors.orange,
                        ),
                        StatCard(
                          icon: Icons.bolt,
                          title: 'Điểm XP',
                          value: xp,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Practice Modes
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Practice Modes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GridView.count(
                  crossAxisCount: 2, // ⭐ 2 thẻ mỗi hàng
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true, // ⭐ cần cho Grid trong ScrollView
                  physics:
                      NeverScrollableScrollPhysics(), // để scroll theo trang chính
                  children: practiceModes.map((mode) {
                    return PracticeModeCard(
                      icon: mode['icon'],
                      title: mode['title'],
                      color: mode['color'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LessonSelectionPage(initialMode: mode['title']),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            // tab "Cá nhân"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else {
            setState(() {
              currentIndex = index;
            });
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
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap; // thêm callback

  const PracticeModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // gọi callback khi click
      child: SizedBox(
        width: 140,
        height: 140,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0), // màu viền
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendedLesson {
  final String title;
  final String level;
  final String imageUrl;

  RecommendedLesson({
    required this.title,
    required this.level,
    required this.imageUrl,
  });
}
