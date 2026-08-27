import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserModel(
      id: '1',
      name: 'Test Student',
      email: email,
      department: 'CSE',
      hostel: 'Hostel A',
      points: 120,
      squadId: 'sq1',
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void addPoints(int points) {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      department: _currentUser!.department,
      hostel: _currentUser!.hostel,
      points: _currentUser!.points + points,
      squadId: _currentUser!.squadId,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}