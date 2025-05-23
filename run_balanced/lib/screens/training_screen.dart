// lib/screens/training_screen.dart
import 'package:flutter/material.dart';
import '../services/impact_api_service.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late Future<List<dynamic>> _heartRateData;

  @override
  void initState() {
    super.initState();
    _loadHeartRate(); // do NOT await here
  }

  void _loadHeartRate() {
    setState(() {
      _heartRateData = ImpactApiService.fetchHeartRateDay(
        patientUsername: 'Jpefaq6m58',
        day: '2025-05-13',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training - Heart Rate')),
      body: FutureBuilder<List<dynamic>>(
        future: _heartRateData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final heartRates = snapshot.data!;
            if (heartRates.isEmpty) {
              return const Center(child: Text('No heart rate data available.'));
            }
            return ListView.builder(
              itemCount: heartRates.length,
              itemBuilder: (context, index) {
                final hr = heartRates[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text('Heart Rate: ${hr['value']}'),
                    subtitle: Text('Time: ${hr['timestamp']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
