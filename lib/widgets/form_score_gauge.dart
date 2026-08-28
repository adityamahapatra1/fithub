import 'dart:math';
import 'package:flutter/material.dart';

class FormScoreGauge extends StatelessWidget {
  final double score;
  const FormScoreGauge({super.key, required this.score});

  Color get _color {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFFFFC107);
    return const Color(0xFFEF5350);
  }

  String get _label {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Work';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(size: const Size(150, 90), painter: _GaugePainter(score: score, color: _color)),
          Positioned(
            bottom: 6,
            child: Column(
              children: [
                Text('${score.toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(_label, style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;
  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 8;
    final bgPaint = Paint()..color = Colors.white12..strokeWidth = 12..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final fgPaint = Paint()..color = color..strokeWidth = 12..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, pi, pi, false, bgPaint);
    canvas.drawArc(rect, pi, pi * (score.clamp(0, 100) / 100), false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.score != score;
}