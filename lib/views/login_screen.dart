// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:alpha_miles/views/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final fomrKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> signinWithEmail(
      String email, String password, BuildContext context) async {
    EasyLoading.show(status: 'Logging in');
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('admins')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
      if (querySnapshot.docs.first.data()['password'] == password) {
        await saveDataToSharedPrefs(email, password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Logged in successfully')));
        EasyLoading.dismiss();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffFF0000), content: Text('Invalid Credentials')));
        EasyLoading.dismiss();
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Color(0xffFF0000), content: Text(e.toString())));
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<void> saveDataToSharedPrefs(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('email', email);
    await sharedPreferences.setString('password', password);
  }

  Future<void> getPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString('email');
    String? password = sharedPreferences.getString('password');

    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      bool isLoggedIn = await signinWithEmail(email, password, context);
      if (isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          width: screenWidth * 0.6,
          height: screenHeight * 0.7,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                )
              ]),
          child: Form(
            key: fomrKey,
            child: Column(
              children: [
                Image.asset(width: screenWidth * 0.1, 'assets/logo/logo_2.png'),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email Address',
                    label: Text('Email Address'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Email Address can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    label: Text('Password'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Password can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (fomrKey.currentState!.validate()) {
                      signinWithEmail(emailController.text,
                              passwordController.text, context)
                          .then((value) {
                        if (value) {
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()));
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(double.infinity, 60),
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Color(0xffFF0000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
