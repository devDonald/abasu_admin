import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/styles/buttons.dart';
import 'package:farmers_market/src/styles/text_title.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productName, productImage, productCategory;
  final int price;
  final Function onTap;

  const ProductCard(
      {Key key,
      this.productName,
      this.productImage,
      this.price,
      this.onTap,
      this.productCategory})
      : super(key: key);

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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: ListView(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.network(
                    productImage,
                    height: 100.0,
                    width: 120.0,
                  )
                ],
              ),
              // SizedBox(height: 5),
              Center(
                child: TitleText(
                  text: productName,
                  fontSize: 18,
                ),
              ),
              Center(
                child: TitleText(
                  text: productCategory,
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
              TitleText(
                text: '₦${format.format(price)}',
                fontSize: 16,
              ),
              BuyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtisanCard extends StatelessWidget {
  final String image, fullName, gender, experience, specialty, location, charge;
  final bool isVerified;
  final Function onTap;

  const ArtisanCard(
      {Key key,
      this.image,
      this.fullName,
      this.gender,
      this.experience,
      this.specialty,
      this.location,
      this.isVerified,
      this.onTap,
      this.charge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (screenSize.width - 20) / 2,
        height: 170.0,
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        padding: EdgeInsets.all(
          12.2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 1.5),
              blurRadius: 3.0,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(
              image,
              height: 120.0,
              width: 100.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                    title: fullName,
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: gender,
                    icon: Icons.anchor,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: experience,
                    icon: Icons.work,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: specialty,
                    icon: Icons.category,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: location,
                    icon: Icons.location_on,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: charge,
                    icon: Icons.money,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  isVerified
                      ? RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText1,
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: 'Artisan Verified',
                                  style: TextStyle(
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText1,
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: 'Artisan not Verified',
                                  style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String image, fullName, gender, location;
  final Function onTap;

  const UserCard(
      {Key key,
      this.image,
      this.fullName,
      this.gender,
      this.location,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (screenSize.width - 20) / 2,
        height: 90.0,
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        padding: EdgeInsets.all(
          12.2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 1.5),
              blurRadius: 3.0,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(
              image,
              height: 100.0,
              width: 90.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                    title: fullName,
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: gender,
                    icon: Icons.anchor,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextBody(
                    title: location,
                    icon: Icons.location_on,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextBody extends StatelessWidget {
  final String title;
  final IconData icon;

  const TextBody({Key key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                icon,
                size: 16,
                color: Colors.green,
              ),
            ),
          ),
          TextSpan(text: title),
        ],
      ),
    );
  }
}

class RequestedArtisanCard extends StatelessWidget {
  final String title, artisanName, status, timestamp;
  final bool hasAgreed;
  final Function onTap;

  const RequestedArtisanCard({
    Key key,
    this.title,
    this.artisanName,
    this.status,
    this.hasAgreed,
    this.onTap,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (screenSize.width - 20) / 2,
        height: 100.0,
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        padding: EdgeInsets.all(
          12.2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 1.5),
              blurRadius: 3.0,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/request.png',
              height: 60.0,
              width: 60.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        TextSpan(
                            text: title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        WidgetSpan(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text('Status: ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                        ),
                        TextSpan(
                            text: status,
                            style: TextStyle(
                                backgroundColor: Colors.lightBlueAccent,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              'Artisan Name: ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextSpan(text: artisanName),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight, child: Text(timestamp)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductOrderCard extends StatelessWidget {
  final String title, ownerName, status, timestamp, orderId, price;
  final bool enRoute, isDelivered;
  final Function onTap;
  final Function enRouteTap;

  const ProductOrderCard({
    Key key,
    this.title,
    this.ownerName,
    this.status,
    this.enRoute,
    this.onTap,
    this.timestamp,
    this.enRouteTap,
    this.orderId,
    this.price,
    this.isDelivered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (screenSize.width - 20) / 2,
        height: 150.0,
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        padding: EdgeInsets.all(
          12.2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 1.5),
              blurRadius: 3.0,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/building.png',
              height: 60.0,
              width: 60.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                              text: '$title',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        WidgetSpan(
                          child: Text('Id: ',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextSpan(
                            text: "$orderId".toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        WidgetSpan(
                          child: Text('Price: ',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextSpan(
                            text: "$naira$price",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        WidgetSpan(
                          child: Text('Status: ',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextSpan(
                            text: status,
                            style: TextStyle(
                                backgroundColor: Colors.lightBlueAccent,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        WidgetSpan(
                          child: Text(
                            'Owner Name: ',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextSpan(text: ownerName),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(timestamp)),
                      // GestureDetector(
                      //   onTap: enRouteTap,
                      //   child: Align(
                      //       alignment: Alignment.bottomRight,
                      //       child: enRoute == true && isDelivered == false
                      //           ? TrackButton()
                      //           : Container()),
                      // )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
