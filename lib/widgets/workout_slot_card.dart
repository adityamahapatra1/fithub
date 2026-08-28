import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';
import '../utils/date_time_helper.dart';
import '../screens/pose_detection/rep_counter_screen.dart';

class WorkoutSlotCard extends StatelessWidget {
  final WorkoutSlotPlan plan;
  const WorkoutSlotCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  '${DateTimeHelper.minutesToLabel(plan.slot.startMinutes)} - ${DateTimeHelper.minutesToLabel(plan.slot.endMinutes)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(plan.split.label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...plan.exercises.map((ex) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.fitness_center, size: 14, color: Colors.white38),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ex.name, style: const TextStyle(fontSize: 13))),
                  Text(ex.prescription, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                  if (ex.trackableAs != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RepCounterScreen(exerciseType: ex.trackableAs!))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.greenAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.camera_alt, size: 12, color: Colors.greenAccent),
                          SizedBox(width: 4),
                          Text('Track', style: TextStyle(fontSize: 11, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  ],
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}