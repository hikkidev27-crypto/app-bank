import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ui/screens/login_screen.dart';
import 'services/auth_service.dart';
import 'core/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint("Firebase initialization error: $e");
    }
  } else {
    debugPrint("Firebase is not fully supported on this platform by this implementation yet.");
  }
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          secondary: AppColors.secondary,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
