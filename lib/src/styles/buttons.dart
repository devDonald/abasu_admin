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
              'Details',
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

class DiscussOutlineButton extends StatelessWidget {
  const DiscussOutlineButton({
    Key key,
    @required this.child,
    @required this.onTap,
  }) : super(key: key);
  final Function onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 14.0,
          bottom: 14.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: child,
      ),
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
