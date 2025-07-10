import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:run_balanced/firebase_options.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/screens/homepage_screen.dart';
import 'package:run_balanced/screens/profile_screen.dart';
import 'package:run_balanced/theme/theme_provider.dart';
import 'package:run_balanced/services/impact_api_service.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/simulation_provider.dart';
import 'package:run_balanced/theme/custom_page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ImpactApiService.loadSettings();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<UserProfileProvider, DataProvider>(
          create:
              (context) => DataProvider(
                Provider.of<UserProfileProvider>(context, listen: false),
              ),
          update:
              (context, userProfile, previousDataProvider) =>
                  previousDataProvider!..updateUserProfile(userProfile),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'runBalanced',
      theme: themeProvider.themeData.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
            TargetPlatform.linux: CustomPageTransitionBuilder(),
            TargetPlatform.macOS: CustomPageTransitionBuilder(),
            TargetPlatform.windows: CustomPageTransitionBuilder(),
          },
        ),
      ),
      // darkTheme: darkMode,
      // themeMode: ThemeMode.system,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<bool> _userDetailsExist(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return LoginScreen(); // Or LoginPage if you have one
        }

        return FutureBuilder<bool>(
          future: _userDetailsExist(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData && snapshot.data == true) {
              final userProfileProvider = Provider.of<UserProfileProvider>(
                context,
                listen: false,
              );
              userProfileProvider
                  .loadUserProfile(); // Safe to call multiple times
              return HomeScreen(); // Details exist
            } else {
              return ProfileScreen(); // First login, details missing
            }
          },
        );
      },
    );
  }
}
