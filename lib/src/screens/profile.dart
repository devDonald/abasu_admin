import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/driver/admin_model.dart';
import 'package:farmers_market/main.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import 'edit_admins.dart';

class AdminProfile extends StatefulWidget {
  static const String id = 'AdminProfile';
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<AdminProfile>
    with SingleTickerProviderStateMixin {
  //bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('UserId: ${authId.adminId}');
  }

  File pickedImage;
  String _uploadedImageURL;

  final _picker = ImagePicker();
  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    var image = await _picker.getImage(source: source);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      pickedImage = croppedFile;
      print(pickedImage.lengthSync());
    });
  }

  Future<void> sendImage() async {
    try {
      User _currentUser = FirebaseAuth.instance.currentUser;
      String uid = _currentUser.uid;
      if (pickedImage != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('adminProfile/$uid/${Path.basename(pickedImage.path)}}');
        UploadTask uploadTask = storageReference.putFile(pickedImage);
        await uploadTask;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) async {
          _uploadedImageURL = fileURL;
          DocumentReference _docRef = adminRef.doc(uid);
          await _docRef.update({
            'photo': _uploadedImageURL,
          }).then((doc) async {
            Fluttertoast.showToast(
                msg: "photo successfully updated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
          }).catchError((onError) async {
            Fluttertoast.showToast(
                msg: "photo update Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return new Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.green,
          title: Text('My Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
          titleSpacing: -5.0,
        ),
        body: Container(
          child: PaginateFirestore(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            emptyDisplay: Center(
              child: Text('Please Update your profile'),
            ),
            itemsPerPage: 15,
            itemBuilder: (index, context, snapshot) {
              AdminModel snap = AdminModel.fromSnapshot(snapshot);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.height * 0.32,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new CachedNetworkImageProvider(
                                            snap.photo),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        await getImageFile(ImageSource.gallery);
                                        sendImage();
                                      },
                                      child: new CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        ),
                        Text(
                          '${snap.name}',
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new GestureDetector(
                                        child: new CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 14.0,
                                          child: new Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                        name: snap.name,
                                                        email: snap.email,
                                                        city: snap.city,
                                                        adminId: snap.adminId,
                                                        phone: snap.phone,
                                                        address: snap.address,
                                                        marital: snap.marital,
                                                        state: snap.state,
                                                      )));
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
                          snap.email,
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
                        Text(
                          snap.phone,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
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
                          snap.gender,
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
                          snap.marital,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Address',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${snap.address}, ${snap.city}',
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
                          '${snap.day}-${snap.month}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Market Place Profile
                ],
              );
            },
            // orderBy is compulsary to enable pagination
            query: adminRef.where('adminId', isEqualTo: auth.adminId),
            isLive: true,

            itemBuilderType: PaginateBuilderType.listView,
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
