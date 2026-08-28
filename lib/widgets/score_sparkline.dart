import 'package:flutter/material.dart';

class ScoreSparkline extends StatelessWidget {
  final List<double> scores;
  const ScoreSparkline({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomPaint(size: const Size(double.infinity, 50), painter: _SparklinePainter(scores: scores)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> scores;
  _SparklinePainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;
    final paint = Paint()..color = const Color(0xFF4CAF50)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    final stepX = scores.length > 1 ? size.width / (scores.length - 1) : size.width;

    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final y = size.height - (scores[i] / 100 * size.height);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => true;
}