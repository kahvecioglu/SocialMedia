import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/auth/auth.dart';
import 'package:socialmedia/auth/login_register.dart';
import 'package:socialmedia/pages/register_page.dart';
import 'package:socialmedia/theme/theme_dark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyBGNKe2bP0vhECftaYmHyVVuSMM7NPV_sE",
          appId: "1:426319248495:android:d9f9602886d63cee99e19a",
          messagingSenderId: "426319248495",
          projectId: "fir-app-29fa1",
        ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeClass.lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: ThemeClass.darkTheme,
      home: const AuthPage(),
    );
  }
}
