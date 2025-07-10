/// Normalizes a value within a given range [min] to [max].
///
/// Returns a value between 0.0 and 1.0, representing where the value
/// falls within the range.
double normalize(double value, double min, double max) {
  // Avoid division by zero if the range is invalid.
  if (max == min) return 0.0;
  // Clamp the result between 0 and 1 to handle values outside the expected range.
  return ((value - min) / (max - min)).clamp(0.0, 1.0);
}

/// Calculates the average of a list of numbers.
double avg(List<num> values) {
  if (values.isEmpty) return 0.0;
  // Use fold with an initial value of 0.0 to ensure the sum is a double.
  // This is more type-safe than reduce for mixed lists of numbers.
  final sum = values.fold<double>(0.0, (previousValue, element) => previousValue + element);
  return sum / values.length;
}
