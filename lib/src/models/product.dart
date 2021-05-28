import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productName;
  String category;
  String subCategory;
  int unitPrice;
  int availableUnits;
  String adminId;
  String productId;
  String imageUrl, weight;
  bool approved;
  String description;
  double latitude, longitude;

  Product(
      {this.productName,
      this.category,
      this.subCategory,
      this.unitPrice,
      this.availableUnits,
      this.adminId,
      this.productId,
      this.imageUrl,
      this.weight,
      this.approved,
      this.description,
      this.latitude,
      this.longitude});

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
      'weight': weight,
      'category': category,
      'productId': productId,
      'adminId': adminId
    };
  }

  Product.fromSnapshot(DocumentSnapshot firestore) {
    productName = firestore['productName'];
    subCategory = firestore['subCategory'];
    unitPrice = firestore['unitPrice'];
    availableUnits = firestore['availableUnits'];
    approved = firestore['approved'];
    imageUrl = firestore['imageUrl'];
    description = firestore['description'];
    latitude = firestore['latitude'];
    weight = firestore['weight'];
    longitude = firestore['longitude'];
    productId = firestore['productId'];
    category = firestore['category'];
    adminId = firestore['adminId'];
  }
}
