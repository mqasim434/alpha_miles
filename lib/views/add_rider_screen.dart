// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:alpha_miles/models/rider_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddRiderScreen extends StatefulWidget {
  const AddRiderScreen({super.key});

  @override
  State<AddRiderScreen> createState() => _AddRiderScreenState();
}

class _AddRiderScreenState extends State<AddRiderScreen> {
  List<html.File>? _files;
  String? pickedImageUrl;

  TextEditingController nameController = TextEditingController();
  TextEditingController riderIdController = TextEditingController();
  TextEditingController emiratesIdController = TextEditingController();
  TextEditingController emiratesIdExpiryDateController =
      TextEditingController();
  TextEditingController emiratesLocationController = TextEditingController();
  TextEditingController liscenceNumberController = TextEditingController();
  TextEditingController liscenceNumberExpiryDateController =
      TextEditingController();
  TextEditingController channelNameController = TextEditingController();
  TextEditingController salaryPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void _pickFiles() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*,application/pdf'; // Accept images and PDFs
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null) {
        setState(() {
          _files = files.toList();
        });
      }
    });
  }

  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Set to accept images only
    uploadInput.multiple = false;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(files.first);
        reader.onLoadEnd.listen((e) {
          setState(() {
            pickedImageUrl = reader.result as String?;
          });
        });
      }
    });
  }

  void _removeFile(int index) {
    setState(() {
      _files!.removeAt(index);
    });
  }

  Future<List<Map<String, dynamic>>?> uploadDocuments() async {
    List<Map<String, dynamic>> documentsUrls = [];
    EasyLoading.show(status: "Uploading");
    try {
      if (_files != null) {
        for (var file in _files!) {
          String fileName = file.name;
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          await reader.onLoadEnd.first;

          if (reader.result != null) {
            final Uint8List bytes = reader.result as Uint8List;

            Reference storageReference =
                FirebaseStorage.instance.ref().child('salarySlips/$fileName');

            UploadTask uploadTask = storageReference.putData(
              bytes,
              SettableMetadata(contentType: file.type),
            );

            TaskSnapshot taskSnapshot = await uploadTask;

            String downloadURL = await taskSnapshot.ref.getDownloadURL();
            documentsUrls.add({fileName: downloadURL});
          } else {
            throw Exception("Error reading file.");
          }
        }
        EasyLoading.dismiss();
        return documentsUrls;
      } else {
        EasyLoading.dismiss();
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await _showDatePicker(context);
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Rider',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  MyTextField(
                    label: 'Rider Name',
                    icon: Icons.person,
                    controller: nameController,
                  ),
                  MyTextField(
                    label: 'Rider Id',
                    icon: Icons.person,
                    controller: riderIdController,
                  ),
                  MyTextField(
                    label: 'Emirates Id',
                    icon: Icons.key,
                    controller: emiratesIdController,
                  ),
                  TextFormField(
                    controller: emiratesIdExpiryDateController,
                    decoration: InputDecoration(
                      labelText: 'Emirates Id Expiry Date',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      _selectDate(context, emiratesIdExpiryDateController);
                    },
                  ),
                  MyTextField(
                    label: 'Location',
                    icon: Icons.location_on_outlined,
                    controller: emiratesLocationController,
                  ),
                  MyTextField(
                    label: 'License Number',
                    icon: Icons.format_list_numbered,
                    controller: liscenceNumberController,
                  ),
                  TextFormField(
                    controller: liscenceNumberExpiryDateController,
                    decoration: InputDecoration(
                      labelText: 'License Number Expiry Date',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      _selectDate(context, liscenceNumberExpiryDateController);
                    },
                  ),
                  MyTextField(
                    label: 'Channel Name',
                    icon: Icons.wifi,
                    controller: channelNameController,
                  ),
                  MyTextField(
                    label: 'Salary Password',
                    icon: Icons.lock,
                    controller: salaryPasswordController,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF0000),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (pickedImageUrl != null) {
                          if (_files == null || _files!.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Upload Rider Documents'),
                                content: Text('Please upload rider documents.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            List<Map<String, dynamic>>? filesUrls =
                                await uploadDocuments();
                            if (filesUrls != null) {
                              RiderModel riderModel = RiderModel(
                                fullName: nameController.text,
                                riderId: riderIdController.text,
                                emiratesId: emiratesIdController.text,
                                emiratesIdExpiryDate: emiratesIdExpiryDateController.text,
                                location: emiratesLocationController.text,
                                liscenceNumber: liscenceNumberController.text,
                                liscenceNumberExpiryDate: liscenceNumberExpiryDateController.text,
                                channelName: channelNameController.text,
                                salaryPassword: salaryPasswordController.text,
                                imageUrl: pickedImageUrl!,
                                documenstUrlsList: filesUrls,
                              );
                              EasyLoading.show(status: 'Adding Rider');
                              await FirebaseFirestore.instance
                                  .collection('riders')
                                  .add(riderModel.toJson());
                              EasyLoading.dismiss();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('New Rider Added'),
                                    content: Text(
                                        'The rider has been successfully added.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              setState(() {});
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Upload Failed'),
                                  content: Text('Failed to upload documents.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Upload Profile Image'),
                              content: Text('Please upload a profile image.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Create Rider',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      pickedImageUrl == null
                          ? CircleAvatar(
                              radius: screenWidth * 0.08,
                              child: Icon(Icons.person),
                            )
                          : CircleAvatar(
                              radius: screenWidth * 0.08,
                              backgroundImage: NetworkImage(pickedImageUrl!),
                            ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFF0000)),
                        onPressed: _pickImage,
                        child: Text(
                          'Upload Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Documents',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: _pickFiles,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: [6, 3],
                          strokeWidth: 2,
                          color: Colors.blue,
                          child: Container(
                            width: screenWidth * 0.25,
                            height: screenHeight * 0.05,
                            alignment: Alignment.center,
                            child: Text('Upload Documents'),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _files != null
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: _files!.length,
                                itemBuilder: (context, index) {
                                  final file = _files![index];
                                  return ListTile(
                                    title: Text(file.name),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        _removeFile(index);
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;

  const MyTextField({
    Key? key,
    required this.label,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}
