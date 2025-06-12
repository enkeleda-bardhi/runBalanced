import 'package:flutter/material.dart';
import 'package:run_balanced/models/connection.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Connection> connections = [
      Connection(name: "Polar H10", status: "Connected", icon: Icons.favorite),
      Connection(
        name: "Foot Sensor",
        status: "Disconnected",
        icon: Icons.directions_run,
      ),
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: connections.length,
        itemBuilder: (context, index) {
          final conn = connections[index];
          return _buildConnectionCard(context, conn, theme);
        },
      ),
    );
  }

  Widget _buildConnectionCard(
    BuildContext context,
    Connection conn,
    ThemeData theme,
  ) {
    return Card(
      color: theme.cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(conn.icon, color: theme.iconTheme.color, size: 32),
        title: Text(conn.name, style: theme.textTheme.bodyLarge),
        subtitle: Text(
          conn.status,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _getStatusColor(conn.status),
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
          onSelected: (value) {
            // Implement actions here
          },
          itemBuilder:
              (context) => [
                if (conn.status == "Connected")
                  const PopupMenuItem(
                    value: 'disconnect',
                    child: Text('Disconnect'),
                  )
                else
                  const PopupMenuItem(value: 'connect', child: Text('Connect')),
                const PopupMenuItem(value: 'remove', child: Text('Remove')),
                const PopupMenuItem(value: 'sync', child: Text('Sync Now')),
                const PopupMenuItem(value: 'info', child: Text('Device Info')),
              ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return Colors.green;
      case 'syncing':
        return Colors.orange;
      case 'disconnected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
