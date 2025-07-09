import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
/// Loads CSV data from the given asset [path] and returns a list of maps,
/// where each map represents a row with column headers as keys.
///
/// [path]: The asset path to the CSV file.
/// Returns a list of maps containing the CSV data.
Future<List<Map<String, dynamic>>> loadCsvData(String path) async {
  final raw = await rootBundle.loadString(path);
  final rows = const CsvToListConverter().convert(raw, eol: '\n');
  if (rows.isEmpty) return [];

  final headers = rows.first.map((e) => e.toString()).toList();
  final dataRows = rows.skip(1);
  return dataRows.map((row) {
    final map = <String, dynamic>{};
    for (int i = 0; i < headers.length; i++) {
      // Attempt to parse each value as a number; if it fails, keep it as a string.
      map[headers[i]] = num.tryParse(row[i].toString()) ?? row[i];    
      }
    return map;
  }).toList();
}

// DA SISTEMARE:  a noi serve una table di matlab non una lista di mappe