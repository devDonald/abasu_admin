import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/card.dart';
import 'package:farmers_market/construction/products_menu.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategory extends StatefulWidget {
  final String subCat;

  const SubCategory({Key key, this.subCat}) : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(widget.subCat),
            backgroundColor: Colors.green),
        backgroundColor: Colors.red[100],
        body: StreamBuilder<QuerySnapshot>(
            stream: root
                .collection(widget.subCat)
                .orderBy('item', descending: false)
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
                  return ItemsCard(
                    item: snap['item'],
                    icon: Icons.construction,
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductMenu(
                                      subCategory: snap['item'],
                                    )));
                      });
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
