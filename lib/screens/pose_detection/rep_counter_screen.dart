import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../models/rep_count_result_model.dart';
import '../../services/pose_detection_service.dart';
import '../../services/rep_counter_service.dart';
import '../../widgets/camera_overlay_painter.dart';

class RepCounterScreen extends StatefulWidget {
  final ExerciseType exerciseType;
  const RepCounterScreen({super.key, required this.exerciseType});

  @override
  State<RepCounterScreen> createState() => _RepCounterScreenState();
}

class _RepCounterScreenState extends State<RepCounterScreen> {
  CameraController? _controller;
  late RepCounterService _repCounter;
  final PoseDetectionService _poseService = PoseDetectionService();

  Pose? _currentPose;
  RepCountResult? _result;
  bool _initializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repCounter = RepCounterService(exerciseType: widget.exerciseType);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;

      await _controller!.startImageStream((image) async {
        if (_poseService.isBusy) return;
        _poseService.isBusy = true;
        try {
          final poses = await _poseService.detectPose(image, frontCamera);
          if (poses.isNotEmpty) {
            final pose = poses.first;
            final result = _repCounter.processPose(pose);
            if (mounted) {
              setState(() {
                _currentPose = pose;
                _result = result;
              });
            }
          }
        } catch (_) {
          // skip bad frame, keep stream alive
        }
        _poseService.isBusy = false;
      });

      setState(() => _initializing = false);
    } catch (e) {
      setState(() {
        _error = 'Camera error: $e';
        _initializing = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _poseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exerciseType == ExerciseType.squat ? 'Squat Counter' : 'Pushup Counter')),
      body: _error != null
          ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_error!)))
          : _initializing || _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          if (_currentPose != null)
            CustomPaint(
              painter: PosePainter(
                _currentPose!,
                Size(_controller!.value.previewSize!.height, _controller!.value.previewSize!.width),
              ),
            ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'Reps: ${_result?.repCount ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          if (_result?.formMessage != null)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(12)),
                  child: Text(_result!.formMessage!, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}