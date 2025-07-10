/// Calculates Joint Load Index (JLI).
///
/// [force] Applied force.
/// [angle] Joint angle.
/// [repetitions] Number of repetitions.
/// [alpha], [beta], [gamma] are weighting coefficients.
/// Returns a value between 0 and 100.


import 'km_avg.dart';
double calculateJLI({
  required double force,
  required double angle,
  required int repetitions,
  double alpha = 0.3,
  double beta = 0.5,
  double gamma = 0.2,
  double maxTheta = 45.0,
  double maxForce = 3.0,
  double maxReps = 300.0,

}) {
  if (force < 0 || angle < 0 || repetitions < 0) {
    throw ArgumentError('I parametri non possono essere negativi.');
  }
  final rawScore = (alpha * force / maxForce + beta * angle / maxTheta + gamma * repetitions / maxReps) * 100;
  return rawScore.clamp(0.0, 100.0);
}


/// Calculates the Joint Load Index (JLI) per kilometer from a list of biomechanical data.
///
/// The function groups the input data by kilometer (using the 'time' field to determine the kilometer),
/// then computes the average force (`F`), angle (`theta`), and repetitions (`R`) for each kilometer.
/// It applies the [calculateJLI] function to these averages to obtain the JLI for each kilometer.
///
/// - [biomechData]: A list of maps containing biomechanical data. Each map should have keys:
///   - `'F'`: Force value (num)
///   - `'theta'`: Angle value (num)
///   - `'R'`: Repetitions (num)
///   - `'time'`: Time in seconds (used for grouping by kilometer)
///
/// Returns a map where the key is the kilometer (int) and the value is the calculated JLI (double) for that kilometer.

Map<int, double> calculateJLIperKm(
  List<Map<String, dynamic>> biomechData,
  List<Map<String, dynamic>> cardioData,
) {
  if (cardioData.isEmpty) {
    return {};
  }

  // Group biomech entries by kilometer using cardio data for time-to-distance mapping.
  final Map<int, List<Map<String, dynamic>>> groupedByKm = {};
  int cardioIndex = 0;
  for (var biomechEntry in biomechData) {
    final biomechTime = biomechEntry['time'] as num? ?? 0;

    // Find the corresponding cardio entry without re-scanning the whole list.
    // This assumes both lists are sorted by time.
    while (cardioIndex < cardioData.length - 1 &&
           (cardioData[cardioIndex]['time'] as num? ?? 0) < biomechTime) {
      cardioIndex++;
    }

    final cardioEntry = cardioData[cardioIndex];
    final int km = (cardioEntry['distance_km'] as num? ?? 0.0).floor();

    if (!groupedByKm.containsKey(km)) {
      groupedByKm[km] = [];
    }
    groupedByKm[km]!.add(biomechEntry);
  }

  // Calculate average JLI for each kilometer using the helper function.
  return _calculateAverages(groupedByKm);
}

/// Helper function to calculate the average JLI from data grouped by kilometer.
Map<int, double> _calculateAverages(Map<int, List<Map<String, dynamic>>> groupedData) {
  final Map<int, double> result = {};
  groupedData.forEach((km, entries) {
    // Use safe casting with default values to prevent null errors.
    final Favg = avg(entries.map((e) => (e['F'] as num? ?? 0)).toList());
    final thetaAvg = avg(entries.map((e) => (e['theta'] as num? ?? 0)).toList());
    final Ravg = avg(entries.map((e) => (e['R'] as num? ?? 0)).toList());
    result[km] = calculateJLI(force: Favg, angle: thetaAvg, repetitions: Ravg.toInt());
  });
  return result;
}