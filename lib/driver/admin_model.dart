import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String adminId;
  String name;
  String email;
  String phone;
  String gender;
  String state;
  String city, marital;
  String dob, address;
  String photo;
  int year, month, day;
  bool isVerified;
  String country;

  AdminModel({
    this.adminId,
    this.name,
    this.email,
    this.address,
    this.phone,
    this.gender,
    this.state,
    this.city,
    this.dob,
    this.photo,
    this.isVerified,
    this.country,
    this.marital,
    this.year,
    this.month,
    this.day,
  });

  Map<String, dynamic> toMap() {
    return {
      "adminId": adminId,
      "email": email,
      'name': name,
      'address': address,
      'gender': gender,
      'state': state,
      'dob': dob,
      'phone': phone,
      'country': country,
      'profile': photo,
      'isVerified': false,
      'isAdmin': false,
      'city': city,
      'marital': marital,
      'year': year,
      'month': month,
      'day': day,
    };
  }

  AdminModel.fromFirestore(Map<String, dynamic> snapshot)
      : adminId = snapshot['adminId'] ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        address = snapshot['address'] ?? '',
        phone = snapshot['phone'] ?? '',
        gender = snapshot['gender'] ?? '',
        state = snapshot['state'] ?? '',
        city = snapshot['city'] ?? '',
        dob = snapshot['dob'] ?? '',
        photo = snapshot['photo'] ?? '',
        isVerified = snapshot['isVerified'] ?? '',
        marital = snapshot['marital'] ?? '',
        year = snapshot['year'] ?? '',
        month = snapshot['month'] ?? '',
        day = snapshot['day'] ?? '',
        country = snapshot['country'] ?? '';

  toJson() {
    return {
      "adminId": adminId,
      "email": email,
      'name': name,
      'address': address,
      'gender': gender,
      'state': state,
      'dob': dob,
      'phone': phone,
      'country': country,
      'photo': photo,
      'city': city,
      'isVerified': isVerified,
      'marital': marital,
      'month': month,
      'year': year,
      'day': day,
    };
  }

  AdminModel.fromSnapshot(DocumentSnapshot snapshot) {
    this.adminId = snapshot['adminId'];
    this.name = snapshot['name'];
    this.email = snapshot['email'];
    this.address = snapshot['address'];
    this.phone = snapshot['phone'];
    this.gender = snapshot['gender'];
    this.state = snapshot['state'];
    this.city = snapshot['city'];
    this.dob = snapshot['dob'];
    this.photo = snapshot['photo'];
    this.isVerified = snapshot['isVerified'];
    this.marital = snapshot['marital'];
    this.year = snapshot['year'];
    this.month = snapshot['month'];
    this.day = snapshot['day'];
    this.country = snapshot['country'];
  }
}
