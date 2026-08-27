import 'package:flutter/material.dart';
import '../models/workout_session_model.dart';

class WorkoutProvider extends ChangeNotifier {
  final List<WorkoutSuggestion> suggestions = [
    WorkoutSuggestion(title: 'Quick Squat Burst', timeSlot: '11:00 AM - 11:15 AM', durationMinutes: 15, exercise: 'squat'),
    WorkoutSuggestion(title: 'Pushup Power', timeSlot: '4:00 PM - 4:10 PM', durationMinutes: 10, exercise: 'pushup'),
  ];
}