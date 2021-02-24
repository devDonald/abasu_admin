import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_market/src/widgets/view_attached_image.dart';
import 'package:flutter/material.dart';

class DriverProfile extends StatefulWidget {
  final String image, fullName, gender, location, userId;
  final String email, phone, dob, experience, marital;

  const DriverProfile(
      {Key key,
      this.image,
      this.fullName,
      this.gender,
      this.location,
      this.userId,
      this.email,
      this.marital,
      this.phone,
      this.dob,
      this.experience})
      : super(key: key);

  @override
  _DriverProfileState createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
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
              if (choice == AdminTools.exitProfile) {
                Navigator.of(context).pop();
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
          ),
          OverViewBioCard(
            gender: widget.gender,
            phone: widget.phone,
            email: widget.email,
            location: widget.location,
            dob: widget.dob,
            experience: widget.experience,
            marital: widget.marital,
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
    this.location,
    this.userId,
    this.phone,
    this.email,
    this.experience,
    this.dob,
    this.marital,
  }) : super(key: key);
  final String gender, location, userId, phone, email, experience, dob, marital;
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
              'Years of Experience',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
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
              'Date of Birth',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              dob,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Marital Status',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              marital,
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
  }) : super(key: key);
  final String name, profileImage;

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
  static const String deleteDriver = 'Delete Driver';

  static const List<String> choices = <String>[deleteDriver, exitProfile];
}
