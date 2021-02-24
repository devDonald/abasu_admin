import 'dart:math';

import 'package:farmers_market/driver/driver_model.dart';
import 'package:farmers_market/src/models/constants.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:farmers_market/src/styles/buttons.dart';
import 'package:farmers_market/src/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'RegisterScreen';

  const RegisterScreen({
    Key key,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

var isLargeScreen = false;

class _RegisterScreenState extends State<RegisterScreen> {
  bool loading = false;
  ProgressDialog pr;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _marital = TextEditingController();
  final TextEditingController _state = TextEditingController();

  String selectedState, selectedGender;

  String error = '', dateOfBirth = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  AuthService auth = AuthService();

  bool isPicked = false;
  bool isStartTimePicked = false;
  bool isEndTimePicked = false;
  bool isValidRange;

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 30))))) {
      return true;
    }
    return false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1880, 1),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        isPicked = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    int year = selectedDate.year;
    int month = selectedDate.month;
    int day = selectedDate.day;

    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, Creating new User');

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    dateOfBirth = '${selectedDate.toLocal()}'.split(' ')[0];

    if (deviceHeight >= 800.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    if (deviceWidth >= 420.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Register as Admin'),
          backgroundColor: Colors.green),
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
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
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
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Password ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _password,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return '8 or more characters';
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
                                      label: 'Retype Password ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _confirmPassword,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please confirm password';
                                          } else if (value != _password.text) {
                                            return 'password mismatch';
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

                        //Date of Birth and Gender
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Date of Birth',
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: DatePicker(
                                              info: isPicked ? '$day' : 'Day',
                                              icon: Icons.date_range,
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                            ),
                                          ),
                                          Text('_'),
                                          Expanded(
                                            child: DatePicker(
                                              info:
                                                  isPicked ? '$month' : 'Month',
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Gender
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Gender',
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: DropdownButtonFormField<String>(
                                        hint: Text('Select Gender'),
                                        value: selectedGender,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 25.0,
                                        elevation: 0,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            selectedGender = newValue;
                                            print(selectedGender);
                                          });
                                        },
                                        items: gender
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
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
                                  buttonTitle: 'Create Admin Account',
                                  blurRadius: 7.0,
                                  roundedEdge: 2.5,
                                  onTap: () async {
                                    if (_phoneNumber.text != '' &&
                                        _fullName.text != '' &&
                                        selectedGender != '' &&
                                        _email.text != '' &&
                                        _city.text != '' &&
                                        _address.text != '' &&
                                        _state.text != '' &&
                                        _confirmPassword.text != '' &&
                                        _password.text != '' &&
                                        _marital.text != '') {
                                      if (_password.text ==
                                          _confirmPassword.text) {
                                        pr.show();
                                        await auth
                                            .createAdmin(
                                                _email.text,
                                                _password.text,
                                                DriverModel(
                                                    email: _email.text,
                                                    phone: _phoneNumber.text,
                                                    gender: selectedGender,
                                                    country: 'Nigeria',
                                                    state: _state.text,
                                                    isVerified: false,
                                                    address: _address.text,
                                                    dob: '$day/$month/$year',
                                                    day: day,
                                                    month: month,
                                                    year: year,
                                                    marital: _marital.text,
                                                    city: _city.text,
                                                    name: _fullName.text,
                                                    photo: dummyProfilePic))
                                            .then((value) async {
                                          pr.hide();
                                          Fluttertoast.showToast(
                                              msg: "Admin Created Successfully",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, '/home', (r) => false);
                                        }).catchError((onError) async {
                                          pr.hide();
                                          Fluttertoast.showToast(
                                              msg: "Failed",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      } else {
                                        setState(() {
                                          error = 'password mismatch';
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        error = 'PLEASE COMPLETE ALL FIELDS';
                                      });
                                    }
                                  }),
                              SizedBox(height: 25.0),
                              Center(
                                child: Text(
                                  error,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              SizedBox(height: 15.0),
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

class DoBPicker extends StatelessWidget {
  const DoBPicker({
    Key key,
    this.onTap,
    this.dob,
  }) : super(key: key);
  final Function onTap;
  final String dob;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date of Birth'),
              SizedBox(height: 8),
              Text(dob),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({
    Key key,
    this.onTap,
    this.info,
    this.icon,
  }) : super(key: key);
  final Function onTap;
  final String info;
  final IconData icon;
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        // width: 80,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.grey,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.info),
            SizedBox(width: 3),
            Container(
              child: Icon(widget.icon, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
