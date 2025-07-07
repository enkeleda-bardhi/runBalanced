/// Calcola il Joint Load Index (JLI).
/// 
/// [force] Forza applicata.
/// [angle] Angolo articolare.
/// [repetitions] Numero di ripetizioni.
/// [alpha], [beta], [gamma] sono coefficienti di ponderazione.
/// Restituisce un valore compreso tra 0 e 100.
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

import 'km_avg.dart';
double calculateJLI({
  required double force,
  required double angle,
  required int repetitions,
  double alpha = 15.0,
  double beta = 1.0,
  double gamma = 0.2,
}) {
  if (force < 0 || angle < 0 || repetitions < 0) {
    throw ArgumentError('I parametri non possono essere negativi.');
  }
  final rawScore = alpha * force + beta * angle + gamma * repetitions;
  return rawScore.clamp(0.0, 100.0);
}

Map<int, double> calculateJLIperKm(List<Map<String, dynamic>> biomechData) {
  final grouped = groupByKm(biomechData, 'time'); // Assume tempo in sec
  final Map<int, double> result = {};
  grouped.forEach((km, entries) {
    final Favg = avg(entries.map((e) => e['F'] as num).toList());
    final thetaAvg = avg(entries.map((e) => e['theta'] as num).toList());
    final Ravg = avg(entries.map((e) => e['R'] as num).toList());
    result[km] = calculateJLI(force: Favg, angle: thetaAvg, repetitions: Ravg.toInt());
  });
  return result;
}