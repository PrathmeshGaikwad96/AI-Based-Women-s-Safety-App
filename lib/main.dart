import 'package:basic/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const ShriApp());
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