import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/card.dart';
import 'package:farmers_market/construction/products_menu.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_products.dart';

class ConstructionMaterials extends StatefulWidget {
  @override
  _ConstructionMaterialsState createState() => _ConstructionMaterialsState();
}

class _ConstructionMaterialsState extends State<ConstructionMaterials> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Construction Material"),
            backgroundColor: Colors.green),
        backgroundColor: Colors.pink[50],
        body: StreamBuilder<QuerySnapshot>(
            stream: materialsRef.orderBy('item', descending: false).snapshots(),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductMenu(
                              subCategory: snap['item'],
                            ),
                          ));
                    },
                  );
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProducts(),
                  ));
            });
          },
        ),
      ),
    );
  }
}
