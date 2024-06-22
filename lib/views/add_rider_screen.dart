// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:html' as html;
import 'dart:io';

import 'package:alpha_miles/models/rider_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddRiderScreen extends StatefulWidget {
  const AddRiderScreen({super.key});

  @override
  State<AddRiderScreen> createState() => _AddRiderScreenState();
}

class _AddRiderScreenState extends State<AddRiderScreen> {
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  List<html.File>? _files;

  String? pickedImageUrl;

  void _pickFiles() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = ''; // You can set file types here, e.g., 'image/*'
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emiratesIdController = TextEditingController();
  TextEditingController emiratesLocationController = TextEditingController();
  TextEditingController liscenceNumberController = TextEditingController();
  TextEditingController channelNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Add Rider',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    label: 'Rider Name',
                    icon: Icons.person,
                    controller: nameController,
                  ),
                  MyTextField(
                    label: 'Emirates Id',
                    icon: Icons.key,
                    controller: emiratesIdController,
                  ),
                  MyTextField(
                    label: 'Emirates Id Location',
                    icon: Icons.location_on_outlined,
                    controller: emiratesLocationController,
                  ),
                  MyTextField(
                    label: 'Liscence Number',
                    icon: Icons.numbers,
                    controller: liscenceNumberController,
                  ),
                  MyTextField(
                    label: 'Channel Name',
                    icon: Icons.wifi_channel,
                    controller: channelNameController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (pickedImageUrl != null) {
                          if (_files == null || _files!.isEmpty) {
                            // Corrected condition
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Upload Rider Documents'),
                                icon: Icon(Icons.warning),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  )
                                ],
                              ),
                            );
                          } else {
                            List<Map<String, String>> filesUrls = [];
                            _files!.forEach((file) {
                              filesUrls.add(
                                  {file.name!: file.relativePath.toString()});
                            });
                            RiderModel riderModel = RiderModel(
                              fullName: nameController.text,
                              emiratesId: emiratesIdController.text,
                              emiratesIdLocation:
                                  emiratesLocationController.text,
                              liscenceNumber: liscenceNumberController.text,
                              channelName: channelNameController.text,
                              imageUrl: pickedImageUrl,
                              documenstUrlsList: filesUrls,
                            );
                            EasyLoading.show(status: 'Adding Rider');
                            FirebaseFirestore.instance
                                .collection('riders')
                                .add(riderModel.toJson());
                            EasyLoading.dismiss();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('New Rider Added'),
                                    icon: Icon(Icons.check_circle),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok')),
                                    ],
                                  );
                                });
                            setState(() {});
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Upload Profile Image'),
                              icon: Icon(Icons.warning),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'),
                                )
                              ],
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.5, 50),
                      maximumSize: Size(screenWidth * 0.5, 50),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Create Rider',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            )),
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pickedImageUrl == null
                          ? CircleAvatar(
                              radius: screenWidth * 0.08,
                              child: Icon(Icons.person),
                            )
                          : CircleAvatar(
                              radius: screenWidth * 0.08,
                              backgroundImage:
                                  NetworkImage(pickedImageUrl.toString()),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => _pickImage(),
                        style: ElevatedButton.styleFrom(
                            maximumSize: Size(screenWidth * 0.2, 50),
                            minimumSize: Size(screenWidth * 0.2, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.red),
                        child: Text(
                          'Upload Image',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 2,
                  width: screenWidth * 0.25,
                  color: Colors.black12,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      'Documents',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => _pickFiles.call(),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 10),
                          child: Text('Upload Documents'),
                        ),
                      ),
                    ),
                    _files != null
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _files!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final file = _files![index];
                                return ListTile(
                                  title: Text(file.name),
                                  trailing: InkWell(
                                      onTap: () => _removeFile.call(index),
                                      child: Icon(Icons.close)),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ))
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          hintText: 'Enter $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Field can't be Empty";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
