import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
Future<List<Map<String, dynamic>>> loadCsvData(String path) async {
  final raw = await rootBundle.loadString(path);
  final rows = const CsvToListConverter().convert(raw, eol: '\n');
  final headers = rows.first.cast<String>();
  final dataRows = rows.skip(1);

  return dataRows.map((row) {
    final map = <String, dynamic>{};
    for (int i = 0; i < headers.length; i++) {
      map[headers[i]] = row[i];
    }
    return map;
  }).toList();
}

