import 'package:farmers_market/src/widgets/card.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ResetConfirmation extends StatefulWidget {
  static const String id = 'ResetPassword';
  final String email;
  ResetConfirmation({Key key, this.email}) : super(key: key);

  @override
  _ResetConfirmationState createState() =>
      _ResetConfirmationState(email: email);
}

class _ResetConfirmationState extends State<ResetConfirmation> {
  String email;
  _ResetConfirmationState({this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 39.8,
            ),
            AbasuLogo(
              width: 101.1,
              height: 92.7,
            ),
            SizedBox(
              height: 123.5,
            ),
            Center(
              child: Container(
                width: 246.0,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Please check your email address:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 13.0,
                      ),
                    ),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'You should receive an email in a few minutes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 13.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 223.0,
            ),
            PrimaryButton(
                color: Colors.green,
                buttonTitle: 'Back',
                blurRadius: 7.0,
                roundedEdge: 2.5,
                height: 50,
                onTap: () {
                  setState(() {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (r) => false);
                  });
                }),
          ]),
        ),
      ),
    );
  }
}
