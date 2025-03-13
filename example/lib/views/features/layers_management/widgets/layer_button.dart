import 'package:flutter/material.dart';

class LayerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LayerButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton.extended(
        heroTag: label,
        onPressed: onPressed,
        label: Text(label),
        icon: const Icon(Icons.layers),
      ),
    );
  }
}
