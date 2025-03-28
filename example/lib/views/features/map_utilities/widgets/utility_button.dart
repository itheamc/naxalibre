import 'package:flutter/material.dart';

class UtilityButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const UtilityButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton.extended(
        heroTag: label,
        onPressed: onPressed,
        label: Text(label),
        icon: Icon(icon),
      ),
    );
  }
}
