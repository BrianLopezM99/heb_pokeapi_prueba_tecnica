import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
