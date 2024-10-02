class Apartment {
  final String? id;
  final String apartmentNumber;
  final String address;
  final String? overview;
  final double rentalPrice;
  final int floor;
  final int rooms;
  final int maxCapacity;
  final bool liftAvailable;
  final String contactNumber;
  final List<double> location;
  final String owner;
  final List<String> images;

  Apartment({
    this.id,
    required this.apartmentNumber,
    required this.address,
    this.overview,
    required this.rentalPrice,
    required this.floor,
    required this.rooms,
    required this.maxCapacity,
    required this.liftAvailable,
    required this.contactNumber,
    required this.location,
    required this.owner,
    required this.images,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['_id'],
      apartmentNumber: json['apartment_number'],
      address: json['address'],
      overview: json['overview'],
      rentalPrice: json['rental_price'].toDouble(),
      floor: json['floor'],
      rooms: json['rooms'],
      maxCapacity: json['max_capacity'],
      liftAvailable: json['liftAvailable'],
      contactNumber: json['contact_number'],
      location: List<double>.from(json['location']['coordinates']),
      owner: json['owner'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apartment_number': apartmentNumber,
      'address': address,
      'overview': overview,
      'rental_price': rentalPrice,
      'floor': floor,
      'rooms': rooms,
      'max_capacity': maxCapacity,
      'liftAvailable': liftAvailable,
      'contact_number': contactNumber,
      'location': {'coordinates': location},
      'owner': owner,
      'images': images,
    };
  }
}
