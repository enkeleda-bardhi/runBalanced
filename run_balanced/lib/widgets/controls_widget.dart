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
        Flexible(child: ElevatedButton(onPressed: onStart, child: Icon(Icons.play_arrow))),
        Flexible(child: ElevatedButton(onPressed: onPause, child: Icon(Icons.pause))),
        Flexible(child: ElevatedButton(onPressed: onReset, child: Icon(Icons.stop))),
        Flexible(child: ElevatedButton(onPressed: onStopSave, child: FittedBox(child: Icon(Icons.save)))),
      ],
    );
  }
}
