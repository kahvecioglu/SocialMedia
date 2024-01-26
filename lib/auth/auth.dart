import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/auth/login_register.dart';
import 'package:socialmedia/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // kullanıcı oturum açtı
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
