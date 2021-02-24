import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String productName;
  final String category;
  final String subCategory;
  final int unitPrice;
  final int availableUnits;
  final String adminId;
  final String productId;
  final String imageUrl;
  final bool approved;
  final String description;
  final double latitude, longitude;

  Product(
      {@required this.approved,
      @required this.availableUnits,
      this.category,
      this.imageUrl = "",
      this.description = "",
      this.longitude,
      this.latitude,
      @required this.productId,
      @required this.productName,
      @required this.unitPrice,
      @required this.subCategory,
      @required this.adminId});

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'subCategory': subCategory,
      'unitPrice': unitPrice,
      'availableUnits': availableUnits,
      'approved': approved,
      'imageUrl': imageUrl,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'category': category,
      'productId': productId,
      'adminId': adminId
    };
  }

  Product.fromFirestore(Map<String, dynamic> firestore)
      : productName = firestore['productName'],
        subCategory = firestore['subCategory'],
        unitPrice = firestore['unitPrice'],
        availableUnits = firestore['availableUnits'],
        approved = firestore['approved'],
        imageUrl = firestore['imageUrl'],
        description = firestore['description'],
        latitude = firestore['latitude'],
        longitude = firestore['longitude'],
        productId = firestore['productId'],
        category = firestore['category'],
        adminId = firestore['adminId'];
}
