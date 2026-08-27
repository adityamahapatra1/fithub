import 'package:flutter/material.dart';

class PointsDisplay extends StatelessWidget {
  final int points;
  const PointsDisplay({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.stars, color: Colors.amber),
      label: Text('$points pts', style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}