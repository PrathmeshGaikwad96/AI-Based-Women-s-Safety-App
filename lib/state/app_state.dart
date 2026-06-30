import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/background_voice_service.dart';
import '../models/alert_model.dart';
import '../models/unsafe_place.dart';
import '../models/scheme_model.dart';
import '../models/rights_model.dart';
import '../models/guardian_model.dart';
import '../models/chat_message.dart';
import '../models/user_model.dart';
import '../models/nearby_place.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../services/speech_service.dart';
import '../services/chat_service.dart';
import '../services/fake_call_service.dart';
import '../services/overpass_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AppState extends ChangeNotifier {
  final FirestoreService _dbService;
  final LocationService _locationService;
  final SpeechService _speechService;
  final ChatService _chatService;
  final FakeCallService _fakeCallService;
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();

  // User parameters
  String? _currentUserId;

  // Location parameters
  Position? _currentPosition;
  String _currentAddress = 'Fetching current address...';
  double _safetyScore = 98.0;
  UnsafePlace? _nearbyThreat;
  bool _isEnteringThreat = false;
  StreamSubscription<Position>? _locationSub;
  Position? _lastGeocodedPosition;

  // Overpass and tracking parameters
  final OverpassService _overpassService = OverpassService();
  List<LatLng> _routeCoordinates = [];
  List<NearbyPlace> _nearbyPlaces = [];
  List<Position> _historicalCoordinates = [];
  LatLng? _guardianPosition;
  Timer? _guardianSimTimer;
  bool _isFetchingNearby = false;

  // AI Prediction parameters
  double _aiRiskPredictionScore = 0.0;
  String _aiPredictionSummary = "No anomalies detected on path.";
  List<LatLng> _predictedDangerHotspots = [];

  // Databases Lists
  List<UnsafePlace> _unsafePlaces = [];
  List<RightsModel> _rights = [];
  List<SchemeModel> _schemes = [];
  List<GuardianModel> _guardians = [];
  List<AlertModel> _alertsHistory = [];
  List<ChatMessage> _chatHistory = [];
  List<String> _wishlistIds = [];

  // SOS parameters
  bool _isSosActive = false;
  AlertModel? _activeAlert;
  int _sosCountdown = 5;
  Timer? _countdownTimer;

  // Speech monitoring
  bool _isVoiceSosEnabled = false;
  String _lastRecognizedWords = '';

  // Safety local notifications feed
  List<Map<String, dynamic>> _localNotifications = [];
  List<Map<String, dynamic>> get localNotifications => _localNotifications;

  // Getters
  FirestoreService get dbService => _dbService;
  String? get currentUserId => _currentUserId;
  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  double get safetyScore => _safetyScore;
  UnsafePlace? get nearbyThreat => _nearbyThreat;
  bool get isEnteringThreat => _isEnteringThreat;

  List<UnsafePlace> get unsafePlaces => _unsafePlaces;
  List<RightsModel> get rights => _rights;
  List<SchemeModel> get schemes => _schemes;
  List<GuardianModel> get guardians => _guardians;
  List<AlertModel> get alertsHistory => _alertsHistory;
  List<ChatMessage> get chatHistory => _chatHistory;
  List<String> get wishlistIds => _wishlistIds;

  bool get isSosActive => _isSosActive;
  AlertModel? get activeAlert => _activeAlert;
  int get sosCountdown => _sosCountdown;

  List<LatLng> get routeCoordinates => _routeCoordinates;
  List<NearbyPlace> get nearbyPlaces => _nearbyPlaces;
  List<Position> get historicalCoordinates => _historicalCoordinates;
  LatLng? get guardianPosition => _guardianPosition;
  bool get isFetchingNearby => _isFetchingNearby;
  double get aiRiskPredictionScore => _aiRiskPredictionScore;
  String get aiPredictionSummary => _aiPredictionSummary;
  List<LatLng> get predictedDangerHotspots => _predictedDangerHotspots;

  bool get isVoiceSosEnabled => _isVoiceSosEnabled;
  String get lastRecognizedWords => _lastRecognizedWords;
  FakeCallService get fakeCallService => _fakeCallService;

  AppState(
    this._dbService,
    this._locationService,
    this._speechService,
    this._chatService,
    this._fakeCallService,
  ) {
    _loadData();
    _startLocationTracking();
    _initChat();
    if (!kIsWeb) {
      _initForegroundTask();
      FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    }
  }

  // Reload data from DB
  Future<void> _loadData() async {
    await _dbService.preseedDataIfNeeded();
    await _loadNotifications();

    _unsafePlaces = await _dbService.fetchUnsafePlaces();
    _rights = await _dbService.fetchRights();
    _schemes = await _dbService.fetchSchemes();
    if (_currentUserId != null) {
      _guardians = await _dbService.fetchCircle(_currentUserId!);
    } else {
      _guardians = [];
    }
    _alertsHistory = await _dbService.fetchAlertsHistory();

    // Load voice SOS enabled state from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      _isVoiceSosEnabled = prefs.getBool('is_voice_sos_enabled') ?? false;
      if (_isVoiceSosEnabled && !kIsWeb) {
        // Ensure background keep-alive task is running
        final running = await FlutterForegroundTask.isRunningService;
        if (!running) {
          await FlutterForegroundTask.startService(
            serviceId: 100,
            notificationTitle: 'SHRI Sentinel Active',
            notificationText: 'Monitoring microphone for safety keywords...',
            callback: startCallback,
            serviceTypes: [ForegroundServiceTypes.microphone],
          );
        }
      }
    } catch (e) {
      print("Error initializing voice SOS on startup: $e");
    }

    notifyListeners();
  }

  // Load user specific data
  Future<void> loadUserData(String? userId) async {
    if (userId == null) {
      _currentUserId = null;
      _guardians = [];
      notifyListeners();
      return;
    }
    if (_currentUserId == userId) return;
    _currentUserId = userId;

    // Cache user ID to SharedPreferences for background service access
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mock_uid', userId);
      await prefs.setString('current_user_id', userId);
    } catch (e) {
      print("Failed to save user ID to SharedPreferences: $e");
    }

    _guardians = await _dbService.fetchCircle(userId);
    notifyListeners();
  }

  // Initialize chatbot chat introduction
  void _initChat() {
    _chatHistory = [
      ChatMessage(
        id: 'init_msg',
        text:
            "I'm SHRI, your smart AI safety assistant. I'm currently tracking your surroundings in real-time. How can I help you today?",
        sender: 'ai',
        timestamp: DateTime.now(),
        suggestionPills: [
          "Check Safety Score",
          "Unsafe Zones Near Me",
          "Simulate Fake Call",
        ],
      ),
    ];
    notifyListeners();
  }

  // Location Stream tracking
  void _startLocationTracking() async {
    final permissionOk = await _locationService.handlePermission();
    if (!permissionOk) {
      _currentAddress = 'Permission denied (using simulated coords)';
    }

    final initPos = await _locationService.getCurrentLocation();
    _updatePosition(initPos);

    _locationSub = _locationService.getPositionStream().listen((pos) {
      _updatePosition(pos);
    });
  }

  void _updatePosition(Position pos) async {
    _currentPosition = pos;

    // Set approximate first to show something immediately, then fetch real
    if (_currentAddress == 'Fetching current address...' ||
        _currentAddress.startsWith('Permission denied') ||
        _currentAddress.startsWith('Shivajinagar') ||
        _currentAddress.startsWith('Near SPPU') ||
        _currentAddress.startsWith('Model Colony') ||
        _currentAddress.startsWith('FC Road') ||
        _currentAddress.startsWith('Swargate')) {
      _currentAddress = _locationService.getApproximateAddress(
        pos.latitude,
        pos.longitude,
      );
    }

    // Add coordinate to user route path
    final latLng = LatLng(pos.latitude, pos.longitude);
    if (_routeCoordinates.isEmpty || _routeCoordinates.last != latLng) {
      _routeCoordinates.add(latLng);
      _historicalCoordinates.add(pos);

      // Keep route coordinates within a reasonable limit to prevent performance lag (e.g. 500 points)
      if (_routeCoordinates.length > 500) {
        _routeCoordinates.removeAt(0);
      }
    }

    // Dynamic Threat detection (Pune Unsafe coordinates)
    final threat = _locationService.getActiveThreat(pos, _unsafePlaces);
    if (threat != null) {
      final wasInThreat = _isEnteringThreat;
      final oldThreat = _nearbyThreat;
      _nearbyThreat = threat;
      _isEnteringThreat = true;

      final double oldScore = _safetyScore;
      // Reduce safety score dynamically based on risk level
      if (threat.riskLevel == 'High Risk') {
        _safetyScore = 55.0;
      } else {
        _safetyScore = 78.0;
      }
      if (oldScore != _safetyScore) {
        addNotification(
          title: "Safety Score Dropped",
          body:
              "Your safety score is now ${_safetyScore.round()}% due to nearby threats.",
          type: "info",
        );
      }

      // If new entry or entered a different threat zone
      if (!wasInThreat || oldThreat?.id != threat.id) {
        _startThreatAlarm(threat);
        addNotification(
          title: "Risk Zone Entered",
          body:
              "Entered ${threat.name} (${threat.riskLevel}). Alerting nearby systems.",
          type: "safe_zone",
        );
      } else if (_routeCoordinates.length % 3 == 0) {
        HapticFeedback.vibrate();
        HapticFeedback.heavyImpact();
      }
    } else {
      if (_isEnteringThreat) {
        _stopThreatAlarm();
        addNotification(
          title: "Risk Zone Exited",
          body: "You have safely exited the high risk area.",
          type: "system",
        );
      }
      final double oldScore = _safetyScore;
      _nearbyThreat = null;
      _isEnteringThreat = false;
      _safetyScore = 98.0;
      if (oldScore != _safetyScore) {
        addNotification(
          title: "Safety Score Restored",
          body: "Safety score restored to 98% (Secure).",
          type: "info",
        );
      }
    }

    // Sync live location to Firebase Firestore if SOS mode is active
    if (_isSosActive && _activeAlert != null) {
      _dbService.saveLiveLocation(
        _activeAlert!.userId,
        pos.latitude,
        pos.longitude,
        _activeAlert!.batteryLevel,
      );
    }

    // AI Danger Zone Prediction based on coordinates density and proximity to historical hotspots
    _predictDangerZones(pos);

    // Auto-fetch nearby emergency services if they change significantly (e.g. user moves 200m)
    if (_nearbyPlaces.isEmpty) {
      fetchNearbyEmergencyServices(pos.latitude, pos.longitude);
    }

    notifyListeners();

    // Fetch real address asynchronously if it's moved significantly or has not been fetched yet
    if (_lastGeocodedPosition == null ||
        Geolocator.distanceBetween(
              _lastGeocodedPosition!.latitude,
              _lastGeocodedPosition!.longitude,
              pos.latitude,
              pos.longitude,
            ) >
            15) {
      _lastGeocodedPosition = pos;
      try {
        final address = await _locationService.getRealAddress(
          pos.latitude,
          pos.longitude,
        );
        if (address.isNotEmpty &&
            _currentPosition?.latitude == pos.latitude &&
            _currentPosition?.longitude == pos.longitude) {
          _currentAddress = address;
          notifyListeners();
        }
      } catch (e) {
        print("Error fetching real address: $e");
      }
    }
  }

  void _startThreatAlarm(UnsafePlace threat) async {
    try {
      // Stop any existing ringing first
      await _ringtonePlayer.stop();
      // Play alarm sound looping
      await _ringtonePlayer.playAlarm(looping: true, asAlarm: true);
    } catch (e) {
      print("Error playing alarm: $e");
    }

    // Trigger intense haptics
    HapticFeedback.vibrate();
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 500), () {
      HapticFeedback.vibrate();
      HapticFeedback.heavyImpact();
    });

    // Update foreground task notification with warning text
    try {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.updateService(
          notificationTitle: '🚨 DANGER: Entering ${threat.riskLevel}!',
          notificationText:
              'You entered ${threat.name}. Stay alert and seek safety!',
        );
      }
    } catch (e) {
      print("Error updating foreground service: $e");
    }
  }

  void _stopThreatAlarm() async {
    try {
      await _ringtonePlayer.stop();
    } catch (e) {
      print("Error stopping ringtone: $e");
    }

    // Reset the foreground notification back to normal
    try {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.updateService(
          notificationTitle: 'SHRI Sentinel Active',
          notificationText: 'Monitoring microphone for safety keywords...',
        );
      }
    } catch (e) {
      print("Error resetting foreground notification: $e");
    }
  }

  // --- SOS METHODS ---
  void startSOSCountdown(UserModel? user, Function() onCountdownFinished) {
    cancelSOSCountdown();
    _sosCountdown = 5;
    _isSosActive = true;
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sosCountdown > 1) {
        _sosCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
        _sosCountdown = 0;
        triggerSOS(user);
        onCountdownFinished();
      }
    });
  }

  void cancelSOSCountdown() {
    if (_countdownTimer != null && _countdownTimer!.isActive) {
      _countdownTimer!.cancel();
    }
    _isSosActive = false;
    _sosCountdown = 5;
    notifyListeners();
  }

  Future<void> triggerSOS(UserModel? user, {bool isVoice = false}) async {
    _isSosActive = true;
    _sosCountdown = 0;
    final pos =
        _currentPosition ??
        Position(
          longitude: 73.8567,
          latitude: 18.5204,
          timestamp: DateTime.now(),
          accuracy: 100,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );

    final alert = AlertModel(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.uid ?? 'demo_user',
      userName: user?.name ?? 'Maya',
      timestamp: DateTime.now(),
      latitude: pos.latitude,
      longitude: pos.longitude,
      address: _currentAddress,
      batteryLevel: user?.batteryLevel ?? 100,
      status: 'active',
      isVoiceTriggered: isVoice,
      aiMonitoringStatus: 'SOS Broadcasted. Contacting safety circle.',
    );

    _activeAlert = alert;
    notifyListeners();
    await _dbService.triggerAlert(alert);

    // Try sending SMS alerts via telephony in the background
    try {
      final Telephony telephony = Telephony.instance;
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      if (permissionsGranted == true) {
        final locationLink =
            "https://www.google.com/maps/?q=${pos.latitude},${pos.longitude}";
        final userName = user?.name ?? 'Maya';
        final message =
            "EMERGENCY ALERT: $userName is in danger! Live Location: $locationLink";

        for (final guardian in _guardians) {
          if (guardian.phone.trim().isNotEmpty) {
            await telephony.sendSms(
              to: guardian.phone.trim(),
              message: message,
            );
            print("SMS alert sent to ${guardian.name} (${guardian.phone})");
          }
        }
      } else {
        print("SMS permissions were not granted; cannot send emergency SMS.");
      }
    } catch (e) {
      print("Failed to send SMS: $e");
    }

    // Sync live location to Firebase Firestore & start simulated guardian movement
    await _dbService.saveLiveLocation(
      alert.userId,
      pos.latitude,
      pos.longitude,
      alert.batteryLevel,
    );
    _startGuardianSimulation(pos);

    await addNotification(
      title: "SOS Alert Activated",
      body: "Emergency alert sent to safety circle and local authorities.",
      type: "sos",
    );
    await _loadData(); // Reload history log
  }

  Future<void> cancelSOS(String pin) async {
    if (_activeAlert != null) {
      await _dbService.resolveAlert(
        _activeAlert!.id,
        'Emergency resolved by user with secure PIN verification.',
      );
      await _dbService.deleteLiveLocation(_activeAlert!.userId);
      _activeAlert = null;
    }
    _stopGuardianSimulation();
    await addNotification(
      title: "SOS Alert Resolved",
      body: "Safety status set back to secure.",
      type: "system",
    );
    _isSosActive = false;
    _sosCountdown = 5;
    await _loadData();
  }

  // --- Simulating Guardian live tracking movement towards user during SOS ---
  void _startGuardianSimulation(Position userPos) {
    _guardianSimTimer?.cancel();

    // Start guardian about 600m northeast of the user
    double gLat = userPos.latitude + 0.005;
    double gLng = userPos.longitude + 0.004;
    _guardianPosition = LatLng(gLat, gLng);

    _guardianSimTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPosition == null) return;

      final double targetLat = _currentPosition!.latitude;
      final double targetLng = _currentPosition!.longitude;

      final double dLat = targetLat - gLat;
      final double dLng = targetLng - gLng;
      final double distance = Geolocator.distanceBetween(
        gLat,
        gLng,
        targetLat,
        targetLng,
      );

      if (distance < 20) {
        // Guardian arrived
        _guardianPosition = LatLng(targetLat, targetLng);
        timer.cancel();
      } else {
        // Walk 15% of the distance closer
        gLat += dLat * 0.15;
        gLng += dLng * 0.15;
        _guardianPosition = LatLng(gLat, gLng);
      }
      notifyListeners();
    });
  }

  void _stopGuardianSimulation() {
    _guardianSimTimer?.cancel();
    _guardianPosition = null;
  }

  // --- Overpass emergency service retrieval ---
  Future<void> fetchNearbyEmergencyServices(double lat, double lng) async {
    _isFetchingNearby = true;
    notifyListeners();
    try {
      _nearbyPlaces = await _overpassService.fetchNearbyPlaces(lat, lng);
    } catch (e) {
      print('Error fetching overpass nodes: $e');
    } finally {
      _isFetchingNearby = false;
      notifyListeners();
    }
  }

  // --- AI Danger Zone Prediction ---
  void _predictDangerZones(Position currentPos) {
    int nearbyIncidents = 0;
    _predictedDangerHotspots.clear();

    for (final place in _unsafePlaces) {
      final distance = Geolocator.distanceBetween(
        currentPos.latitude,
        currentPos.longitude,
        place.latitude,
        place.longitude,
      );

      // If within 800m of a Pune threat, flag as hotspot
      if (distance <= 800) {
        nearbyIncidents += place.incidentCount;
        _predictedDangerHotspots.add(LatLng(place.latitude, place.longitude));
      }
    }

    final currentHour = DateTime.now().hour;
    final isNight = currentHour >= 20 || currentHour <= 5;

    double riskScore = 0.0;
    if (nearbyIncidents > 0) {
      riskScore += (nearbyIncidents * 1.8).clamp(0.0, 65.0);
    }
    if (isNight) {
      riskScore += 25.0;
    }

    _aiRiskPredictionScore = riskScore.clamp(0.0, 100.0);

    if (_aiRiskPredictionScore > 75) {
      _aiPredictionSummary =
          "High danger prediction: Isolated night corridor with $nearbyIncidents local incidents. Alert active.";
    } else if (_aiRiskPredictionScore > 40) {
      _aiPredictionSummary =
          "Moderate risk forecast: Nearby dark zones ($nearbyIncidents incidents). Keep on main roads.";
    } else {
      _aiPredictionSummary =
          "Low risk forecast: Safe route clusters detected. No anomalies on current path.";
    }
  }

  // --- SPEECH SOS METHODS ---
  Future<void> toggleVoiceSOS(UserModel? user, bool enable) async {
    _isVoiceSosEnabled = enable;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_voice_sos_enabled', enable);
    } catch (e) {
      print("Error saving voice SOS preference: $e");
    }

    if (enable) {
      // Request necessary microphone, notification, and SMS permissions
      final micStatus = await Permission.microphone.request();
      await Permission.notification.request();
      try {
        await Telephony.instance.requestPhoneAndSmsPermissions;
      } catch (e) {
        print("Error requesting SMS/Phone permissions: $e");
      }

      if (micStatus.isGranted) {
        // Request ignore battery optimization to ensure persistent background tracking
        await Permission.ignoreBatteryOptimizations.request();

        try {
          if (await FlutterForegroundTask.isRunningService) {
            await FlutterForegroundTask.stopService();
          }

          await FlutterForegroundTask.startService(
            serviceId: 100,
            notificationTitle: 'SHRI Sentinel Active',
            notificationText: 'Monitoring microphone for safety keywords...',
            callback: startCallback,
            serviceTypes: [ForegroundServiceTypes.microphone],
          );
        } catch (e) {
          print("Failed to start background voice service: $e");
        }
      } else {
        _isVoiceSosEnabled = false;
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_voice_sos_enabled', false);
        } catch (_) {}
        print(
          "Microphone permission denied; cannot start background voice monitoring.",
        );
      }
    } else {
      try {
        if (await FlutterForegroundTask.isRunningService) {
          await FlutterForegroundTask.stopService();
        }
      } catch (e) {
        print("Failed to stop background voice service: $e");
      }
      _speechService.stopListening();
      _lastRecognizedWords = '';
    }
    notifyListeners();
  }

  // --- CHAT DIALOGUE METHODS ---
  Future<void> sendChatMessage(String text) async {
    final userMsg = ChatMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
    );

    _chatHistory.add(userMsg);
    notifyListeners();

    // AI thinking response
    final response = await _chatService.getAIResponse(
      text,
      schemes: _schemes.map((s) => s.toMap()).toList(),
      rights: _rights.map((r) => r.toMap()).toList(),
    );
    _chatHistory.add(response);
    notifyListeners();
  }

  // --- SAFETY STORE WISHLIST ---
  void toggleWishlist(String productId) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }

  // --- GUARDIAN CIRCLE MANAGE ---
  Future<void> addNewGuardian(
    String name,
    String phone,
    String relation,
  ) async {
    final userId = _currentUserId ?? 'demo_user';
    final g = GuardianModel(
      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      relation: relation,
    );
    await _dbService.addGuardian(userId, g);
    await _loadData();
  }

  Future<void> removeCircleGuardian(String id) async {
    final userId = _currentUserId ?? 'demo_user';
    await _dbService.removeGuardian(userId, id);
    await _loadData();
  }

  // --- ADMIN ZONE MANAGEMENT ---
  Future<void> adminAddUnsafePlace(
    String name,
    double lat,
    double lng,
    double radius,
    String riskLevel,
    String desc,
  ) async {
    final zone = UnsafePlace(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      latitude: lat,
      longitude: lng,
      radius: radius,
      riskLevel: riskLevel,
      description: desc,
      incidentCount: 1,
    );
    await _dbService.addUnsafePlace(zone);
    await _loadData();
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'shri_voice_sos',
        channelName: 'SHRI Sentinel - Voice Trigger',
        channelDescription:
            'Monitors microphone for safety keywords in the background.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        playSound: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  void _onReceiveTaskData(Object data) {
    if (data is Map) {
      final action = data['action'];
      if (action == 'trigger_sos') {
        print("🚨 SOS TRIGGER RECEIVED FROM BACKGROUND SERVICE ISOLATE!");
        final isVoice = data['isVoice'] == true;
        if (!_isSosActive) {
          final uid = data['userId'] ?? _currentUserId ?? 'demo_user';
          final dummyUser = UserModel(
            uid: uid,
            name: _currentUserId == uid && _guardians.isNotEmpty
                ? _guardians.first.name
                : 'Maya',
            email: '',
            phone: '',
          );
          triggerSOS(dummyUser, isVoice: isVoice);
        }
      }
    }
  }

  // --- LOCAL SAFETY NOTIFICATIONS HELPERS ---
  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('local_safety_notifications') ?? [];
      _localNotifications = list
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error loading local notifications: $e");
    }
  }

  Future<void> _saveNotificationsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _localNotifications.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList('local_safety_notifications', list);
    } catch (e) {
      print("Error saving local notifications: $e");
    }
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    final notif = {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'body': body,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
    };
    _localNotifications.insert(0, notif);
    notifyListeners();
    await _saveNotificationsToPrefs();
  }

  Future<void> clearNotifications() async {
    _localNotifications.clear();
    notifyListeners();
    await _saveNotificationsToPrefs();
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _countdownTimer?.cancel();
    _speechService.stopListening();
    _stopThreatAlarm();
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }
}
