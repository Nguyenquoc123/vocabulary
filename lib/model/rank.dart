class RankUser {
  final String fullName;
  final int xp;

  RankUser({
    required this.fullName,
    required this.xp,
  });

  factory RankUser.fromJson(Map<String, dynamic> json) {
    return RankUser(
      fullName: json['full_name'],
      xp: int.tryParse(json['xp'].toString()) ?? 0,
    );
  }
}
