class Challenge {
  final int id;
  final String title;
  final String description;
  final int durationDays;
  bool isJoined;
  DateTime? joinedDate;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    this.isJoined = false,
    this.joinedDate,
  });
}
