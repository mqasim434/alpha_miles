// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:alpha_miles/views/dashboard.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final fomrKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                      emailController.clear();
                      passwordController.clear();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(double.infinity, 60),
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Colors.red,
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
