import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppCard extends StatelessWidget {
  final String productName;
  final String unitType;
  final int availableUnits;
  final double price;
  final String note;
  final String imageUrl;

  final formatCurrency = NumberFormat.simpleCurrency();

  AppCard({
    @required this.productName,
    @required this.unitType,
    @required this.availableUnits,
    @required this.price,
    this.imageUrl,
    this.note = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: BaseStyles.listPadding,
      padding: BaseStyles.listPadding,
      decoration: BoxDecoration(
          boxShadow: BaseStyles.boxShadow,
          color: Colors.white,
          border: Border.all(
            color: AppColors.darkblue,
            width: BaseStyles.borderWidth,
          ),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(right: 10.0, bottom: 10.0, top: 10.0),
                child: (imageUrl != null && imageUrl != "")
                    ? ClipRRect(
                        child: Image.network(
                          imageUrl,
                          height: 100.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    : Image.asset(
                        'assets/images/vegetables.png',
                        height: 100.0,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(productName, style: TextStyles.subtitle),
                  Text('${formatCurrency.format(price)}/$unitType',
                      style: TextStyles.body),
                  (availableUnits > 0)
                      ? Text('In Stock', style: TextStyles.bodyLightBlue)
                      : Text('Currently Unavailable', style: TextStyles.bodyRed)
                ],
              )
            ],
          ),
          Text(note, style: TextStyles.body)
        ],
      ),
    );
  }
}

class NotificationsCounter extends StatefulWidget {
  const NotificationsCounter({
    this.onTap,
    this.count,
  });
  final Function onTap;
  final int count;

  @override
  _NotificationsCounterState createState() => _NotificationsCounterState();
}

class _NotificationsCounterState extends State<NotificationsCounter> {
  @override
  void initState() {
    checkIfNottification(); //call this when recieved notti
    super.initState();
  }

  int counter = 310;
  String counter100 = '99';
  bool isNottiCount = true;
  bool isCountAbove100 = false;
  checkIfNottification() {
    if (widget.count <= 0) {
      setState(() {
        isNottiCount = false;
      });
    }
    if (widget.count >= 100) {
      setState(() {
        isCountAbove100 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      // padding: EdgeInsets.all(8.0),
      width: 36.5,
      height: 36.5,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.green,
        child: Container(
          padding: EdgeInsets.all(0),
          child: InkWell(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    size: 30.0,
                  ),
                  Positioned(
                    left: 10,
                    child: isNottiCount
                        ? Container(
                            width: 21.5,
                            height: 21.5,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Text(
                                  isCountAbove100
                                      ? counter100
                                      : widget.count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}

String abasuLogo = 'assets/images/logo.png';

class AbasuLogo extends StatelessWidget {
  const AbasuLogo({
    this.width,
    this.height,
  });
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      abasuLogo,
      width: width,
      height: height,
    );
  }
}
