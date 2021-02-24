import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/all_cards.dart';
import 'package:farmers_market/manpower/artisan_profile.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllManpower extends StatelessWidget {
  final String category;

  const AllManpower({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(category),
          backgroundColor: Colors.green),
      backgroundColor: Colors.pink[50],
      body: StreamBuilder<QuerySnapshot>(
          stream: root
              .collection('users')
              .where('asArtisan', isEqualTo: true)
              .where('skill', isEqualTo: category)
              .snapshots(),
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

                return ArtisanCard(
                  fullName: snap['fullName'],
                  image: snap['imageUrl'],
                  gender: snap['gender'],
                  experience: '${snap['experience']} Year(s) Experience',
                  specialty: snap['skill'],
                  location: '${snap['address']} ${snap['city']}',
                  charge: '₦${format.format(snap['charge'])} per day',
                  isVerified: snap['isVerified'],
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArtisanProfile(
                                  fullName: snap['fullName'],
                                  image: snap['imageUrl'],
                                  gender: snap['gender'],
                                  experience:
                                      '${snap['experience']} Year(s) Experience',
                                  specialty: snap['skill'],
                                  location:
                                      '${snap['address']} ${snap['city']}',
                                  charge: snap['charge'],
                                  isVerified: snap['isVerified'],
                                  userId: snap['userId'],
                                  email: snap['email'],
                                  phone: snap['phone'],
                                )));
                  },
                );
              },
            );
          }),
    );
  }
}
