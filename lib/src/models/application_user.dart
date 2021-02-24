import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  String userId, dob;
  String email,
      address,
      gender,
      phone,
      city,
      state,
      fullName,
      country,
      skill,
      imageUrl;
  bool asArtisan, isVerified, isHired, hasWorks;
  int charge;
  String experience;

  UsersModel(
      {this.email,
      this.userId,
      this.asArtisan,
      this.address,
      this.gender,
      this.phone,
      this.city,
      this.state,
      this.fullName,
      this.country,
      this.skill,
      this.isHired,
      this.hasWorks,
      this.imageUrl,
      this.experience,
      this.isVerified,
      this.dob,
      this.charge});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'asArtisan': asArtisan,
      'address': address,
      'gender': gender,
      'phone': phone,
      'city': city,
      'state': state,
      'fullName': fullName,
      'country': country,
      'skill': skill,
      'experience': experience,
      'isVerified': isVerified,
      'imageUrl': imageUrl,
      'dob': dob,
      'charge': charge,
      'isHired': isHired,
      'hasWorks': hasWorks,
    };
  }

  UsersModel.fromFirestore(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        asArtisan = firestore['asArtisan'],
        address = firestore['address'],
        gender = firestore['gender'],
        phone = firestore['phone'],
        city = firestore['city'],
        state = firestore['state'],
        fullName = firestore['fullName'],
        country = firestore['country'],
        skill = firestore['skill'],
        experience = firestore['experience'],
        isVerified = firestore['isVerified'],
        imageUrl = firestore['imageUrl'],
        dob = firestore['dob'],
        charge = firestore['charge'],
        isHired = firestore['isHired'],
        hasWorks = firestore['hasWorks'],
        email = firestore['email'];

  UsersModel.fromSnapshot(DocumentSnapshot firestore) {
    this.userId = firestore['userId'];
    this.asArtisan = firestore['asArtisan'];
    this.address = firestore['address'];
    this.gender = firestore['gender'];
    this.phone = firestore['phone'];
    this.city = firestore['city'];
    this.state = firestore['state'];
    this.fullName = firestore['fullName'];
    this.country = firestore['country'];
    this.skill = firestore['skill'];
    this.experience = firestore['experience'];
    this.isVerified = firestore['isVerified'];
    this.imageUrl = firestore['imageUrl'];
    this.dob = firestore['dob'];
    this.charge = firestore['charge'];
    this.isHired = firestore['isHired'];
    this.hasWorks = firestore['hasWorks'];
    this.email = firestore['email'];
  }
}
