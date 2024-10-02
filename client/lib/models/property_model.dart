class Property {
  final String? id;
  final String propertyId;
  final String type;
  final String ownerId;
  double? distance;
  final bool isOccupied;

  Property({
    this.id = '',
    this.isOccupied = false,
    this.distance,
    required this.propertyId,
    required this.type,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'propertyId': propertyId,
      'type': type,
      'ownerId': ownerId,
      'isOccupied': isOccupied.toString(),
    };

    if (id != null && id!.isNotEmpty) {
      json['id'] = id;
    }

    if (distance != null) {
      json['distance'] = distance;
    }

    return json;
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'],
      // ignore: prefer_null_aware_operators
      distance: json['distance'] != null ? json['distane'].toDouble() : null,
      isOccupied: json['isOccupied'] as bool? ?? false,
      propertyId: json['propertyId'],
      type: json['type'] ?? '',
      ownerId: json['ownerId'],
    );
  }
}
