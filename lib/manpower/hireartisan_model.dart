class HireArtisanModel {
  String workId;
  String ownerId, artisanName;
  String artisanId, startDate, status;
  int price;
  String timestamp;
  bool hasAgreed, isApproved, isComplete, seen;
  String workTitle, workDescription, address, ownerName, ownerPhoto;

  HireArtisanModel(
      {this.workId,
      this.ownerId,
      this.artisanId,
      this.workTitle,
      this.price,
      this.address,
      this.timestamp,
      this.ownerName,
      this.ownerPhoto,
      this.startDate,
      this.workDescription,
      this.hasAgreed,
      this.status,
      this.artisanName,
      this.isApproved,
        this.seen,
      this.isComplete});

  HireArtisanModel.fromMap(Map snapshot)
      : workId = snapshot['workId'] ?? '',
        ownerId = snapshot['ownerId'] ?? '',
        artisanName = snapshot['artisanName'] ?? '',
        artisanId = snapshot['artisanId'] ?? '',
        workTitle = snapshot['workTitle'] ?? '',
        price = snapshot['price'] ?? '',
        address = snapshot['address'] ?? '',
        timestamp = snapshot['timestamp'] ?? '',
        ownerName = snapshot['ownerName'] ?? '',
        ownerPhoto = snapshot['ownerPhoto'] ?? '',
        startDate = snapshot['startDate'] ?? '',
        workDescription = snapshot['workDescription'] ?? '',
        status = snapshot['status'] ?? '',
        isComplete = snapshot['isComplete'] ?? '',
        isApproved = snapshot['isApproved'] ?? '',
        seen = snapshot['seen'] ?? '',
        hasAgreed = snapshot['hasAgreed'] ?? '';

  toJson() {
    return {
      "ownerId": ownerId,
      'workId': workId,
      "artisanId": artisanId,
      "workTitle": workTitle,
      "price": price,
      "address": address,
      "timestamp": timestamp,
      "ownerName": ownerName,
      "ownerPhoto": ownerPhoto,
      "startDate": startDate,
      "workDescription": workDescription,
      "status": status,
      "seen":seen,
      "hasAgreed": hasAgreed,
      "isApproved": isApproved,
      "isComplete": isComplete,
      "artisanName": artisanName,
    };
  }
}
