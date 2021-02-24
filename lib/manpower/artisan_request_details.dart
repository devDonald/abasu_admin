import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/manpower/display_details.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ArtisanRequestDetails extends StatelessWidget {
  const ArtisanRequestDetails({
    Key key,
    this.ownerName,
    this.projectTitle,
    this.projectDescription,
    this.location,
    this.artisanId,
    this.isComplete,
    this.hasAgreed,
    this.artisanName,
    this.projectId,
    this.ownerId,
    this.startDate,
    this.requestDate,
    this.isApproved,
    this.inDays,
    this.status,
  }) : super(key: key);
  final String ownerName,
      projectTitle,
      projectDescription,
      location,
      artisanId,
      projectId,
      ownerId,
      startDate,
      requestDate,
      status,
      artisanName;
  final int inDays;
  final bool isComplete, hasAgreed, isApproved;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artisan Request Details'),
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
              'Project Title',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              projectTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Description',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              projectDescription,
              maxLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Location',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              location,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Start Date',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              startDate,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Owner',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ownerName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayDetails(
                                uid: ownerId,
                              ),
                            ));
                      },
                      child: Icon(
                        Icons.preview,
                        color: Colors.green,
                      )),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Requested Artisan',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  artisanName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayDetails(
                                uid: artisanId,
                              ),
                            ));
                      },
                      child: Icon(
                        Icons.preview,
                        color: Colors.green,
                      )),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Status',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
            AppButton(
              buttonText: 'Approve Request',
              buttonType:
                  hasAgreed == true ? ButtonType.Green : ButtonType.Disabled,
              onPressed: () async {
                showCompleteDialog(context, projectId);
              },
            ),
          ],
        ),
      ),
    );
  }

  showCompleteDialog(BuildContext context, String requestId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("yes"),
      onPressed: () async {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(artisanRequests.doc(requestId),
              {"isApproved": true, "status": "Admin Approved Request"});
        }).then((value) async {
          await activityFeedRef.doc(ownerId).collection('requests').doc().set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': projectTitle,
            'artisanId': artisanId,
            'artisanName': artisanName,
            'type': 'request',
            'sub': 'approved',
            'timestamp': timestamp,
          });
          await activityFeedRef
              .doc(artisanId)
              .collection('requests')
              .doc()
              .set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': projectTitle,
            'artisanId': artisanId,
            'sub': 'approved',
            'artisanName': artisanName,
            'type': 'request',
            'timestamp': timestamp,
          });
          Fluttertoast.showToast(
              msg: "Request approved",
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
    Widget continueButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Approve Project"),
      content: Text("Would you like to approve this Request?"),
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
