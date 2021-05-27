import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/product/edit_product.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatefulWidget {
  final String itemName;
  final String itemImage, productId;
  final String itemSubCategory, category;
  final String itemDescription;
  final int itemPrice;
  final int itemQuantity;
  final String itemType;
  final double itemRating;
  // bool isfavorited;

  ProductDetails(
      {this.itemName,
      this.itemImage,
      this.itemSubCategory,
      this.itemDescription,
      this.itemPrice,
      this.itemQuantity,
      this.itemType,
      this.itemRating,
      this.productId,
      this.category});

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState();
  }
}

class _ProductDetailsState extends State<ProductDetails> {
  int flag = 0;
  String favorite = "true";
  var response2;
  final Set<dynamic> _saved = Set<dynamic>();
  String accountName = "";
  int iquantity = 0;
  String getQuantity;
  final quantity = TextEditingController();
  var carttCount;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool alreadySaved;

  int length;

  @override
  void initState() {
    super.initState();
    // appMethods.getCartCount().then((result){
    //   setState(() {
    //     carttCount = result;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    alreadySaved = _saved.contains(widget.itemName);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('Product Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            tooltip: 'options',
            onSelected: (choice) async {
              if (choice == AdminTools.exitProduct) {
                Navigator.of(context).pop();
              } else if (choice == AdminTools.deleteProduct) {
                showDeleteProductDialog(context, widget.productId);
              } else if (choice == AdminTools.topProduct) {
                showTopProductDialog(context, widget.productId);
              } else if (choice == AdminTools.removeTopProduct) {
                showRemoveTopProductDialog(context, widget.productId);
              }
            },
            itemBuilder: (BuildContext context) {
              return AdminTools.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(0.0),
            child: Column(children: <Widget>[
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.itemImage),
                              fit: BoxFit.fitHeight),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(120.0),
                            bottomLeft: Radius.circular(120.0),
                          )),
                    ),
                  ],
                ),
              ),
              Card(
                child: Container(
                  width: screenSize.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(widget.itemName,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.itemSubCategory,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(Icons.star,
                                    color: Colors.blue, size: 20.0),
                                Text("0.0"),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(children: <Widget>[
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                '₦${format.format(widget.itemPrice)}',
                                style: GoogleFonts.mulish(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        )
                      ]),
                ),
              ),
              Card(
                  child: Container(
                      width: screenSize.width,
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w700)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(widget.itemDescription,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ))),
              Card(
                child: Container(
                  width: screenSize.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Quantity Available',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('${widget.itemQuantity}'),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Category',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(widget.itemType),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      )
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        elevation: 0.0,
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Container(
          height: 70.0,
          decoration: BoxDecoration(
              // color: Theme.of(context).primaryColor
              ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: (screenSize.width - 20) / 2,
                  child: Text(
                    'REVIEWS(0)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                    width: (screenSize.width - 100) / 2,
                    child: RaisedButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Edit Product"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProduct(
                                productId: widget.productId,
                                productName: widget.itemName,
                                price: widget.itemPrice,
                                productDesc: widget.itemDescription,
                                category: widget.category,
                                subcategory: widget.itemSubCategory,
                                image: widget.itemImage,
                                availble: widget.itemQuantity,
                              ),
                            ));
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminTools {
  static const String exitProduct = 'Close Product';
  static const String deleteProduct = 'Delete Product';
  static const String topProduct = 'Make Top Product';
  static const String removeTopProduct = 'Remove Top Product';

  static const List<String> choices = <String>[
    deleteProduct,
    topProduct,
    removeTopProduct,
    exitProduct
  ];
}

showDeleteProductDialog(BuildContext context, String productId) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("yes"),
    onPressed: () async {
      await driverRef.doc(productId).get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Product successfully deleted",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      });
    },
  );
  Widget continueButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Product"),
    content: Text("Would you like to Delete this Product?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showRemoveTopProductDialog(BuildContext context, String productId) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("yes"),
    onPressed: () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(productRef.doc(productId), {"isTop": false});
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Top product Removed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      });
    },
  );
  Widget continueButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Remove Top Product"),
    content: Text("Would you like to Remove Top Product?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showTopProductDialog(BuildContext context, String productId) {
  BuildContext dialogContext;
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("yes"),
    onPressed: () async {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(productRef.doc(productId), {"isTop": true});
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "Successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      });
    },
  );
  Widget continueButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Make Top Product"),
    content: Text("Would you like to Make Top Product?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
