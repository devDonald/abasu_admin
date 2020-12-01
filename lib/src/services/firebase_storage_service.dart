import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {

  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(File file, String fileName) async {
    var snapshot = await storage.ref()
        .child('productImages/$fileName')
        .putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

    Future<String> uploadAdminImage(File file, String fileName) async {
    var snapshot = await storage.ref()
        .child('adminImages/$fileName')
        .putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

}