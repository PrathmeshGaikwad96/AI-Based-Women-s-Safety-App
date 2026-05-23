import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthState extends ChangeNotifier {
  final AuthService _authService;
  UserModel? _currentUser;
  bool _isAdmin = false;
  bool _isLoading = false;
  String? _errorMessage;

  AuthState(this._authService) {
    _init();
  }

  UserModel? get currentUser => _currentUser;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isFirebaseEnabled => _authService.isFirebaseEnabled;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final uid = await _authService.checkCurrentSession();
      if (uid != null) {
        _currentUser = await _authService.fetchUserProfile(uid);
        if (_currentUser != null) {
          _isAdmin = await _authService.checkIfAdmin(uid);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear errors
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(email: email, password: password);
      _currentUser = user;
      if (user != null) {
        _isAdmin = await _authService.checkIfAdmin(user.uid);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String dob,
    required String address,
    required String aadhaarImageUrl,
    required String guardianName,
    required String guardianPhone,
    required String guardianRelation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        dob: dob,
        address: address,
        aadhaarImageUrl: aadhaarImageUrl,
        guardianName: guardianName,
        guardianPhone: guardianPhone,
        guardianRelation: guardianRelation,
      );
      _currentUser = user;
      _isAdmin = await _authService.checkIfAdmin(user.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<void> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _isAdmin = false;
    notifyListeners();
  }

  // Update profile attributes
  Future<void> updateProfile({
    required String name,
    required String phone,
    String? avatarSeed,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updated = _currentUser!.copyWith(
        name: name,
        phone: phone,
        avatarSeed: avatarSeed ?? _currentUser!.avatarSeed,
      );
      await _authService.updateUserProfile(updated);
      _currentUser = updated;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update safety circle contacts locally/database
  Future<void> updateSafetyCircle(List<String> guardianIds) async {
    if (_currentUser == null) return;
    final updated = _currentUser!.copyWith(guardianIds: guardianIds);
    await _authService.updateUserProfile(updated);
    _currentUser = updated;
    notifyListeners();
  }

  Future<void> refreshAdminStatus() async {
    if (_currentUser != null) {
      final wasAdmin = _isAdmin;
      _isAdmin = await _authService.checkIfAdmin(_currentUser!.uid);
      if (wasAdmin != _isAdmin) {
        notifyListeners();
      }
    }
  }
}
