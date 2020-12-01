import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/admin_bloc.dart';
import 'package:farmers_market/src/screens/artisans.dart';
import 'package:farmers_market/src/styles/tabbar.dart';
import 'package:farmers_market/src/widgets/navbar.dart';
import 'package:farmers_market/src/widgets/orders.dart';
import 'package:farmers_market/src/widgets/products.dart';
import 'package:farmers_market/src/widgets/profile.dart';
import 'package:farmers_market/src/widgets/vendor_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

var root = FirebaseFirestore.instance;

class Admins extends StatefulWidget {
  

  @override
  _AdminsState createState() => _AdminsState();

  static TabBar get vendorTabBar {
    return TabBar(
      unselectedLabelColor: TabBarStyles.unselectedLabelColor ,
      labelColor: TabBarStyles.labelColor ,
      indicatorColor: TabBarStyles.indicatorColor ,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.list, color: Colors.green,)),
        Tab(icon: Icon(Icons.shopping_cart, color: Colors.green,)),
        Tab(icon: Icon(Icons.person, color: Colors.green,)),
        Tab(icon: Icon(Icons.accessibility, color: Colors.green,),)
      ],
    );
  }
}

class _AdminsState extends State<Admins> {
  StreamSubscription _userSubscription;

  @override
  void initState() {
    Future.delayed(Duration.zero, (){ 
        final authBloc = Provider.of<AuthBloc>(context,listen: false);
        final vendorBloc = Provider.of<AdminBloc>(context,listen:false);
        vendorBloc.fetchVendor(authBloc.userId).then((vendor) => vendorBloc.changeAdmin(vendor));
        _userSubscription = authBloc.user.listen((user) { 
          if (user == null) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        });
    });
   
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    if (Platform.isIOS) {
      return CupertinoPageScaffold(  
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return <Widget> [
              AppNavbar.cupertinoNavBar(title: 'Admin Section',context: context),
            ];
          }, 
          body: VendorScaffold.cupertinoTabScaffold,
      ),
      );
    } else {
      return DefaultTabController(  
        length: 4,
        child: Scaffold(  
          body: NestedScrollView(  
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return <Widget> [
                AppNavbar.materialNavBar(title: 'Admin Section', tabBar: Admins.vendorTabBar)
              ];
            },
            body: TabBarView(children: <Widget>[
              Products(),
              Orders(),
              Profile(),
              Artisans(),
            ],)
          )
        ),
      );
    }
  }
}