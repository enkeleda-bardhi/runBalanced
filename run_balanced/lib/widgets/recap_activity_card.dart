import 'package:flutter/material.dart';
import 'package:run_balanced/models/activity.dart';
import 'package:intl/intl.dart';

import '../screens/recap_detail_screen.dart';

class RecapActivityCard extends StatelessWidget {
  final Activity activity;

  RecapActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy – HH:mm').format(activity.date);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text('Allenamento del $formattedDate'),
        subtitle: Text('Distanza: ${activity.distance} km, Tempo: ${activity.duration}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecapDetailScreen(activity: activity),
            ),
          );
        },
      ),
    );
  }
}