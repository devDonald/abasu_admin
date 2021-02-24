import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/models/application_user.dart';

class Notifications {
  String type;
  String ownerId;
  String artisanId, sub;
  bool seen;
  Timestamp timestamp;
  UsersModel user;

  Notifications(
      {this.type,
      this.ownerId,
      this.artisanId,
      this.seen,
      this.timestamp,
      this.user,
      this.sub});

  factory Notifications.fromDocument(DocumentSnapshot docs) {
    return Notifications(
      type: docs["type"],
      ownerId: docs["ownerId"],
      artisanId: docs["artisanId"],
      seen: docs["seen"],
      timestamp: docs["timestamp"],
      sub: docs["sub"],
    );
  }

  Future<void> loadUser() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("users")
        .doc(this.ownerId)
        .get();
    if (ds != null) this.user = UsersModel.fromSnapshot(ds);
  }
}
