import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/widgets/view_attached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_menu.dart';

class DriverDetails extends StatefulWidget {
  static const String id = 'DriverDetails';
  String uid;
  DriverDetails({Key key, this.uid}) : super(key: key);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<DriverDetails>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.green,
          title: Text('User Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
          titleSpacing: -5.0,
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list),
              tooltip: 'options',
              onSelected: (choice) {
                if (choice == RemoveDriver.exitProfile) {
                  Navigator.of(context).pop();
                } else if (choice == RemoveDriver.deleteDriver) {
                  showRemoveDialog(context, widget.uid);
                }
              },
              itemBuilder: (BuildContext context) {
                return RemoveDriver.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: new Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  driverRef.where('userId', isEqualTo: widget.uid).snapshots(),
              builder: (context, snapshot) {
                return new ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading..."),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text("Loading..."),
                      );
                    }
                    DocumentSnapshot snap = snapshot.data.docs[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.white,
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child:
                                    new Stack(fit: StackFit.loose, children: <
                                        Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewAttachedImage(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                                snap['photo']),
                                                        text: '${snap['name']}',
                                                      )));
                                        },
                                        child: new Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                image:
                                                    new CachedNetworkImageProvider(
                                                        snap['photo']),
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                              Text(
                                '${snap['name']}',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          color: Color(0xffFFFFFF),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Personal Information',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              top: 17.5, bottom: 5.0, left: 7.0, right: 7.0),
                          //padding: EdgeInsets.only(left: 15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 2.5),
                                blurRadius: 10.5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snap['email'],
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Phone',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snap['phone'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                        onTap: () {
                                          launch("tel:${snap['phone']}");
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.green,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Gender',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snap['gender'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Marital Status',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snap['marital'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Years of Experience',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snap['experience'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Location',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '${snap['address']}, ${snap['city']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Date of Birth',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '${snap['day']}-${snap['month']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              }),
        ));
  }
}

class RemoveDriver {
  static const String exitProfile = 'Close Profile';
  static const String deleteDriver = 'Remove Driver';

  static const List<String> choices = <String>[exitProfile, deleteDriver];
}

showRemoveDialog(BuildContext context, String userId) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("yes"),
    onPressed: () async {
      driverRef.doc(userId).get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Driver Removed",
            toastLength: Toast.LENGTH_SHORT,
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
    title: Text("Remove Driver"),
    content: Text("Would you like to Remove this Driver?"),
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
