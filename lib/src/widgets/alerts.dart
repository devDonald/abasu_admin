import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppAlerts {
  static Future<void> showErrorDialog(
      bool isIOS, BuildContext context, String errorMessage) async {
    return (isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Error',
                  style: TextStyles.subtitle,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(errorMessage, style: TextStyles.body)
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text('Okay', style: TextStyles.body),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            })
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyles.subtitle,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(errorMessage, style: TextStyles.body)
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay', style: TextStyles.body),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            });
  }
}

void showSimpleSnack(
  String value,
  IconData icon,
  Color iconColor,
  GlobalKey<ScaffoldState> _scaffoldKey,
) {
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Icon(
            icon,
            color: iconColor,
          )
        ],
      ),
    ),
  );
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
