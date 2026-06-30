import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/location_service.dart';
import 'services/speech_service.dart';
import 'services/chat_service.dart';
import 'services/fake_call_service.dart';
import 'state/auth_state.dart';
import 'state/app_state.dart';
import 'screens/splash.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Initialize communication port for background tasks
    FlutterForegroundTask.initCommunicationPort();
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase core optional fallback logic
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint(
      "Firebase init failed or missing config. Running local simulated mode: $e",
    );
  }

  // Create core service singletons
  final isFirebaseInitialized = Firebase.apps.isNotEmpty;
  final authService = AuthService(
    fbAuth: isFirebaseInitialized ? FirebaseAuth.instance : null,
    db: isFirebaseInitialized ? FirebaseFirestore.instance : null,
  );
  final dbService = FirestoreService(
    db: isFirebaseInitialized ? FirebaseFirestore.instance : null,
  );
  final locationService = LocationService();
  final speechService = SpeechService();
  final chatService = ChatService();
  final fakeCallService = FakeCallService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(authService),
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(
            dbService,
            locationService,
            speechService,
            chatService,
            fakeCallService,
          ),
        ),
      ],
      child: const ShriApp(),
    ),
  );
}

class ShriApp extends StatelessWidget {
  const ShriApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: const Color(0xFFF7F8FC),
    );

    return MaterialApp(
      title: 'SHRI – AI safety',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      ),
      home: const SplashInitializingScreen(),
    );
  }
}

/// ---------- Design Tokens ----------
class AppColors {
  static const bg = Color(0xFFF7F8FC);
  static const primaryBlue = Color(0xFF0A16B8);
  static const primaryBlueDark = Color(0xFF050E86);
  static const textDark = Color(0xFF0D0F1A);
  static const textMuted = Color(0xFF7E8497);
  static const border = Color(0xFFE7EAF3);
  static const chipBg = Color(0xFFF2F4FA);
  static const success = Color(0xFF23C16B);
  static const danger = Color(0xFFFF3B30);
  static const purple = Color(0xFF6A5CFF);
  static const pink = Color(0xFFFF5EA8);
}
