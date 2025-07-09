import 'package:flutter/material.dart';

class ControlsWidget extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onStopSave;

  const ControlsWidget({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onReset,
    required this.onStopSave,
    super.key,
  });

  @override
  State<ControlsWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Play/Pause toggle button
        ElevatedButton(
          onPressed: widget.onPlayPause,
          child: Icon(
            widget.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 30,
          ),
          ),

        // Reset button
        // Stop/Reset button in secondary style
        OutlinedButton.icon(
          onPressed: widget.onReset,
          icon: const Icon(Icons.stop, color: Colors.redAccent),
          label: const Text("Stop"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.redAccent,
            side: const BorderSide(color: Colors.redAccent),
          ),
        ),

        // Save button
        ElevatedButton(
          onPressed: widget.onStopSave,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Row(
            children: [
              Icon(Icons.save),
              SizedBox(width: 6),
              Text("Save"),
            ],
          ),
        ),
      ],
    );
  }
}