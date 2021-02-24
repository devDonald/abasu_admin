import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/all_cards.dart';
import 'package:farmers_market/construction/orders_details.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({
    Key key,
  }) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int inDays = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Orders'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: ordersRef
              .where('isDelivered', isEqualTo: false)
              .orderBy('timestamp', descending: true)
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

                return ProductOrderCard(
                  orderId: snap['orderId'],
                  title: snap['orderTitle'],
                  price: '${format.format(snap['price'])}',
                  ownerName: snap['ownerName'],
                  status: snap['status'],
                  enRoute: snap['isEnroute'],
                  isDelivered: snap['isDelivered'],
                  timestamp: getChatTime(snap['timestamp']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderDetails(
                                  orderId: snap['orderId'],
                                  orderTitle: snap['orderTitle'],
                                  price: '${format.format(snap['price'])}',
                                  ownerName: snap['ownerName'],
                                  status: snap['status'],
                                  ownerId: snap['ownerId'],
                                  deliveryAddress: snap['deliveryAddress'],
                                  driverAccepted: snap['driverAccepted'],
                                  driverId: snap['driverId'],
                                  driverName: snap['driverName'],
                                  ownerNumber: snap['ownerPhone'],
                                  distance: snap['distance'],
                                  phone: snap['driverPhone'],
                                  isEnroute: snap['isEnroute'],
                                  requestDate: getChatTime(snap['timestamp']),
                                )));
                  },
                );
              },
            );
          }),
    );
  }

  String getChatTime(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String msg = '';
    var dt = DateTime.parse(date).toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    inDays = dur.inDays;
    if (dur.inDays > 0) {
      msg = '${dur.inDays} d ago';
      return dur.inDays == 1 ? '1d ago' : DateFormat("dd MMM").format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} h ago';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} m ago';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} s ago';
    } else {
      msg = 'now';
    }
    return msg;
  }
}
