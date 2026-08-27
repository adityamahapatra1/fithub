import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/points_display.dart';
import '../scheduler/scheduler_screen.dart';
import '../squad/squad_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../pose_detection/rep_counter_screen.dart';
import '../body_composition/bf_calculator_screen.dart';
import '../../models/rep_count_result_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16), child: Center(child: PointsDisplay(points: user?.points ?? 0))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _tile(context, Icons.camera_alt, 'Rep Counter', Colors.deepPurple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => RepCounterScreen(exerciseType: ExerciseType.squat)))),
            _tile(context, Icons.schedule, 'Scheduler', Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SchedulerScreen()))),
            _tile(context, Icons.groups, 'My Squad', Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SquadScreen()))),
            _tile(context, Icons.leaderboard, 'Leaderboard', Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()))),
            _tile(context, Icons.monitor_weight, 'Body Comp', Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BfCalculatorScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}