import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/data_provider.dart';

class RecapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);
    final sessions = data.savedSessions.reversed.toList(); // most recent first

    return Scaffold(
      body:
          sessions.isEmpty
              ? Center(child: Text("No saved sessions"))
              : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final s = sessions[index];
                  final date = s['timestamp'] as Timestamp?;
                  final dateFormatted =
                      date != null
                          ? DateFormat(
                            'yyyy-MM-dd HH:mm:ss',
                          ).format(date.toDate())
                          : null;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        "Session on $dateFormatted",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Time: ${s['time']} - Distance: ${s['distance'].toStringAsFixed(2)} km\n"
                        "Calories: ${s['calories']} - Pace: ${s['pace']}\n"
                        "Breath: ${s['breath'].toStringAsFixed(1)}%, "
                        "Joints: ${s['joints'].toStringAsFixed(1)}%, "
                        "Muscles: ${s['muscles'].toStringAsFixed(1)}%",
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text("Confirm Deletion"),
                                  content: Text(
                                    "Do you really want to delete this session?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await data.deleteSessionById(s['id']);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
