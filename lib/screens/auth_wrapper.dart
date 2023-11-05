import 'package:flutter/material.dart';
import 'package:oyatest/screens/auth_screen.dart';
import 'package:oyatest/screens/home_screen/home_screen.dart';
import 'package:oyatest/services/auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.i.authState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.data == null) {
            return const AuthScreen();
          } else {
            return const HomeScreen();
          }
        });
  }
}
