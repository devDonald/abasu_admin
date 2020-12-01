import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/models/admin.dart';
import 'package:farmers_market/src/services/firebase_storage_service.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

class AdminBloc {
  final _db = FirestoreService();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>();
  final _adminId = BehaviorSubject<String>();
  final _adminSaved = PublishSubject<bool>();
  final _admin = BehaviorSubject<Admin>();
  final _isUploading = BehaviorSubject<bool>();

  final _picker = ImagePicker();
  final storageService = FirebaseStorageService();
  var uuid = Uuid();

  //Getters
  Future<Admin> fetchVendor(String userId) => _db.fetchAdmin(userId);
  Stream<String> get name => _name.stream.transform(validateName);
  Stream<String> get position =>
      _description.stream.transform(validateDescription);
  Stream<String> get imageUrl => _imageUrl.stream;
  Stream<bool> get adminSaved => _adminSaved.stream;
  Stream<Admin> get admin => _admin.stream;
  Stream<bool> get isUploading => _isUploading.stream;
  Stream<bool> get isValid => CombineLatestStream.combine2(
      name, position, (a, b) => true).asBroadcastStream();

  //Setters
  Function(String) get changeName => _name.sink.add;
  Function(String) get changePosition => _description.sink.add;
  Function(String) get changeImageUrl => _imageUrl.sink.add;
  Function(Admin) get changeAdmin => _admin.sink.add;
  Function(String) get changeAdminId => _adminId.sink.add;

  //Dispose
  dispose() {
    _name.close();
    _description.close();
    _imageUrl.close();
    _adminSaved.close();
    _admin.close();
    _adminId.close();
    _isUploading.close();
  }

  //Validators
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name != null) {
      if (name.length >= 3 && name.length <= 20) {
        sink.add(name.trim());
      } else {
        if (name.length < 3) {
          sink.addError('3 Character Minimum');
        } else {
          sink.addError('20 Character Maximum');
        }
      }
    }
  });

  final validateDescription = StreamTransformer<String, String>.fromHandlers(
      handleData: (position, sink) {
    if (position != null) {
      if (position.length >= 2) {
        sink.add(position.trim());
      } else {
        if (position.length < 2) {
          sink.addError('2 Character Minimum');
        }
      }
    }
  });

  //Save Record
  Future<void> saveVendor() async {
    var vendor = Admin(
        position: _description.value,
        imageUrl: _imageUrl.value,
        name: _name.value,
        adminId: _adminId.value);

    return _db.setAdmin(vendor).then((value) {
      _adminSaved.sink.add(true);
      changeAdmin(vendor);
    }).catchError((error) => _adminSaved.sink.add(false));
  }

  pickImage() async {
    PickedFile image;
    File croppedFile;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Get Image From Device
      image = await _picker.getImage(source: ImageSource.gallery);

      //Upload to Firebase
      if (image != null) {
        _isUploading.sink.add(true);

        //Get Image Properties
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(image.path);

        //CropImage
        if (properties.height > properties.width) {
          var yoffset = (properties.height - properties.width) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path, 0,
              yoffset.toInt(), properties.width, properties.width);
        } else if (properties.width > properties.height) {
          var xoffset = (properties.width - properties.height) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path,
              xoffset.toInt(), 0, properties.height, properties.height);
        } else {
          croppedFile = File(image.path);
        }

        //Resize
        File compressedFile = await FlutterNativeImage.compressImage(
            croppedFile.path,
            quality: 100,
            targetHeight: 600,
            targetWidth: 600);

        var imageUrl =
            await storageService.uploadAdminImage(compressedFile, uuid.v4());
        changeImageUrl(imageUrl);
        _isUploading.sink.add(false);
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
