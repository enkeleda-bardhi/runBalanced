import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

/// Loads CSV data from the given asset [path] and returns a list of maps,
/// where each map represents a row with column headers as keys.
///
/// This function is robust against empty cells or missing values, defaulting them to 0.
///
/// [path]: The asset path to the CSV file.
/// Returns a list of maps containing the CSV data.
Future<List<Map<String, dynamic>>> loadCsvData(String path) async {
  final rawData = await rootBundle.loadString(path);
  // Use a converter that automatically tries to parse numbers.
  final List<List<dynamic>> listData =
      const CsvToListConverter(eol: '\n', shouldParseNumbers: true)
          .convert(rawData);

  if (listData.isEmpty) {
    return [];
  }

  // The first row is the header.
  final headers = listData[0].map((e) => e.toString()).toList();
  final List<Map<String, dynamic>> csvTable = [];

  // Iterate over data rows (skipping the header row).
  for (int i = 1; i < listData.length; i++) {
    final row = listData[i];
    final Map<String, dynamic> rowMap = {};
    for (int j = 0; j < headers.length; j++) {
      // Defensive check: if the row is shorter than headers, or value is null, use 0.
      final value = (j < row.length && row[j] != null) ? row[j] : 0;
      rowMap[headers[j]] = value;
    }
    csvTable.add(rowMap);
  }
  return csvTable;
}