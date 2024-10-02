class RequestModel {
  String? id;
  String ownerId;
  String propertyId;
  String guestId;
  String status;
  int bid;

  RequestModel({
    this.id,
    required this.ownerId,
    required this.propertyId,
    required this.guestId,
    required this.status,
    required this.bid,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json['_id'],
        ownerId: json['ownerId'],
        propertyId: json['propertyId'],
        guestId: json['guestId'],
        status: json['status'],
        bid: json['bid'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id ?? '',
        'ownerId': ownerId,
        'propertyId': propertyId,
        'guestId': guestId,
        'status': status,
        'bid': bid,
      };
}
