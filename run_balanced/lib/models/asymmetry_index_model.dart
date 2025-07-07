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
  JLI_left.forEach((km, value) {
    final rightValue = JLI_right[km] ?? 0.0;
    asymmetry[km] = (value - rightValue).abs();
  });
  return asymmetry;
}

