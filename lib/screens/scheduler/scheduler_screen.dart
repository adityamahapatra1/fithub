import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';

class SchedulerScreen extends StatelessWidget {
  const SchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestions = context.watch<WorkoutProvider>().suggestions;
    return Scaffold(
      appBar: AppBar(title: const Text('Micro-Workout Scheduler')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          final s = suggestions[i];
          return Card(
            child: ListTile(
              leading: Icon(s.exercise == 'squat' ? Icons.airline_seat_legroom_extra : Icons.fitness_center),
              title: Text(s.title),
              subtitle: Text('${s.timeSlot} · ${s.durationMinutes} min'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}