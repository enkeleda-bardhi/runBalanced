import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/data_provider.dart';

class RecapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);
    final sessions = data.savedSessions.reversed.toList(); // per mostrare la più recente prima

    return Scaffold(
      appBar: AppBar(title: Text("Sessioni salvate")),
      body: sessions.isEmpty
          ? Center(child: Text("Nessuna sessione salvata"))
          : ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final s = sessions[index];
          final date = DateTime.parse(s['timestamp']);
          return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  "Sessione del ${date.day}/${date.month} alle ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Tempo: ${s['time']} - Distanza: ${s['distance'].toStringAsFixed(2)} km\n"
                      "Calorie: ${s['calories']} - Pace: ${s['pace']}\n"
                      "Respiro: ${s['breath'].toStringAsFixed(1)}%, "
                      "Articolazioni: ${s['joints'].toStringAsFixed(1)}%, "
                      "Muscoli: ${s['muscles'].toStringAsFixed(1)}%",
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Conferma eliminazione"),
                        content: Text("Vuoi davvero eliminare questa sessione?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Annulla")),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Elimina")),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      Provider.of<DataProvider>(context, listen: false)
                          .removeSession(sessions.length - 1 - index);
                    }
                  },

                ),
              )
          );
        },
      ),
    );
  }
}

