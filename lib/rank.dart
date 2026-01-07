import 'package:flutter/material.dart';
import 'package:studyvocabulary/home.dart';
import 'dart:convert';

import 'package:studyvocabulary/model/rank.dart';
import 'package:studyvocabulary/profile.dart';
import 'package:studyvocabulary/service/api.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<RankUser> ranks = [];
  bool loading = true;

  Future<void> _loadRank() async {
    ranks = await callApi.getRanking();
    setState(() => loading = false);
  }

  @override
  void initState() {// chạy lần đầu
    super.initState();
    _loadRank();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {// đang load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Bảng xếp hạng'), centerTitle: true, automaticallyImplyLeading: false,),
      body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ranks.length,
              itemBuilder: (context, index) {
                final rank = index + 1;
                final user = ranks[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildRankIcon(rank),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${user.xp} XP',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          } else if (index == 2) {
            // tab "Cá nhân"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
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

  Widget _buildRankIcon(int rank) {
    if (rank == 1) {
      return const Icon(Icons.emoji_events, color: Colors.amber, size: 32);
    } else if (rank == 2) {
      return const Icon(Icons.emoji_events, color: Colors.grey, size: 28);
    } else if (rank == 3) {
      return const Icon(Icons.emoji_events, color: Colors.brown, size: 26);
    }
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.grey.shade300,
      child: Text(
        rank.toString(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
