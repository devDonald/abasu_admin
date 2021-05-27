import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/card.dart';
import 'package:farmers_market/main.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AdminAsignDriver extends StatefulWidget {
  String title, orderId, ownerId;
  static const String id = 'AdminAsignDriver';

  AdminAsignDriver({Key key, this.orderId, this.title, this.ownerId})
      : super(
          key: key,
        );
  @override
  _AdminAsignDriverState createState() => _AdminAsignDriverState();
}

class _AdminAsignDriverState extends State<AdminAsignDriver> {
  bool isOwner = false;
  ProgressDialog pr;
  String error = '';

  @override
  void initState() {
    addDriver.driverId = '';
    addDriver.driverName = '';
    addDriver.driverPhone = '';
    super.initState();
  }

  Future sendToFirebase() async {
    await ordersRef.doc(widget.orderId).update({
      "driverId": addDriver.driverId,
      "driverName": addDriver.driverName,
      "driverPhone": addDriver.driverPhone,
      "adminApproved": true,
      "status": 'Order Approved, Driver Assigned'
    }).then((value) async {
      await activityFeedRef
          .doc(widget.ownerId)
          .collection('requests')
          .doc()
          .set({
        "ownerId": widget.ownerId,
        "driverId": addDriver.driverId,
        'orderId': widget.orderId,
        "seen": false,
        "sub": 'driverAssigned',
        'type': 'order',
        "timestamp": DateTime.now().toUtc(),
      });

      await activityFeedRef
          .doc(addDriver.driverId)
          .collection('requests')
          .doc()
          .set({
        "ownerId": widget.ownerId,
        "driverId": addDriver.driverId,
        'orderId': widget.orderId,
        "seen": false,
        "sub": 'driverAssigned',
        "timestamp": DateTime.now().toUtc(),
        'type': 'order',
      });

      pr.hide();
      Fluttertoast.showToast(
          msg: "Driver Successfully Assigned",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, assigning Driver');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleSpacing: -5,
        title: Text(
          'Assign a Driver',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),

        // elevation: 2.0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                bottom: 5.0,
              ),
              margin: EdgeInsets.only(
                bottom: 10.5,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    error.toUpperCase(),
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: driverRef
                        .orderBy('name', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          //return all users follow/following
                          itemCount: snapshot.data.docs.length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot snap = snapshot.data.docs[index];

                            return UsersToAdd(
                                userImage: CachedNetworkImageProvider(
                                  snap['photo'],
                                ),
                                name: '${snap['name']}',
                                experience:
                                    '${snap['experience']} Years Experience',
                                uid: snap['driverId'],
                                phone: snap['phone']);
                          },
                        );
                      }
                      return Center(
                        child: Text('Sorry no driver Registered yet'),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MyFAB(
        onTap: () {
          //groupUsers.add(userId);
          if (addDriver.driverId == '') {
            setState(() {
              error = 'select a person please';
            });
          } else if (addDriver.driverId != '') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: Center(
                    child: new Text('Assign Driver'),
                  ),
                  content: Container(
                    height: 30.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          addDriver.driverName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        child: new Text(
                          'Done'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.greenAccent,
                          ),
                        ),
                        onPressed: () async {
                          await sendToFirebase().then((value) {
                            // Navigator.pushNamedAndRemoveUntil(
                            //     context, '/group_chat', (r) => false);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: MyRecFABbutton(
          title: 'Assign Driver'.toUpperCase(),
        ),
      ),
    );
  }
}

class MyRecFABbutton extends StatelessWidget {
  const MyRecFABbutton({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      height: 36.5,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 3.0,
            offset: Offset(0.0, 1.5),
            color: Colors.green.withOpacity(0.20),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyFAB extends StatelessWidget {
  const MyFAB({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);
  final Function onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }
}

class UsersToAdd extends StatefulWidget {
  UsersToAdd({
    Key key,
    this.onChanged,
    this.userImage,
    this.experience,
    this.name,
    this.phone,
    this.uid,
    this.val,
  }) : super(key: key);
  ImageProvider userImage;
  String name, phone;
  String experience, uid;
  Function onChanged;
  String val;

  @override
  _UsersToAddState createState() => _UsersToAddState();
}

class _UsersToAddState extends State<UsersToAdd> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ProfilePicture(
          image: widget.userImage,
          width: 47.5,
          height: 47.0,
        ),
        title: Text(
          widget.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        subtitle: Text(
          widget.experience,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13.5,
          ),
        ),
        trailing: Checkbox(
          value: value,
          onChanged: (bool val) {
            setState(() {
              value = val;

              if (value == true) {
                addDriver.driverId = widget.uid;
                addDriver.driverName = widget.name;
                addDriver.driverPhone = widget.phone;
              } else {
                addDriver.driverId = '';
                addDriver.driverName = '';
                addDriver.driverPhone = '';
              }
            });
          },
        ));
  }
}
