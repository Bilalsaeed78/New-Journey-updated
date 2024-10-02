class Office {
  final String? id;
  final String officeAddress;
  final String address;
  final String? overview;
  final double rentalPrice;
  final bool wifiAvailable;
  final bool acAvailable;
  final int cabinsAvailable;
  final int maxCapacity;
  final String contactNumber;
  List<double> location;
  final String owner;
  final List<String> images;

  Office({
    this.id,
    required this.officeAddress,
    required this.address,
    this.overview,
    required this.rentalPrice,
    required this.wifiAvailable,
    required this.acAvailable,
    required this.cabinsAvailable,
    required this.maxCapacity,
    required this.contactNumber,
    required this.location,
    required this.owner,
    required this.images,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['_id'],
      officeAddress: json['office_address'],
      address: json['address'],
      overview: json['overview'],
      rentalPrice: json['rental_price'].toDouble(),
      wifiAvailable: json['wifiAvailable'],
      acAvailable: json['acAvailable'],
      cabinsAvailable: json['cabinsAvailable'],
      maxCapacity: json['max_capacity'],
      contactNumber: json['contact_number'],
      location: List<double>.from(json['location']['coordinates']),
      owner: json['owner'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'office_address': officeAddress,
      'address': address,
      'overview': overview,
      'rental_price': rentalPrice,
      'wifiAvailable': wifiAvailable,
      'acAvailable': acAvailable,
      'cabinsAvailable': cabinsAvailable,
      'max_capacity': maxCapacity,
      'contact_number': contactNumber,
      'location': {'coordinates': location},
      'owner': owner,
      'images': images,
    };
  }
}
