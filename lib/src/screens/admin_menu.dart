import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/construction/all_orders.dart';
import 'package:farmers_market/construction/construction_materials.dart';
import 'package:farmers_market/construction/order_history.dart';
import 'package:farmers_market/driver/all_driver.dart';
import 'package:farmers_market/main.dart';
import 'package:farmers_market/manpower/artisan_requests.dart';
import 'package:farmers_market/manpower/manpower.dart';
import 'package:farmers_market/src/screens/other_users.dart';
import 'package:farmers_market/src/screens/profile.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:farmers_market/src/widgets/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

var root = FirebaseFirestore.instance;
final driverRef = FirebaseFirestore.instance.collection('drivers');
final materialsRef = root.collection('categories');
final productRef = root.collection('products');
final manpowerRef = root.collection('workersCategory');
final usersRef = FirebaseFirestore.instance.collection('users');
final adminRef = FirebaseFirestore.instance.collection('Admins');
final activityFeedRef = root.collection('feeds');
NumberFormat format = NumberFormat('#,###,###');
final artisanRequests = root.collection('artisanRequests');
final requestFeed = root.collection('requestFeed');
final adminFeed = root.collection('AdminFeed');
final ordersRef = root.collection('orders');

List<String> categories = [];
List<String> subCategories = [];
final timestamp = DateTime.now().toUtc().toString();
double longitude = 8.865601999999999;
double latitude = 9.8364317;
final String naira = '₦';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late StreamSubscription _userSubscription;

  void getCategories() async {
    root
        .collection("categories")
        .orderBy('item', descending: false)
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        categories.add(result.data()['item']);
      });
    });
  }

  void getSubCategories() async {
    root
        .collection('subCategory')
        .orderBy('item', descending: false)
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        subCategories.add(result.data()['item']);
      });
    });
  }

  @override
  void initState() {
    if (authId.adminId == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    }
    getCategories();
    getSubCategories();

    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthService>(context, listen: false);

    void choiceAction(String choice) {
      if (choice == HomeMenu.logout) {
        authBloc.signOutUser().then((value) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Admin Home"),
          actions: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: adminFeed.where('seen', isEqualTo: false).snapshots(),
                builder: (context, snapshot) {
                  return NotificationsCounter(
                    count: snapshot.data!.docs.length,
                    onTap: () {
                      Navigator.of(context).pushNamed('/notification');
                    },
                  );
                }),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              tooltip: 'options',
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return HomeMenu.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          backgroundColor: Colors.green),
      body: pageBody(context),
    );
  }
}

Widget pageBody(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminProfile(),
                    ));
              },
              child: HomeView(
                title: 'My Profile',
                image: 'assets/images/user.png',
                comingSoon: '',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConstructionMaterials(),
                    ));
              },
              child: HomeView(
                title: 'Products',
                image: 'assets/images/building.png',
                comingSoon: '',
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Manpower(),
                    ));
              },
              child: HomeView(
                title: 'Artisans',
                image: 'assets/images/manpower.png',
                comingSoon: '',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllUsers(),
                    ));
              },
              child: HomeView(
                title: 'Other Users',
                image: 'assets/images/users.png',
                comingSoon: '',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllDrivers(),
                    ));
              },
              child: HomeView(
                title: 'Drivers',
                image: 'assets/images/driver.png',
                comingSoon: '',
              ),
            ),
            //Product Orders
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrders(),
                    ));
              },
              child: HomeView(
                title: 'Product Orders',
                image: 'assets/images/orders.png',
                comingSoon: '',
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistory(),
                    ));
              },
              child: HomeView(
                title: 'Order History',
                image: 'assets/images/history.png',
                comingSoon: '',
              ),
            ),
            //Artisan Orders
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtisanRequests(),
                    ));
              },
              child: HomeView(
                title: 'Artisan Requests',
                image: 'assets/images/artisan_request.png',
                comingSoon: '',
              ),
            ),
          ],
        ),
      )
    ],
  );
}

class HomeView extends StatelessWidget {
  final String title;
  final String image, comingSoon;

  const HomeView(
      {Key? key,
      required this.title,
      required this.image,
      required this.comingSoon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(
              0.0,
              2.5,
            ),
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 7,
              top: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              height: 100.0,
              padding: EdgeInsets.only(
                top: 8,
                left: 9,
                right: 9,
              ),
              child: Image(
                image: AssetImage(image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMenu {
  static const String logout = 'Logout';

  static const List<String> choices = <String>[logout];
}
