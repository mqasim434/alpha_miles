// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:html' as html;

import 'package:alpha_miles/models/rider_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RidersScreen extends StatefulWidget {
  const RidersScreen({super.key});

  @override
  State<RidersScreen> createState() => _RidersScreenState();
}

class _RidersScreenState extends State<RidersScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Text(
            'All Riders',
            style: TextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: RiderModel.ridersList.isNotEmpty
                ? ListView.builder(
                    itemCount: RiderModel.ridersList.length,
                    itemBuilder: (context, index) {
                      RiderModel riderModel = RiderModel.ridersList[index];
                      return InkWell(
                        onTap: () {
                          RiderDetailsWidget(
                              context, screenWidth, screenHeight, riderModel);
                        },
                        child: RiderTileWidget(
                          riderModel: riderModel,
                        ),
                      );
                    })
                : Center(
                    child: Text('No Riders Yet'),
                  ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> RiderDetailsWidget(BuildContext context, double screenWidth,
    double screenHeight, RiderModel riderModel) {
  return showDialog(
      context: context,
      builder: (context) {
        return Container(
          width: screenWidth * 0.5,
          height: screenHeight * 0.5,
          padding: EdgeInsets.all(50),
          margin: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    riderModel.imageUrl.toString()))),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        riderModel.fullName.toString(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Rider Id',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.riderId.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Emirates Id',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.emiratesId.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'License No',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.liscenceNumber.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Location',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.location.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Location',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.location.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Salary Password',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.salaryPassword.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Emirates Id Expiry Date',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.emiratesIdExpiryDate.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'License Number Expiry Date',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              subtitle: Text(
                                riderModel.liscenceNumberExpiryDate.toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )),
              Container(
                height: screenHeight,
                width: 2,
                color: Colors.grey,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Rider Documents',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: riderModel.documenstUrlsList!.isNotEmpty
                          ? ListView.builder(
                              itemCount: riderModel.documenstUrlsList!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: DottedBorder(
                                    child: ListTile(
                                      title: Text(riderModel
                                          .documenstUrlsList![index]
                                          .keys
                                          .first),
                                      trailing: TextButton(
                                        onPressed: () {
                                          html.AnchorElement anchorElement =
                                              html.AnchorElement(
                                                  href: riderModel
                                                      .documenstUrlsList![index]
                                                      .values
                                                      .first)
                                                ..setAttribute(
                                                    "target", "_blank");
                                          anchorElement.setAttribute(
                                              "download",
                                              riderModel
                                                  .documenstUrlsList![index]
                                                  .keys
                                                  .first);
                                          anchorElement.click();
                                        },
                                        child: Text('Download'),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: Text('No Documents Found'),
                            ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close_rounded),
                  ),
                ],
              )
            ],
          ),
        );
      });
}

class RiderTileWidget extends StatefulWidget {
  const RiderTileWidget({super.key, required this.riderModel});

  final RiderModel riderModel;

  @override
  State<RiderTileWidget> createState() => _RiderTileWidgetState();
}

class _RiderTileWidgetState extends State<RiderTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 20),
          ]),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.riderModel.imageUrl.toString()),
            ),
            title: Text(widget.riderModel.fullName.toString()),
            subtitle: Text('Emirates ID: ${widget.riderModel.emiratesId}'),
            trailing: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure to delete the Rider?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  EasyLoading.show(status: 'Deleting');
                                  QuerySnapshot<Map<String, dynamic>>
                                      querySnapshot = await FirebaseFirestore
                                          .instance
                                          .collection('riders')
                                          .where('riderId',
                                              isEqualTo: widget
                                                  .riderModel.riderId
                                                  .toString())
                                          .limit(1)
                                          .get();

                                  await FirebaseFirestore.instance
                                      .collection('riders')
                                      .doc(querySnapshot.docs.first.id)
                                      .delete()
                                      .then((value) {
                                    Navigator.pop(context);
                                  }).then((value) async {
                                    QuerySnapshot<Map<String, dynamic>>
                                        querySnapshot = await FirebaseFirestore
                                            .instance
                                            .collection('riders')
                                            .get();

                                    setState(() {
                                      if (querySnapshot.docs.isNotEmpty) {
                                        RiderModel.ridersList = querySnapshot
                                            .docs
                                            .map((e) =>
                                                RiderModel.fromJson(e.data()))
                                            .toList();
                                      } else {
                                        RiderModel.ridersList = [];
                                      }
                                    });
                                  });
                                  EasyLoading.dismiss();
                                } catch (e) {
                                  EasyLoading.dismiss();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: CircleAvatar(child: Icon(Icons.delete))),
          )
        ],
      ),
    );
  }
}
