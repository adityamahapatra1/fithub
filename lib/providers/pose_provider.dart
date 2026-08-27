import 'package:flutter/material.dart';
import '../models/rep_count_result_model.dart';

class PoseProvider extends ChangeNotifier {
  RepCountResult? lastResult;

  void updateResult(RepCountResult result) {
    lastResult = result;
    notifyListeners();
  }

  void clear() {
    lastResult = null;
    notifyListeners();
  }
}