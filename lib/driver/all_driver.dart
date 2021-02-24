import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/all_cards.dart';
import 'package:farmers_market/driver/driver_profile.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllDrivers extends StatelessWidget {
  const AllDrivers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('All Drivers'),
          backgroundColor: Colors.green),
      backgroundColor: Colors.pink[50],
      body: StreamBuilder<QuerySnapshot>(
          stream: driverRef.orderBy('name', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: (Platform.isIOS)
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              );
            return ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot snap = snapshot.data.docs[index];

                return UserCard(
                  fullName: snap['name'],
                  image: snap['photo'],
                  gender: snap['marital'],
                  location: '${snap['address']} ${snap['city']}',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverProfile(
                                  fullName: snap['name'],
                                  image: snap['photo'],
                                  gender: snap['gender'],
                                  location:
                                      '${snap['address']} ${snap['city']}',
                                  userId: snap['driverId'],
                                  email: snap['email'],
                                  phone: snap['phone'],
                                  dob: snap['dob'],
                                  marital: snap['marital'],
                                  experience: snap['experience'],
                                )));
                  },
                );
              },
            );
          }),
    );
  }
}
