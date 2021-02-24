import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/widgets/view_attached_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ArtisanProfile extends StatefulWidget {
  final String image, fullName, gender, experience, specialty, location, userId;
  final String email, phone;
  final bool isVerified;
  final int charge;

  const ArtisanProfile(
      {Key key,
      this.image,
      this.fullName,
      this.gender,
      this.experience,
      this.specialty,
      this.location,
      this.charge,
      this.userId,
      this.isVerified,
      this.email,
      this.phone})
      : super(key: key);

  @override
  _ArtisanProfileState createState() => _ArtisanProfileState();
}

class _ArtisanProfileState extends State<ArtisanProfile> {
  bool isHired = false, hasPreviusWork = false;

  void getHasPreviousWork() async {}
  void getIsHired() async {}
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('Artisan Profile',
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
              if (choice == AdminTools.exitProfile) {
                Navigator.of(context).pop();
              } else if (choice == AdminTools.verifyArtisan) {
                showVerifyDialog(context, widget.userId);
              } else if (choice == AdminTools.unVerifyArtisan) {
                showUnVerifyDialog(context, widget.userId);
              } else if (choice == AdminTools.topArtisan) {
                showTopArtisanDialog(context, widget.userId);
              } else if (choice == AdminTools.removeTopArtisan) {
                showRemoveTopArtisanDialog(context, widget.userId);
              }
            },
            itemBuilder: (BuildContext context) {
              return AdminTools.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          UserProfileInfo(
            name: widget.fullName,
            profileImage: widget.image,
            categroy: widget.specialty,
            isVerified: widget.isVerified,
          ),
          OverViewBioCard(
            gender: widget.gender,
            experience: widget.experience,
            specialty: widget.specialty,
            isHired: isHired,
            hasPreviousWork: hasPreviusWork,
            phone: widget.phone,
            email: widget.email,
            charge: widget.charge,
            location: widget.location,
          ),
        ],
      ),
    );
  }
}

class OverViewBioCard extends StatelessWidget {
  const OverViewBioCard({
    Key key,
    this.gender,
    this.experience,
    this.specialty,
    this.location,
    this.userId,
    this.phone,
    this.email,
    this.isHired,
    this.hasPreviousWork,
    this.charge,
  }) : super(key: key);
  final String gender, experience, specialty, location, userId, phone, email;
  final bool isHired, hasPreviousWork;
  final int charge;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              email,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
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
            Text(
              phone,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 17.0),
            Text(
              'Gender',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              gender,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Experience',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              experience,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
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
              location,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Average Charge Per Day',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '₦${format.format(charge)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({
    Key key,
    this.name,
    this.profileImage,
    this.categroy,
    this.isVerified,
  }) : super(key: key);
  final String name, profileImage, categroy;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAttachedImage(
                                  image:
                                      CachedNetworkImageProvider(profileImage),
                                  text: name,
                                )));
                  },
                  child: CachedNetworkImage(
                    imageUrl: profileImage,
                    height: 130.0,
                    width: 130.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Artisan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TempDot(),
                  Text(
                    '$categroy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TempDot(),
                  isVerified
                      ? TextBody1(
                          colors: Colors.green,
                        )
                      : TextBody1(
                          colors: Colors.red,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempDot extends StatelessWidget {
  const TempDot({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black12,
      ),
    );
  }
}

class TextBody1 extends StatelessWidget {
  final Color colors;

  const TextBody1({Key key, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                Icons.assignment_turned_in,
                size: 20,
                color: colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminTools {
  static const String exitProfile = 'Close Profile';
  static const String verifyArtisan = 'Verify Artisan';
  static const String unVerifyArtisan = 'UnVerify Artisan';
  static const String topArtisan = 'Make Top Artisan';
  static const String removeTopArtisan = 'Remove Top Artisan';

  static const List<String> choices = <String>[
    verifyArtisan,
    unVerifyArtisan,
    topArtisan,
    removeTopArtisan,
    exitProfile
  ];
}

showVerifyDialog(BuildContext context, String userId) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("yes"),
    onPressed: () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(usersRef.doc(userId), {"isVerified": true});
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Artisan Verified",
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
    title: Text("Verify Artisan"),
    content: Text("Would you like to Verify this Artisan?"),
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

showUnVerifyDialog(BuildContext context, String userId) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("yes"),
    onPressed: () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(usersRef.doc(userId), {"isVerified": false});
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "successful",
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
    title: Text("UnVerify Artisan"),
    content: Text("Would you like to UnVerify this Artisan?"),
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

showRemoveTopArtisanDialog(BuildContext context, String userId) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("yes"),
    onPressed: () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(usersRef.doc(userId), {"isTop": false});
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Top Artisan Added",
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
    title: Text("Remove Top Artisan"),
    content: Text("Would you like to Remove Top Artisan?"),
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

showTopArtisanDialog(BuildContext context, String userId) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("yes"),
    onPressed: () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(usersRef.doc(userId), {"isTop": true});
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Successful",
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
    title: Text("Make Top Artisan"),
    content: Text("Would you like to Make Top Artisan?"),
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
