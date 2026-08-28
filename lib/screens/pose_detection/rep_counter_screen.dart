import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../models/rep_count_result_model.dart';
import '../../models/rep_record_model.dart';
import '../../services/pose_detection_service.dart';
import '../../services/rep_counter_service.dart';
import '../../utils/angle_calculator.dart';
import '../../widgets/camera_overlay_painter.dart';
import '../../widgets/form_score_gauge.dart';
import '../../widgets/score_sparkline.dart';

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
  bool _bodyReady = false;
  String? _error;

  // Session-only state — exists purely in memory, never persisted, gone on dispose
  final List<RepRecord> _history = [];
  double _latestFormScore = 0;
  String _latestFeedback = 'Get in frame and start your first rep';

  @override
  void initState() {
    super.initState();
    _repCounter = RepCounterService(exerciseType: widget.exerciseType);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      if (!mounted) return;

      await _controller!.startImageStream((image) async {
        if (_poseService.isBusy) return;
        _poseService.isBusy = true;
        try {
          final poses = await _poseService.detectPose(image, camera);
          if (poses.isNotEmpty) {
            final pose = poses.first;
            final isSquat = widget.exerciseType == ExerciseType.squat;
            final bodyReady = AngleCalculator.isBodyReadyFor(pose, isSquat: isSquat);
            final result = _repCounter.processPose(pose);

            if (mounted) {
              setState(() {
                _currentPose = pose;
                _bodyReady = bodyReady;
                if (result != null) {
                  _result = result;
                  if (result.completedRep != null) {
                    _history.add(result.completedRep!);
                    _latestFormScore = result.completedRep!.formScore;
                    _latestFeedback = result.completedRep!.feedback;
                  }
                }
              });
            }
          }
        } catch (_) {}
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
    super.dispose(); // _history and all session data die right here
  }

  Color get _stateColor => _result?.stage == RepStage.down ? const Color(0xFFFFC107) : const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: _error != null
            ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_error!, style: const TextStyle(color: Colors.white))))
            : Column(
          children: [
            _buildTopBar(),
            Expanded(flex: 5, child: _buildCameraArea()),
            Expanded(flex: 4, child: _buildStatsPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          Expanded(
            child: Text(
              widget.exerciseType == ExerciseType.squat ? 'Squat Session' : 'Pushup Session',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle, size: 8, color: Colors.greenAccent),
              SizedBox(width: 6),
              Text('LIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraArea() {
    if (_initializing || _controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          if (_currentPose != null)
            CustomPaint(painter: PosePainter(_currentPose!, Size(_controller!.value.previewSize!.height, _controller!.value.previewSize!.width))),
          if (_currentPose != null && !_bodyReady)
            Positioned(
              top: 50, left: 12, right: 12,
              child: _pill('⚠ Step back — full body not in frame', Colors.orangeAccent, fullWidth: true),
            ),
          Positioned(top: 12, left: 12, child: _pill('STATE: ${_result?.stage.name.toUpperCase() ?? '-'}', _stateColor)),
          Positioned(top: 12, right: 12, child: _pill('REPS: ${_result?.repCount ?? 0}', Colors.white)),
          if (_result?.formMessage != null)
            Positioned(bottom: 12, left: 12, right: 12, child: _pill(_result!.formMessage!, Colors.orangeAccent, fullWidth: true)),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color, {bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.6))),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatsPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF141A21), borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBlock('${_result?.repCount ?? 0}', 'REPS', Icons.fitness_center, Colors.greenAccent),
                FormScoreGauge(score: _latestFormScore),
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(_latestFeedback, style: const TextStyle(color: Colors.white70, fontSize: 13))),
            ]),
            const SizedBox(height: 16),
            const Text('FORM SCORE TREND', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            ScoreSparkline(scores: _history.map((r) => r.formScore).toList()),
            const SizedBox(height: 16),
            const Text('REP HISTORY', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8),
            _history.isEmpty
                ? const Text('No reps yet — start moving!', style: TextStyle(color: Colors.white38, fontSize: 13))
                : SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _history.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final r = _history[_history.length - 1 - i];
                  final color = r.valid ? Colors.greenAccent : Colors.redAccent;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.4))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('#${r.repNumber}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 6),
                      Text('${r.formScore.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child: const Text('End Session', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBlock(String value, String label, IconData icon, Color color) {
    return Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1)),
      ]),
    ]);
  }
}