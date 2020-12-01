class Admin {
  final String adminId;
  final String name;
  final String imageUrl;
  final String position;

  Admin({this.imageUrl, this.name, this.adminId, this.position});

  Map<String, dynamic> toMap() {
    return {
      'vendorId': adminId,
      'name': name,
      'imageUrl': imageUrl,
      'position': position
    };
  }

  factory Admin.fromFirestore(Map<String, dynamic> firestore){
    if (firestore == null) return null;

    return Admin(  
      adminId: firestore['adminId'],
      name: firestore['name'],
      imageUrl: firestore ['imageUrl'],
      position: firestore['position']
    );
  }
}