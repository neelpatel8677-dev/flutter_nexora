import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _user!.token != null;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    final userJson = prefs.getString(AppConstants.userKey);

    if (token != null && userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
      // Keep the token
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        role: _user!.role,
        phone: _user!.phone,
        studentId: _user!.studentId,
        employeeId: _user!.employeeId,
        course: _user!.course,
        semester: _user!.semester,
        batch: _user!.batch,
        department: _user!.department,
        subjects: _user!.subjects,
        isActive: _user!.isActive,
        token: token,
      );
      ApiService.setToken(token);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      final data = response['data'];
      _user = UserModel.fromJson(data);
      ApiService.setToken(_user!.token);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, _user!.token!);
      await prefs.setString(AppConstants.userKey, jsonEncode(_user!.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.register(data);
      final userData = response['data'];
      _user = UserModel.fromJson(userData);
      ApiService.setToken(_user!.token);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, _user!.token!);
      await prefs.setString(AppConstants.userKey, jsonEncode(_user!.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    ApiService.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    notifyListeners();
  }
}
