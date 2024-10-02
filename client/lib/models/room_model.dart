class Room {
  String id;
  String roomNumber;
  String address;
  String overview;
  double rentalPrice;
  int maxCapacity;
  bool wifiAvailable;
  String contactNumber;
  List<double> location;
  String owner;
  List<String> images;

  Room({
    required this.id,
    required this.roomNumber,
    required this.address,
    required this.overview,
    required this.rentalPrice,
    required this.maxCapacity,
    required this.wifiAvailable,
    required this.contactNumber,
    required this.location,
    required this.owner,
    required this.images,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      roomNumber: json['room_number'],
      address: json['address'],
      overview: json['overview'],
      rentalPrice: json['rental_price'].toDouble(),
      maxCapacity: json['max_capacity'],
      wifiAvailable: json['wifiAvailable'],
      contactNumber: json['contact_number'],
      location: List<double>.from(json['location']['coordinates']),
      owner: json['owner'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_number': roomNumber,
      'address': address,
      'overview': overview,
      'rental_price': rentalPrice,
      'max_capacity': maxCapacity,
      'wifiAvailable': wifiAvailable,
      'contact_number': contactNumber,
      'location': {'coordinates': location},
      'owner': owner,
      'images': images,
    };
  }
}
