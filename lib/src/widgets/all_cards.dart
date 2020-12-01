import 'package:farmers_market/src/styles/buttons.dart';
import 'package:farmers_market/src/styles/text_title.dart';
import 'package:flutter/material.dart';



class ProductCard extends StatelessWidget {
  final String productName, productImage, productCategory;
  final double price;
  final Function onTap;

  const ProductCard({Key key, this.productName, this.productImage, this.price, this.onTap, this.productCategory})
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

         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Stack(
               alignment: Alignment.center,
               children: <Widget>[
                 Image.network(
                   productImage, height: 150.0,
                   width: 150.0,
                 )
               ],
             ),
             // SizedBox(height: 5),
             TitleText(
               text: productName,
               fontSize: 18,
             ),
             TitleText(
               text: productCategory,
               fontSize: 12,
               color: Colors.green,
             ),
             TitleText(
               text: '₦$price',
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
