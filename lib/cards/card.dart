import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key key,
    this.image,
    this.width,
    this.height,
    this.border,
  }) : super(key: key);
  final ImageProvider image;
  final double width;
  final double height;
  final Border border;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.vertical(),
        border: border,
      ),
    );
  }
}

class ItemsCard extends StatelessWidget {
  final String item;
  final IconData icon;
  final Function onTap;

  const ItemsCard({Key key, this.item, this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: 3.0,
          left: 3.0,
          right: 3.0,
          bottom: 3.0,
        ),
        padding: EdgeInsets.only(
          left: 3.0,
          right: 3.0,
          top: 3.0,
          bottom: 3.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            5.0,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(
                0.0,
                2.5,
              ),
              blurRadius: 8.0,
              color: Colors.white60,
            )
          ],
        ),
      child:  ListTile(
        leading: Icon(icon, color: Colors.green,),
        title: Text('$item',textScaleFactor: 1.0,),
        onTap: onTap,
      ),

    );
  }
}
