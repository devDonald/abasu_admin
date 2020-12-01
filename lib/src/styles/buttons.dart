import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ButtonStyles {
  static double get buttonHeight => 50.0;
}
class BuyButton extends StatelessWidget {
  const BuyButton({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.4,
      height: 30.4,
      margin: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 5.0),
            blurRadius: 15.0,
            color: Colors.red,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Edit Product',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}