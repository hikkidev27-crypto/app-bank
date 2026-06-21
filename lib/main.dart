import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/home_screen.dart';
import 'services/auth_service.dart';
import 'core/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
  } catch (e) {
    debugPrint("Firebase info: $e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MyApp(isFirebaseReady: firebaseInitialized),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirebaseReady;
  const MyApp({super.key, required this.isFirebaseReady});

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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: AuthWrapper(isFirebaseReady: isFirebaseReady),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final bool isFirebaseReady;
  const AuthWrapper({super.key, required this.isFirebaseReady});

  @override
  Widget build(BuildContext context) {
    if (!isFirebaseReady) {
      return const Scaffold(
        body: Center(
          child: Text("Firebase no configurado correctamente."),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si el usuario está autenticado, vamos directo al Home
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const OnboardingScreen();
          } else {
            return const HomeScreen();
          }
        }
        // Mientras carga el estado de la sesión
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
