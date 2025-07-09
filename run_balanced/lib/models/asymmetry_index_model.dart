double asymmetryIndex({
  required double JLI_left,
  required double JLI_right
}) {
  final double asymmetry = (JLI_left - JLI_right).abs();
  return asymmetry;
}

Map<int, double> asymmetryIndex_km({
  required Map<int, double>  JLI_left,
  required Map<int, double>  JLI_right
}) {
  final Map<int, double> asymmetry = {};
  // Create a set of all unique keys from both maps to ensure no km is missed.
  final allKeys = {...JLI_left.keys, ...JLI_right.keys};

  for (final km in allKeys) {
    // Use the null-aware operator to safely get values, defaulting to 0.0 if a key doesn't exist.
    final leftValue = JLI_left[km] ?? 0.0;
    final rightValue = JLI_right[km] ?? 0.0;
    asymmetry[km] = (leftValue - rightValue).abs();
  }
  return asymmetry;
}

