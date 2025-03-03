import 'package:flutter/material.dart';

class FpsButton extends StatelessWidget {
  final int fps;
  final int currentFps;
  final VoidCallback onPressed;

  const FpsButton({
    super.key,
    required this.fps,
    required this.currentFps,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton.extended(
        heroTag: "fps$fps",
        onPressed: onPressed,
        backgroundColor:
            currentFps == fps ? Theme.of(context).primaryColor : null,
        label: Text("$fps FPS"),
        icon: const Icon(Icons.speed),
      ),
    );
  }
}
