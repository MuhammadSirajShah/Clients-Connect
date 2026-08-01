import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/screens/auth/email_verification_screen.dart';
import 'package:client_connect/screens/auth/login_screen.dart';
import 'package:client_connect/screens/home/home_screen.dart';
import 'package:client_connect/screens/navigation/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthProvider>().authStateChanges,
      builder: (context, snapshot) {
        // Firebase authentication check
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data;

        // User logged out
        if (user == null) {
          return const LoginScreen();
        }

        // User logged in but email not verified
        if (!user.emailVerified) {
          return const EmailVerificationScreen();
        }

        // User logged in and email verified
        return const BottomNavScreen();
      },
    );
  }
}