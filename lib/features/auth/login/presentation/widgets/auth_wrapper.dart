import 'package:chat_app/features/auth/login/presentation/pages/login_screen.dart';
import 'package:chat_app/features/home/presentation/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user logged in show home
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // If user not logged in, show login
        return const LoginScreen();
      },
    );
  }
}
