import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_crud_with_model/page/sign_in.dart';
import '../page/home_page.dart';
import 'package:flutter/material.dart';

import 'authentication_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const AuthenticationScreen();
        }
      },
    );
  }
}
