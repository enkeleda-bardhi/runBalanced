import 'package:run_balanced/models/utilities.dart';

// --- Model Configuration ---
// These weights determine how much each component contributes to the final index.
const double wMechanical = 0.7; // 70% contribution from mechanical asymmetry (JLI difference)
const double wPhysiological = 0.3; // 30% from physiological stress (SpO2)

// Define physiological range for SpO2 normalization.
const double minSpO2 = 92.0, maxSpO2 = 100.0;
// --- End of Configuration ---


/// Calculates a weighted asymmetry index based on mechanical and physiological factors.
///
/// This model separates the raw difference in Joint Load Index (JLI) between
/// left and right sides from the overall physiological stress indicated by SpO2.
/// Each component is normalized and combined using weights for a more balanced score.
///
/// Returns a value between 0 and 100.
double asymmetryIndex({
  required double JLI_left,
  required double JLI_right,
  required double SpO2,
}) {
  // 1. Calculate the mechanical asymmetry component.
  // The raw difference in JLI is normalized to a 0-1 scale.
  final double mechanicalAsymmetry = (JLI_left - JLI_right).abs() / 100.0;

  // 2. Calculate the physiological stress component.
  // A lower SpO2 indicates higher stress. We normalize and invert it.
  final double physiologicalStress = 1.0 - normalize(SpO2, minSpO2, maxSpO2);

  // 3. Combine the components using the defined weights.
  final totalScore = (mechanicalAsymmetry * wMechanical) + (physiologicalStress * wPhysiological);

  // 4. Scale to 0-100 and clamp.
  return (totalScore * 100).clamp(0.0, 100.0);
}
