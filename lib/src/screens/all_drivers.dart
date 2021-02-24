import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/cards/card.dart';
import 'package:farmers_market/src/screens/driver_full_details.dart';
import 'package:flutter/material.dart';

import 'admin_menu.dart';

class AllDrivers extends StatefulWidget {
  final String groupName, groupId;
  AllDrivers({Key key, this.groupName, this.groupId}) : super(key: key);

  @override
  _AllDriversState createState() => _AllDriversState();
}

class _AllDriversState extends State<AllDrivers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('All Drivers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: driverRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text("Loading..."),
                );
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data.docs[index];
                  return GroupMember(
                    name: snap['name'],
                    city: snap['city'],
                    userImage: CachedNetworkImageProvider(snap['photo']),
                    onTapPerson: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverDetails(
                              uid: snap['userId'],
                            ),
                          ));
                    },
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => AdminAddMembers(
            //         groupId: widget.groupId,
            //         groupName: widget.groupName,
            //       ),
            //     ));
          });
        },
      ),
    );
  }
}

class GroupMember extends StatelessWidget {
  GroupMember({
    Key key,
    this.userImage,
    this.city,
    this.name,
    this.uid,
    this.groupId,
    this.onDeleteTap,
    this.onTapPerson,
  }) : super(key: key);
  ImageProvider userImage;
  String name;
  String city, uid, groupId;
  Function onDeleteTap, onTapPerson;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapPerson,
      child: ListTile(
        leading: ProfilePicture(
          image: userImage,
          width: 47.5,
          height: 47.0,
        ),
        title: GestureDetector(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        subtitle: Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13.5,
          ),
        ),
        trailing: Icon(
          Icons.verified,
        ),
      ),
    );
  }
}
