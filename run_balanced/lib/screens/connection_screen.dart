import 'package:flutter/material.dart';
import 'package:run_balanced/models/connection_model.dart';
import 'package:run_balanced/theme/theme.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  List<Connection> connections = Connection.sampleConnections;

  void _handleMenuAction(String action, int index) {
    setState(() {
      switch (action) {
        case 'connect':
          connections[index] = connections[index].copyWith(status: 'Connected');
          _showMessage('${connections[index].name} connected.');
          break;
        case 'disconnect':
          connections[index] = connections[index].copyWith(
            status: 'Disconnected',
          );
          _showMessage('${connections[index].name} disconnected.');
          break;
        case 'remove':
          final removed = connections.removeAt(index);
          _showMessage('${removed.name} removed.');
          break;
        case 'sync':
          _showMessage('Syncing ${connections[index].name}...');
          break;
        case 'info':
          _showDeviceInfo(connections[index]);
          break;
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showDeviceInfo(Connection conn) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(conn.name),
            content: Text(
              'Status: ${conn.status}\nMore details coming soon...',
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: connections.length,
        itemBuilder: (context, index) {
          return _buildConnectionCard(connections[index], index, colorScheme);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            connections.add(
              Connection(
                name: "New Device ${connections.length + 1}",
                status: "Disconnected",
                icon: Icons.bluetooth_connected_outlined,
              ),
            );
          });
        },
        tooltip: 'Add Device',
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConnectionCard(
    Connection conn,
    int index,
    ColorScheme colorScheme,
  ) {
    return Card(
      color: colorScheme.surface,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Icon(conn.icon, size: 32, color: colorScheme.primary),
        title: Text(
          conn.name,
          style: AppTextStyles.headline2.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: Text(
          conn.status,
          style: AppTextStyles.caption.copyWith(
            color: _getStatusColor(conn.status, colorScheme),
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
          color: colorScheme.surface,
          onSelected: (action) => _handleMenuAction(action, index),
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

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'connected':
        return colorScheme.primary;
      case 'syncing':
        return colorScheme.secondary;
      case 'disconnected':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }
}
