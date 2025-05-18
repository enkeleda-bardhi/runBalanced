import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onStopSave;

  const ControlsWidget({
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onStopSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(child: ElevatedButton(onPressed: onStart, child: Text("Avvia"))),
        Flexible(child: ElevatedButton(onPressed: onPause, child: Text("Pausa"))),
        Flexible(child: ElevatedButton(onPressed: onReset, child: Text("Reset"))),
        Flexible(child: ElevatedButton(onPressed: onStopSave, child: FittedBox(child: Text("Stop & Salva")))),
      ],
    );
  }
}
