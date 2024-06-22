// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:alpha_miles/models/rider_model.dart';
import 'package:alpha_miles/views/riders_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alpha_miles/views/riders_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();

  List<RiderModel> searchResults = [];
  String searchQuery = '';

  @override
  void initState() {
    if (RiderModel.ridersList.isEmpty) {
      getRiders();
    }

    super.initState();
  }

  void getRiders() async {
    EasyLoading.show(status: 'Getting Riders');
    RiderModel.ridersList.clear();
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('riders').get();

      querySnapshot.docs.forEach((e) {
        RiderModel.ridersList.add(RiderModel.fromJson(e.data()));
      });
    } catch (e) {
      print("Error getting riders: $e");
    } finally {
      EasyLoading.dismiss();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Text(
                'Dashboard',
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                      )
                    ]),
                child: ListTile(
                  title: Text(
                    'Total Riders',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 24),
                  ),
                  trailing: Text(
                    RiderModel.ridersList.length.toString(),
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ],
          )),
          Container(
            width: 2,
            height: screenHeight,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  'Search Riders',
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rider Name/Emirates Id',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      if (value.isEmpty) {
                        searchResults.clear();
                      } else {
                        searchResults = RiderModel.ridersList.where((rider) {
                          return rider.fullName
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              rider.emiratesId
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase());
                        }).toList();
                      }
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final RiderModel riderModel = searchResults[index];
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20,
                                )
                              ]),
                          child: InkWell(
                            onTap: () {
                              RiderDetailsWidget(context, screenWidth,
                                  screenHeight, riderModel);
                            },
                            child: ListTile(
                              title: highlightSearchQuery(
                                riderModel.fullName.toString(),
                                searchQuery,
                                TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              subtitle: highlightSearchQuery(
                                riderModel.emiratesId.toString(),
                                searchQuery,
                                TextStyle(color: Colors.black),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  RichText highlightSearchQuery(
      String text, String query, TextStyle textStyle) {
    if (query.isEmpty) {
      return RichText(
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
      );
    }

    final matches = query.toLowerCase();
    final textParts = text.toLowerCase().split(matches);
    final highlighted = <TextSpan>[];

    int index = 0;
    textParts.forEach((part) {
      if (part.isNotEmpty) {
        highlighted.add(TextSpan(
            text: text.substring(index, index + part.length),
            style: textStyle));
        index += part.length;
      }

      if (index < text.length) {
        highlighted.add(TextSpan(
            text: text.substring(index, index + matches.length),
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
        index += matches.length;
      }
    });

    return RichText(
      text: TextSpan(children: highlighted),
    );
  }
}
