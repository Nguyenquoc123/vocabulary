import 'package:flutter/material.dart';
import 'package:studyvocabulary/lesson.dart';
import 'package:studyvocabulary/model/user.dart';
import 'package:studyvocabulary/myword.dart';
import 'package:studyvocabulary/profile.dart';
import 'package:studyvocabulary/rank.dart';
import 'package:studyvocabulary/service/api.dart';

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
  int user_id = -1;
  @override
  void initState() { //  gọi lần đầu
    super.initState();
    loadScoreSummary();
  }

  Future<void> loadScoreSummary() async {// load lần học và điểm xp
    final userId = await User.getUserId();
    
    if (userId == null) return;
    final summary = await callApi.getUserScoreSummary(userId);
    user_id = userId;
    if (summary != null) {
      setState(() {
        completed = summary.totalAttempts.toString();
        xp = summary.totalScore.toString();
      });
    }
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 16), //padding left-right
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
                          title: 'Lần học',
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
              // 
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // vô hiệu hóa cuộn
                itemCount: practiceModes.length,
                itemBuilder: (context, index) {
                  final mode = practiceModes[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ), // Tạo khoảng cách giữa các nút
                    child: PracticeModeCard(
                      icon: mode['icon'],
                      title: mode['title'],
                      color: mode['color'],
                      onTap: () async {
                        final reload = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LessonSelectionPage(initialMode: mode['title']),
                          ),
                        );

                        if (reload == true) {
                          loadScoreSummary(); // load lại XP & lần học
                        }
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Tạo khoảng cách giữa các nút
                child: PracticeModeCard(
                  icon: Icons.verified_user,
                  title: "Từ của tôi",
                  color: const Color.fromARGB(255, 0, 217, 255),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyWordPage(userId: user_id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar( // menu bottom
        currentIndex: currentIndex, // currentIndex = 0 là home
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            // tab "Cá nhân"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RankPage()),
            );
          } else if (index == 2) {
            // tab "profile"
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
  final VoidCallback? onTap;

  const PracticeModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // hiệu ứng gợn sóng khi chạm
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black12, // Màu viền nhẹ nhàng hơn
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ), // icon mũi tên chỉ hướng
          ],
        ),
      ),
    );
  }
}

