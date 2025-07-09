Map<int, List<Map<String, dynamic>>> groupByKm(List<Map<String, dynamic>> data, String kmKey) {
  final grouped = <int, List<Map<String, dynamic>>>{};
  for (final row in data) {
    final km = (row[kmKey] as num).floor();
    grouped.putIfAbsent(km, () => []).add(row);
  }
  return grouped;
}

double avg(List<num> values) => values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;

