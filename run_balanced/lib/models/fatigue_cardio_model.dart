import 'km_avg.dart';
int calculateCardioFatigue({
  required int hr,
  required double hrv,
  required double spo2,
  required int bp,
  required double temp,
  required double distanceKm,
}) {
  int score = 0;
  if (hr >= 90 && hr < 100) score += 5;
  else if (hr < 110) score += 10;
  else if (hr >= 110) score += 25;

  if (hrv < 30) score += 25;
  else if (hrv < 40) score += 10;
  else if (hrv < 50) score += 5;

  if (spo2 < 91) score += 15;
  else if (spo2 < 93) score += 10;
  else if (spo2 < 95) score += 5;

  if (bp >= 150) score += 15;
  else if (bp >= 140) score += 10;
  else if (bp >= 130) score += 5;

  if (temp >= 37.5) score += 10;
  else if (temp >= 37.2) score += 5;

  return score.clamp(0, 100);
}

// più devia dalla norma più aumenta il punteggio


Map<int, int> calculateCardioFatiguePerKm(List<Map<String, dynamic>> cardioData, List<int> hrList) {
  final grouped = groupByKm(cardioData, 'distance_km');
  final Map<int, int> result = {};
  int i = 0;
  grouped.forEach((km, entries) {
    // Use safe casting with default values to prevent null errors.
    final hrvAvg = avg(entries.map((e) => (e['HRV'] as num? ?? 0)).toList());
    final spo2Avg = avg(entries.map((e) => (e['SpO2'] as num? ?? 0)).toList());
    final bpAvg = avg(entries.map((e) => (e['BP'] as num? ?? 0)).toList());
    final tempAvg = avg(entries.map((e) => (e['Temp'] as num? ?? 0)).toList());
    final hr = hrList.isNotEmpty ? hrList[i.clamp(0, hrList.length - 1)] : 0;
    i++;
    result[km] = calculateCardioFatigue(
      hr: hr,
      hrv: hrvAvg,
      spo2: spo2Avg,
      bp: bpAvg.toInt(),
      temp: tempAvg,
      distanceKm: km.toDouble(),
    );
  });
  return result;
}
