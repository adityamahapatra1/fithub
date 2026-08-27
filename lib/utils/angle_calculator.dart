import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class AngleCalculator {
  static double calculateAngle(PoseLandmark first, PoseLandmark mid, PoseLandmark last) {
    double radians = atan2(last.y - mid.y, last.x - mid.x) -
        atan2(first.y - mid.y, first.x - mid.x);
    double angle = (radians * 180.0 / pi).abs();
    if (angle > 180) angle = 360 - angle;
    return angle;
  }

  static double kneeAngle(Pose pose, {required bool leftSide}) {
    final hip = pose.landmarks[leftSide ? PoseLandmarkType.leftHip : PoseLandmarkType.rightHip];
    final knee = pose.landmarks[leftSide ? PoseLandmarkType.leftKnee : PoseLandmarkType.rightKnee];
    final ankle = pose.landmarks[leftSide ? PoseLandmarkType.leftAnkle : PoseLandmarkType.rightAnkle];
    if (hip == null || knee == null || ankle == null) return -1;
    return calculateAngle(hip, knee, ankle);
  }

  static double elbowAngle(Pose pose, {required bool leftSide}) {
    final shoulder = pose.landmarks[leftSide ? PoseLandmarkType.leftShoulder : PoseLandmarkType.rightShoulder];
    final elbow = pose.landmarks[leftSide ? PoseLandmarkType.leftElbow : PoseLandmarkType.rightElbow];
    final wrist = pose.landmarks[leftSide ? PoseLandmarkType.leftWrist : PoseLandmarkType.rightWrist];
    if (shoulder == null || elbow == null || wrist == null) return -1;
    return calculateAngle(shoulder, elbow, wrist);
  }
}