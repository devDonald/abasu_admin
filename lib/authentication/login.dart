import 'package:farmers_market/authentication/reset_password.dart';
import 'package:farmers_market/authentication/signup.dart';
import 'package:farmers_market/main.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:farmers_market/src/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login';
  final bool asArtisan;

  const LoginScreen({Key key, this.asArtisan}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  //textfield state
  String _email = '';
  String _password = '';
  String _error = '';
  ProgressDialog _pr;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    _pr = new ProgressDialog(context);
    _pr.style(message: 'Please wait, Authenticating User');

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 39.8),
                    Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            AbasuLogo(
                              width: 101.1,
                              height: 92.7,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 31.1),
                    ScreenTitleIndicator(
                      title: 'LOGIN',
                    ),
                    SizedBox(height: 25.0),
                    AuthTextFeildLabel(
                      label: 'Email Address',
                    ),
                    AuthTextField(
                      width: double.infinity,
                      formField: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val.trim().isEmpty
                            ? 'Enter Email Address'
                            : !val.trim().contains('@') ||
                                    !val.trim().contains('.')
                                ? 'enter a valid email address'
                                : null,
                        onChanged: (val) {
                          setState(() => _email = val);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AuthTextFeildLabel(
                          label: 'Password',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AuthTextField(
                      width: double.infinity,
                      formField: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        validator: (val) => val.length < 8
                            ? 'Enter Password 8 or more characters'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => _password = val);
                        },
                      ),
                    ),
                    SizedBox(height: 25.0),
                    PrimaryButton(
                      width: double.infinity,
                      height: 45.0,
                      buttonTitle: 'Login',
                      color: Colors.green,
                      blurRadius: 7.0,
                      roundedEdge: 2.5,
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _pr.show();
                          });
                          dynamic result =
                              await auth.signInUserWithEmailAndPassword(
                                  _email, _password);
                          if (result == null) {
                            _pr.hide();
                            setState(() {
                              _error =
                                  'Please Supply a valid email/password combination';
                            });
                          } else {
                            _pr.hide();
                            await adminRef
                                .doc(authId.adminId)
                                .get()
                                .then((value) async {
                              if (value.exists) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (r) => false);
                              } else {
                                await auth.signOutUser().then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Sorry you are not an Admin",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.of(context).pop();
                                });
                              }
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      _error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Dont\'t Have an Account? ',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              fontSize: 15.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Nunito',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 23.5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenTitleIndicator extends StatelessWidget {
  const ScreenTitleIndicator({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 8.4),
        Container(
          margin: EdgeInsets.only(
            left: 98.0,
            right: 98.2,
          ),
          height: 2.0,
          // width: 164,
          color: Colors.green,
        ),
        // Divider(
        //   height: 4.0,
        //   color: kButtonsOrange,
        // ),
      ],
    );
  }
}

class AuthTextFeildLabel extends StatelessWidget {
  const AuthTextFeildLabel({
    Key key,
    this.label,
    this.controller,
    this.onChanged,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Colors.green,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    this.width,
    this.formField,
    Key key,
  }) : super(key: key);
  final double width;
  final TextFormField formField;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.5),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.5,
            offset: Offset(0.0, 2.5),
            color: Colors.black12,
          )
        ],
      ),
      width: width,
      // width: double.infinity,
      child: formField,
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final Color color;
  final String buttonTitle;
  final double blurRadius;
  final double roundedEdge;
  final double width;
  final double height;
  final void Function() onTap;
  final bool busy;
  final bool enabled;

  const PrimaryButton({
    Key key,
    this.buttonTitle,
    this.blurRadius,
    this.roundedEdge,
    this.color,
    this.onTap,
    this.busy = false,
    this.enabled = false,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: InkWell(
        child: Container(
          width: widget.width,
          height: widget.height,
          // height: widget.busy ? 40 : 45.0,
          // width: widget.busy ? 40 : double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.30),
                blurRadius: widget.blurRadius,
              ),
            ],
            borderRadius: BorderRadius.circular(widget.roundedEdge),
            color: widget.color,
          ),
          child: Center(
            child: !widget.busy
                ? Text(
                    widget.buttonTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ),
        ),
      ),
    );
  }
}
