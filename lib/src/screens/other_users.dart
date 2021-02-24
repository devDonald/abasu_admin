import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/all_cards.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/screens/other_user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Other Users'),
          backgroundColor: Colors.green),
      backgroundColor: Colors.pink[50],
      body: StreamBuilder<QuerySnapshot>(
          stream: root
              .collection('users')
              .where('asArtisan', isEqualTo: false)
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

                return UserCard(
                  fullName: snap['fullName'],
                  image: snap['imageUrl'],
                  gender: snap['gender'],
                  location: '${snap['address']} ${snap['city']}',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtherUsersProfile(
                                  fullName: snap['fullName'],
                                  image: snap['imageUrl'],
                                  gender: snap['gender'],
                                  location:
                                      '${snap['address']} ${snap['city']}',
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
