// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:html' as html;

import 'package:alpha_miles/models/rider_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class SearchSalaryScreen extends StatefulWidget {
  const SearchSalaryScreen({Key? key});

  @override
  State<SearchSalaryScreen> createState() => _SearchSalaryScreenState();
}

class _SearchSalaryScreenState extends State<SearchSalaryScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, dynamic>? searchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Search Salary',
            style: TextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          MyTextField(
              label: 'Rider Id',
              icon: Icons.perm_identity,
              controller: idController),
          MyTextField(
              label: 'Salary Password',
              icon: Icons.lock,
              controller: passwordController),
          ElevatedButton(
            onPressed: () async {
              EasyLoading.show(status: 'Searching');
              DateTime now = DateTime.now();
              String monthName =
                  DateFormat.MMMM().format(now); // e.g., "January"
              int year = now.year; // e.g., 2024

              // Construct the document ID
              String documentId = '$monthName-$year';
              try {
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance
                        .collection('salaries')
                        .doc(documentId)
                        .collection(documentId)
                        .where('riderId', isEqualTo: idController.text)
                        .limit(1)
                        .get();

                QuerySnapshot<Map<String, dynamic>> riderInfo =
                    await FirebaseFirestore.instance
                        .collection('riders')
                        .where('riderId', isEqualTo: idController.text)
                        .limit(1)
                        .get();

                if (querySnapshot.docs.isNotEmpty &&
                    riderInfo.docs.isNotEmpty) {
                  Map<String, dynamic> data = querySnapshot.docs.first.data();
                  String storedPassword =
                      riderInfo.docs.first.data()['salaryPassword'];

                  if (passwordController.text == storedPassword) {
                    setState(() {
                      searchResults = data;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Incorrect Salary Password'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok'),
                            )
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Salary Not Found'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Ok'),
                          )
                        ],
                      );
                    },
                  );
                }
                EasyLoading.dismiss();
              } catch (e) {
                EasyLoading.dismiss();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('An error occurred while searching.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Ok'),
                        )
                      ],
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffFF0000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.5,
                60,
              ),
            ),
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          searchResults != null
              ? Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Results',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Rider id: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            searchResults!['riderId'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Salary Month: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${searchResults!['month']} - ${searchResults!['year']}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Salary Slip: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (searchResults != null &&
                                  searchResults!['salarySlipUrl'] != null) {
                                html.AnchorElement anchorElement =
                                    html.AnchorElement(
                                        href: searchResults!['salarySlipUrl'])
                                      ..setAttribute("target", "_blank");
                                anchorElement.click();
                              } else {
                                // Handle the case where searchResults or salarySlipUrl is null
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content:
                                          Text("No salary slip URL available."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFF0000),),
                            child: Text(
                              'View Salary Slip',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.label,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: label == 'Salary Password',
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Field can't be empty";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
