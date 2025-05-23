class Activity {
  final DateTime date;
  final String duration;
  final double distance;
  final double calories;
  final double pace;
  final List<double> jointData;
  final List<double> cardioData;
  final List<double> muscleData;

  Activity({
    required this.date,
    required this.duration,
    required this.distance,
    required this.calories,
    required this.pace,
    required this.jointData,
    required this.cardioData,
    required this.muscleData,
  });
}