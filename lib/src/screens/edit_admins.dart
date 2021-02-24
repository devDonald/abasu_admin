import 'package:farmers_market/authentication/login.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  static const String id = 'EditProfile';
  final String name, email, city, phone, address, marital, state, adminId;

  const EditProfile(
      {Key key,
      this.name,
      this.email,
      this.city,
      this.phone,
      this.address,
      this.marital,
      this.state,
      this.adminId})
      : super(key: key);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<EditProfile> {
  ProgressDialog pr;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _marital = TextEditingController();
  final TextEditingController _state = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  void loadDetails() {
    if (mounted) {
      setState(() {
        _email.text = widget.email;
        _fullName.text = widget.name;
        _phoneNumber.text = widget.phone;
        _city.text = widget.city;
        _address.text = widget.address;
        _marital.text = widget.marital;
        _state.text = widget.state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, submitting details');
    return new Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('Edit My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              //height: deviceHeight,
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Full Name ',
                              ),
                              AuthTextField(
                                width: double.infinity,
                                formField: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _fullName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Email Address ',
                              ),
                              AuthTextField(
                                width: double.infinity,
                                formField: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) => val.trim().isEmpty
                                      ? 'Enter Email Address'
                                      : !val.trim().contains('@') ||
                                              !val.trim().contains('.')
                                          ? 'enter a valid email address'
                                          : null,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Marital Status
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Marital Status',
                              ),
                              AuthTextField(
                                width: double.infinity,
                                formField: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _marital,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'enter marital status';
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        ),
                        // address

                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Home Address ',
                              ),
                              AuthTextField(
                                width: double.infinity,
                                formField: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _address,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'enter address';
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        ),
                        // City and State
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'City ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _city,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'city cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //State
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'State ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _state,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'state cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Phone Number',
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: AuthTextField(
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _phoneNumber,
                                        maxLength: 11,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.0),
                              PrimaryButton(
                                height: 45.0,
                                width: double.infinity,
                                color: Colors.green,
                                buttonTitle: 'Submit Details',
                                blurRadius: 7.0,
                                roundedEdge: 2.5,
                                onTap: () async {
                                  if (_phoneNumber.text != '' &&
                                      _fullName.text != '' &&
                                      _email.text != '' &&
                                      _city.text != '' &&
                                      _address.text != '' &&
                                      _state.text != '' &&
                                      _marital.text != '') {
                                    pr.show();
                                    adminRef.doc(widget.adminId).update({
                                      'name': _fullName.text,
                                      'email': _email.text,
                                      'city': _city.text,
                                      'phone': _phoneNumber.text,
                                      'address': _address.text,
                                      'marital': _marital.text,
                                      'state': _state.text,
                                    }).then((value) {
                                      pr.hide();
                                      Fluttertoast.showToast(
                                          msg: "Details Updated",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                    }).catchError((onError) {
                                      pr.hide();
                                      Fluttertoast.showToast(
                                          msg: "Update failed, try again",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
