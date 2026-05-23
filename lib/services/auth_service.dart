import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final fb_auth.FirebaseAuth? _fbAuth;
  final FirebaseFirestore? _db;
  bool _isFirebaseEnabled = false;
  static bool bypassFirebase = false;

  AuthService({fb_auth.FirebaseAuth? fbAuth, FirebaseFirestore? db})
      : _fbAuth = fbAuth,
        _db = db {
    if (_fbAuth != null && _db != null) {
      _isFirebaseEnabled = true;
    }
  }

  // Check if Firebase is active
  bool get isFirebaseEnabled => _isFirebaseEnabled && !bypassFirebase;

  // Stream of current user ID
  Stream<String?> get onAuthStateChanged {
    if (isFirebaseEnabled) {
      return _fbAuth!.authStateChanges().map((user) => user?.uid);
    } else {
      // Simulate auth changes
      return Stream.periodic(const Duration(seconds: 1), (_) {
        return _currentMockUserId;
      }).distinct();
    }
  }

  static String? _currentMockUserId;

  // Get current user UID
  String? get currentUid {
    if (isFirebaseEnabled) {
      return _fbAuth!.currentUser?.uid;
    }
    return _currentMockUserId;
  }

  // Check persistent session on startup
  Future<String?> checkCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUid = prefs.getString('mock_uid');
    if (savedUid == 'demo_admin') {
      bypassFirebase = true;
    }
    if (isFirebaseEnabled) {
      final user = _fbAuth!.currentUser;
      return user?.uid;
    }
    _currentMockUserId = savedUid;
    return _currentMockUserId;
  }

  // Sign up
  Future<UserModel> signUp({
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
    if (isFirebaseEnabled) {
      final cred = await _fbAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        phone: phone,
        dob: dob,
        address: address,
        aadhaarImageUrl: aadhaarImageUrl,
        guardianName: guardianName,
        guardianPhone: guardianPhone,
        guardianRelation: guardianRelation,
        guardianIds: [],
        verificationStatus: 'pending',
        isBlocked: false,
        activityLog: [
          {'action': 'Account registered', 'timestamp': DateTime.now().toIso8601String()}
        ],
      );
      await _db!.collection('users').doc(user.uid).set(user.toMap());
      return user;
    } else {
      final uid = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
      final user = UserModel(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        dob: dob,
        address: address,
        aadhaarImageUrl: aadhaarImageUrl,
        guardianName: guardianName,
        guardianPhone: guardianPhone,
        guardianRelation: guardianRelation,
        guardianIds: [],
        verificationStatus: 'pending',
        isBlocked: false,
        activityLog: [
          {'action': 'Account registered (Simulated)', 'timestamp': DateTime.now().toIso8601String()}
        ],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mock_uid', uid);
      await prefs.setString('user_$uid', jsonEncode(user.toMap()));

      // Save user email to password map for simulated login
      final credentialsMap = jsonDecode(prefs.getString('mock_creds') ?? '{}');
      credentialsMap[email] = {'uid': uid, 'password': password};
      await prefs.setString('mock_creds', jsonEncode(credentialsMap));

      _currentMockUserId = uid;
      return user;
    }
  }

  // Sign in
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    if (email == 'admin@shri.com' && password == 'admin123') {
      bypassFirebase = true;
      final prefs = await SharedPreferences.getInstance();
      _currentMockUserId = 'demo_admin';
      await prefs.setString('mock_uid', 'demo_admin');
      final adminUser = UserModel(
        uid: 'demo_admin',
        name: 'SHRI Admin',
        email: 'admin@shri.com',
        phone: '9999999999',
        verificationStatus: 'approved',
      );
      await prefs.setString('user_demo_admin', jsonEncode(adminUser.toMap()));
      return adminUser;
    }

    if (isFirebaseEnabled) {
      final cred = await _fbAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _db!.collection('users').doc(cred.user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);
        if (user.isBlocked) {
          throw Exception("Your account has been suspended by the administrator.");
        }
        // Log login activity
        final updatedLog = List<Map<String, dynamic>>.from(user.activityLog);
        updatedLog.add({'action': 'Logged in', 'timestamp': DateTime.now().toIso8601String()});
        final updatedUser = user.copyWith(activityLog: updatedLog);
        await _db.collection('users').doc(user.uid).set(updatedUser.toMap(), SetOptions(merge: true));
        return updatedUser;
      }
      return UserModel(uid: cred.user!.uid, name: 'User', email: email, phone: '');
    } else {
      final prefs = await SharedPreferences.getInstance();
      final credentialsMap = jsonDecode(prefs.getString('mock_creds') ?? '{}');
      if (credentialsMap.containsKey(email)) {
        final storedPassword = credentialsMap[email]['password'];
        if (storedPassword == password) {
          final uid = credentialsMap[email]['uid'];
          _currentMockUserId = uid;
          await prefs.setString('mock_uid', uid);
          final userJson = prefs.getString('user_$uid');
          if (userJson != null) {
            final user = UserModel.fromMap(jsonDecode(userJson));
            if (user.isBlocked) {
              throw Exception("Your account has been suspended by the administrator.");
            }
            final updatedLog = List<Map<String, dynamic>>.from(user.activityLog);
            updatedLog.add({'action': 'Logged in (Simulated)', 'timestamp': DateTime.now().toIso8601String()});
            final updatedUser = user.copyWith(activityLog: updatedLog);
            await prefs.setString('user_$uid', jsonEncode(updatedUser.toMap()));
            return updatedUser;
          }
          return UserModel(uid: uid, name: 'Maya (Mock)', email: email, phone: '9988776655');
        }
      }
      throw Exception('Invalid email or password (simulated)');
    }
  }

  // Forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    if (isFirebaseEnabled) {
      await _fbAuth!.sendPasswordResetEmail(email: email);
    } else {
      // Simulate emailing password reset
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  // Logout
  Future<void> signOut() async {
    bypassFirebase = false;
    if (_isFirebaseEnabled) {
      await _fbAuth!.signOut();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mock_uid');
    _currentMockUserId = null;
  }

  // Fetch current user details
  Future<UserModel?> fetchUserProfile(String uid) async {
    if (isFirebaseEnabled) {
      final doc = await _db!.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_$uid');
      if (userJson != null) {
        return UserModel.fromMap(jsonDecode(userJson));
      }
      // Return a default demo profile if not found
      return UserModel(
        uid: uid,
        name: 'Maya',
        email: 'maya.safety@hutter.ai',
        phone: '+91 98765 43210',
        guardianIds: ['g1', 'g2'],
      );
    }
  }

  // Update profile
  Future<void> updateUserProfile(UserModel user) async {
    if (isFirebaseEnabled) {
      await _db!.collection('users').doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_${user.uid}', jsonEncode(user.toMap()));
    }
  }

  // Check if UID is admin
  Future<bool> checkIfAdmin(String uid) async {
    if (!isFirebaseEnabled) {
      // In local mode, default to admin if UID contains 'admin' or if it matches demo admin
      return uid == 'demo_admin' || uid.contains('admin');
    }
    try {
      final doc = await _db!.collection('admins').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }
}
