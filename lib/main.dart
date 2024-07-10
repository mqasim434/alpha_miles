// ignore_for_file: prefer_const_constructors
import 'package:alpha_miles/views/dashboard.dart';
import 'package:alpha_miles/views/login_screen.dart';
import 'package:alpha_miles/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyD24tOXpREon3i537WvvwxHAsSrqaJbZBo',
        appId: '1:605280860204:web:38b902a94681d4fdb63989',
        messagingSenderId: '605280860204',
        projectId: 'alpha-miles-6cf46',
        storageBucket: 'gs://alpha-miles-6cf46.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Miles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: SigninScreen(),
    );
  }
}
