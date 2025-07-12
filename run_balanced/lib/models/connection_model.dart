import 'package:flutter/material.dart';

class Connection {
  final String name;
  final String status;
  final IconData icon;

  Connection({required this.name, required this.status, required this.icon});

  Connection copyWith({String? name, String? status, IconData? icon}) {
    return Connection(
      name: name ?? this.name,
      status: status ?? this.status,
      icon: icon ?? this.icon,
    );
  }

  static List<Connection> sampleConnections = [
    Connection(
      name: "Garmin Edge 540",
      status: "Connected",
      icon: Icons.bluetooth_connected_outlined,
    ),
    Connection(
      name: "Knee Sensor",
      status: "Disconnected",
      icon: Icons.bluetooth_connected_outlined,
    ),
    Connection(
      name: "Heart Rate Monitor",
      status: "Connected",
      icon: Icons.favorite_border,
    ),
    Connection(
      name: "Foot Pod",
      status: "Disconnected",
      icon: Icons.directions_run,
    ),
  ];
}
