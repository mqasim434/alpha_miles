// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:alpha_miles/models/rider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RidersScreen extends StatefulWidget {
  const RidersScreen({super.key});

  @override
  State<RidersScreen> createState() => _RidersScreenState();
}

class _RidersScreenState extends State<RidersScreen> {
  @override
  Widget build(BuildContext context) {
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
                      return RiderTileWidget(
                        riderModel: riderModel,
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

class RiderTileWidget extends StatelessWidget {
  const RiderTileWidget({super.key, required this.riderModel});

  final RiderModel riderModel;

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
              backgroundImage: NetworkImage(riderModel.imageUrl.toString()),
            ),
            title: Text(riderModel.fullName.toString()),
            subtitle: Text('Emirates ID: ${riderModel.emiratesId}'),
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}
