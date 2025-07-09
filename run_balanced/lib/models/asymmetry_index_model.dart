double asymmetryIndex({
  required double JLI_left,
  required double JLI_right,
  required double SpO2,
}) {
  final double asymmetry = (JLI_left - JLI_right).abs() + (100.0 - SpO2) * 10;
  return asymmetry;
}

Map<int, double> asymmetryIndexKm({
  required Map<int, double>  JLI_left,
  required Map<int, double>  JLI_right,
  required Map<int, double>  SpO2
}) {
  final Map<int, double> asymmetry = {};
  // Create a set of all unique keys from both maps to ensure no km is missed.
  final allKeys = {...JLI_left.keys, ...JLI_right.keys, ...SpO2.keys};

  for (final km in allKeys) {
    // Use the null-aware operator to safely get values, defaulting to 0.0 if a key doesn't exist.
    final leftValue = JLI_left[km] ?? 0.0;
    final rightValue = JLI_right[km] ?? 0.0;
    final spo2Value = SpO2[km] ?? 100.0;

    asymmetry[km] = (leftValue - rightValue).abs() + (100.0 - spo2Value) * 10;
  }
  return asymmetry;
}

