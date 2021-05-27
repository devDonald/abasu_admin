import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_assign_driver.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key key,
    this.ownerName,
    this.orderTitle,
    this.deliveryAddress,
    this.driverId,
    this.isEnroute,
    this.driverName,
    this.ownerId,
    this.price,
    this.requestDate,
    this.status,
    this.orderId,
    this.phone,
    this.distance,
    this.driverAccepted,
    this.ownerNumber,
  }) : super(key: key);
  final String ownerName,
      orderTitle,
      deliveryAddress,
      driverId,
      ownerId,
      price,
      orderId,
      phone,
      requestDate,
      status,
      ownerNumber,
      distance,
      driverName;
  final bool isEnroute, driverAccepted;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Order Details'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(9),
        margin: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 15,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              offset: Offset(
                0.0,
                4.0,
              ),
              color: Colors.black12,
            )
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          primary: false,
          children: [
            Text(
              'Delivery Tag',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              orderTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Delivery Address',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              deliveryAddress,
              maxLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Price',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '$naira $price',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Total Distance',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              distance ?? "No Delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Owner',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              ownerName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Owner Number',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ownerNumber,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        launch("tel:$ownerNumber");
                      },
                      child: Icon(
                        Icons.call,
                        color: Colors.green,
                      )),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            distance != null
                ? Text(
                    'Assigned Driver',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : new Container(),
            distance != null ? SizedBox(height: 8.0) : Container(),
            distance != null
                ? Text(
                    driverName ?? 'non assigned',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  )
                : Container(),
            distance != null ? SizedBox(height: 8.0) : Container(),
            distance != null
                ? Text(
                    'Driver Phone No',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : Container(),
            distance != null ? SizedBox(height: 8.0) : Container(),
            distance != null
                ? Text(
                    phone ?? 'not available',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  )
                : Container(),
            SizedBox(height: 8.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Status',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.lightBlueAccent,
                      fontSize: 20.0,
                    ),
                  )
                ]),
            SizedBox(height: 15.0),
            distance != null
                ? AppButton(
                    buttonText: 'Assign A Driver',
                    buttonType: isEnroute == false && driverAccepted == false
                        ? ButtonType.Green
                        : ButtonType.Disabled,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminAsignDriver(
                              ownerId: ownerId,
                              orderId: orderId,
                              title: orderTitle,
                            ),
                          ));
                    },
                  )
                : AppButton(
                    buttonText: 'Set Approved Status',
                    buttonType: isEnroute == false && driverAccepted == false
                        ? ButtonType.Green
                        : ButtonType.Disabled,
                    onPressed: () {
                      showApproveProductDialog(context, orderId);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  showApproveProductDialog(BuildContext context, String productId) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("yes"),
      onPressed: () async {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(ordersRef.doc(productId), {
            "isApproved": true,
            "driverAccepted": true,
            "status": "Product Ready for Pickup"
          });
        }).then((value) async {
          await activityFeedRef.doc(driverId).collection('requests').doc().set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': orderTitle,
            'sub': 'readForPickUp',
            'type': 'request',
            'timestamp': timestamp,
          });
          Fluttertoast.showToast(
              msg: "Product Purchase Approved",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Approve Product Purchase"),
      content:
          Text("Would you like to Approve this Purchase without Delivery?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
