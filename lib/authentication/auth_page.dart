import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_cart_1/user/user_bottom_navigation.dart';
import 'package:green_cart_1/utils/screens/onboarding_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BottomNavigationScreen();
          } else {
            return const OnboardingView();
          }
        },
      ),
    );
  }
}
