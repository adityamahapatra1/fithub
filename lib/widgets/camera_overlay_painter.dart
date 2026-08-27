import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;

  PosePainter(this.pose, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = Colors.redAccent;

    double scaleX(double x) => x * size.width / imageSize.width;
    double scaleY(double y) => y * size.height / imageSize.height;

    for (final landmark in pose.landmarks.values) {
      canvas.drawCircle(
        Offset(scaleX(landmark.x), scaleY(landmark.y)),
        5,
        dotPaint,
      );
    }

    void drawLine(PoseLandmarkType a, PoseLandmarkType b) {
      final la = pose.landmarks[a];
      final lb = pose.landmarks[b];
      if (la == null || lb == null) return;
      canvas.drawLine(
        Offset(scaleX(la.x), scaleY(la.y)),
        Offset(scaleX(lb.x), scaleY(lb.y)),
        paint,
      );
    }

    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) => true;
}