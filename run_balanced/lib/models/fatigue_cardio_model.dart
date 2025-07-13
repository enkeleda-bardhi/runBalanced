import '../utils/utilities.dart';

// --- Model Configuration ---
// These weights determine the contribution of each metric to the final score.
// They should sum to 1.0.
const double wHR = 0.35;   // Heart Rate
const double wHRV = 0.20;  // Heart Rate Variability
const double wSpO2 = 0.20; // Blood Oxygen
const double wBP = 0.15;   // Blood Pressure
const double wTemp = 0.10; // Temperature

// Define expected physiological ranges for a typical run.
// These are used to normalize the raw values into a 0-1 scale.
const double minHR = 50.0, maxHR = 190.0;
const double minHRV = 20.0, maxHRV = 120.0;
const double minSpO2 = 91.0, maxSpO2 = 100.0;
const double minBP = 70.0, maxBP = 160.0;
const double minTemp = 36.0, maxTemp = 38.5;
// --- End of Configuration ---


/// Calculates a cardio fatigue score using a weighted average of normalized physiological metrics.
///
/// This approach provides a smoother, more realistic fatigue score compared to a step-based system.
/// Each metric is normalized to a 0-1 "fatigue contribution" scale, weighted, and then combined.
///
/// Returns a fatigue score clamped between 0 and 100.
double calculateCardioFatigue({
  required int hr,
  required double hrv,
  required double spo2,
  required int bp,
  required double temp,
  required double distanceKm,
}) {
  // Normalize each metric to a 0-1 "fatigue contribution" score.
  
  // For HR, BP, Temp: a higher value means higher fatigue.
  final hrScore = normalize(hr.toDouble(), minHR, maxHR);
  final bpScore = normalize(bp.toDouble(), minBP, maxBP);
  final tempScore = normalize(temp, minTemp, maxTemp);

  // For HRV, SpO2: a lower value means higher fatigue, so we invert the normalized value.
  final hrvScore = 1.0 - normalize(hrv, minHRV, maxHRV);
  final spo2Score = 1.0 - normalize(spo2, minSpO2, maxSpO2);

  // Calculate the final score by summing the weighted contributions.
  final totalScore = (hrScore * wHR) +
                     (hrvScore * wHRV) +
                     (spo2Score * wSpO2) +
                     (bpScore * wBP) +
                     (tempScore * wTemp);

  // Scale to 0-100 and clamp to ensure the value is within bounds.
  return (totalScore * 100).clamp(0, 100).toDouble();
}
