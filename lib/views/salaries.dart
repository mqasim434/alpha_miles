// ignore_for_file: prefer_const_constructors

import 'dart:html' as html;
import 'dart:typed_data';
import 'package:alpha_miles/views/add_rider_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class SalariesScreen extends StatefulWidget {
  const SalariesScreen({super.key});

  @override
  State<SalariesScreen> createState() => _SalariesScreenState();
}

class _SalariesScreenState extends State<SalariesScreen> {
  TextEditingController riderIdController = TextEditingController();
  List<html.File>? _salaryfiles;

  Future<void> addRiderSalary(String riderId, String salarySlipUrl) async {
    EasyLoading.show(status: 'Adding');

    DateTime now = DateTime.now();
    String monthName = DateFormat.MMMM().format(now);
    int year = now.year;

    String documentId = '$monthName-$year';

    CollectionReference salariesCollection =
        FirebaseFirestore.instance.collection('salaries');

    Map<String, dynamic> salaryData = {
      'riderId': riderId,
      'month': monthName,
      'year': year,
      'salarySlipUrl': salarySlipUrl,
    };

    try {
      await salariesCollection
          .doc(documentId)
          .collection(documentId)
          .add(salaryData);
      print('Salary added successfully');
    } catch (e) {
      print('Failed to add salary: $e');
    }
    EasyLoading.dismiss();
  }

  void _pickFiles() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = ''; // You can set file types here, e.g., 'image/*'
    uploadInput.multiple = false;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null) {
        setState(() {
          _salaryfiles = files.toList();
        });
      }
    });
  }

  Future<String> uploadSalaryDocument(html.File salaryDocument) async {
    EasyLoading.show(status: 'Uploading');
    try {
      String fileName = salaryDocument.name;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(salaryDocument);

      await reader.onLoadEnd.first;

      if (reader.result != null) {
        final Uint8List bytes = reader.result as Uint8List;

        Reference storageReference =
            FirebaseStorage.instance.ref().child('salarySlips/$fileName');

        UploadTask uploadTask = storageReference.putData(
          bytes,
          SettableMetadata(contentType: salaryDocument.type),
        );

        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        EasyLoading.dismiss();
        return downloadURL;
      } else {
        throw Exception("Error reading file.");
      }
    } catch (e) {
      print("Error uploading file: $e");
      EasyLoading.dismiss();
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Text(
            'Add Salary',
            style: TextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          MyTextField(
            label: 'Rider Id',
            icon: Icons.perm_identity,
            controller: riderIdController,
          ),
          InkWell(
            onTap: () {
              _pickFiles();
            },
            child: DottedBorder(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text('Upload Salary Slip')),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Chip(
            label: _salaryfiles != null
                ? Text(_salaryfiles!.first.name)
                : Text('No File Selected'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: (_salaryfiles != null && _salaryfiles!.isNotEmpty)
                ? () {
                    uploadSalaryDocument(_salaryfiles!.first).then((value) {
                      if (value != 'error') {
                        addRiderSalary(riderIdController.text, value);
                      }
                    });
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Select a File"),
                          );
                        });
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
              'Add Salary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
