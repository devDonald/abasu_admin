import 'package:farmers_market/cards/all_cards.dart';
import 'package:farmers_market/construction/product_details.dart';
import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ProductMenu extends StatefulWidget {
  final String subCategory;

  const ProductMenu({Key? key, required this.subCategory}) : super(key: key);

  @override
  _ProductMenuState createState() => _ProductMenuState();
}

class _ProductMenuState extends State<ProductMenu> {
  TextEditingController searchController = TextEditingController();

  FocusNode searchFocus = FocusNode();

  late String filter;

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  initState() {
    searchFocus.requestFocus();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    searchFocus.dispose();
    //searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                        flex: 2,
                        child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })),
                    Flexible(
                      flex: 8,
                      child: Text(
                        '${widget.subCategory}',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white, //5
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: searchFocus,
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          searchController.clear();
                        },
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                      border: InputBorder.none,
                      hintText: 'Search materials',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(115),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2.5),
            ),
          ],
        ),
        child: RefreshIndicator(
          child: PaginateFirestore(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                childAspectRatio: 3 / 3.95,
                crossAxisCount: 2),
            physics: BouncingScrollPhysics(),
            emptyDisplay: Center(
              child: noDataFound(),
            ),
            itemsPerPage: 20,
            itemBuilder: (index, context, snapshot) {
              Product product = Product.fromSnapshot(snapshot);
              return filter == null || filter == ""
                  ? ProductCard(
                      productName: product.productName,
                      price: product.unitPrice,
                      productCategory: product.subCategory,
                      productImage: product.imageUrl,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      itemDescription: product.description,
                                      itemImage: product.imageUrl,
                                      itemName: product.productName,
                                      itemPrice: product.unitPrice,
                                      productId: product.productId,
                                      itemQuantity: product.availableUnits,
                                      itemSubCategory: product.subCategory,
                                      weight: product.weight,
                                      category: product.category,
                                      itemType: product.category,
                                    )));
                      },
                    )
                  : '${product.productName}'
                          .toLowerCase()
                          .contains(filter.toLowerCase())
                      ? ProductCard(
                          productName: product.productName,
                          price: product.unitPrice,
                          productCategory: product.subCategory,
                          productImage: product.imageUrl,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                          itemDescription: product.description,
                                          itemImage: product.imageUrl,
                                          itemName: product.productName,
                                          itemPrice: product.unitPrice,
                                          productId: product.productId,
                                          itemQuantity: product.availableUnits,
                                          itemSubCategory: product.subCategory,
                                          weight: product.weight,
                                          category: product.category,
                                          itemType: product.category,
                                        )));
                          },
                        )
                      : new Container();
            },
            // orderBy is compulsary to enable pagination
            query: root
                .collection('products')
                .where('category', isEqualTo: widget.subCategory)
                .orderBy('productName', descending: false),
            isLive: true,
            listeners: [
              refreshChangeListener,
            ],
            itemBuilderType: PaginateBuilderType.gridView,
          ),
          onRefresh: () async {
            refreshChangeListener.refreshed = true;
          },
        ),
      ),
    );
  }
}

Widget noDataFound() {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.find_in_page, color: Colors.black38, size: 80.0),
          Text("No Products available yet",
              style: TextStyle(color: Colors.black45, fontSize: 20.0)),
          Text("Please check back later",
              style: TextStyle(color: Colors.red, fontSize: 14.0))
        ],
      ),
    ),
  );
}
