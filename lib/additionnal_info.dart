import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  const AdditionalInfo(
      {super.key,
      required this.label,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 10),
          Text(label),
          const SizedBox(height: 10),
          Text(value),
        ],
      ),
    );
  }
}
