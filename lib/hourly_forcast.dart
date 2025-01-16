import 'package:flutter/material.dart';

class HaurlyForcast extends StatelessWidget {
  final String label;
  final String temprature;
  final IconData icon;
  const HaurlyForcast(
      {super.key,
      required this.label,
      required this.temprature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(label),
            const SizedBox(height: 10),
            Icon(icon),
            const SizedBox(height: 10),
            Text(temprature),
          ],
        ),
      ),
    );
  }
}
