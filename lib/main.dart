import 'package:farmers_market/authentication/login.dart';
import 'package:farmers_market/construction/add_products.dart';
import 'package:farmers_market/construction/construction_materials.dart';
import 'package:farmers_market/construction/edit_product.dart';
import 'package:farmers_market/construction/product_details.dart';
import 'package:farmers_market/construction/products_menu.dart';
import 'package:farmers_market/construction/sub_materials.dart';
import 'package:farmers_market/driver/all_driver.dart';
import 'package:farmers_market/driver/driver_profile.dart';
import 'package:farmers_market/manpower/all_manpower.dart';
import 'package:farmers_market/manpower/manpower.dart';
import 'package:farmers_market/providers/add_driver_provider.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/screens/notifications.dart';
import 'package:farmers_market/src/screens/profile.dart';
import 'package:farmers_market/src/screens/splash_screen.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'authentication/signup.dart';
import 'manpower/artisan_profile.dart';

final authId = AuthService();
final addDriver = AddDriverProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authId),
        ChangeNotifierProvider(create: (context) => addDriver),
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
        ),
        // See implementation details in next sections
      ],
      child: MyApp(),
    ),
  );

  @override
  void dispose() {
    authId.dispose();
    addDriver.dispose();
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final deviceWidth = MediaQuery.of(context).size.width;
    //final deviceHeight = MediaQuery.of(context).size.height;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //default theme

      initialRoute: '/splash',
      routes: {
        '/home': (context) => AdminHome(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/adminProfile': (context) => AdminProfile(),
        '/construction': (context) => ConstructionMaterials(),
        '/addProducts': (context) => AddProducts(),
        '/editProducts': (context) => EditProduct(),
        '/productMenu': (context) => ProductMenu(),
        '/productDetails': (context) => ProductDetails(),
        '/productSub': (context) => SubCategory(),
        '/allDrivers': (context) => AllDrivers(),
        '/driverProfile': (context) => DriverProfile(),
        '/artisanProfile': (context) => ArtisanProfile(),
        '/allManpower': (context) => AllManpower(),
        '/manpower': (context) => Manpower(),
        '/notification': (context) => NotificationCenter(),
      },
    );
  }
}
