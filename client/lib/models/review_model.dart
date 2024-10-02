class Review {
  final String? id;
  final String userId;
  final String propertyId;
  final String type;
  final double rating;
  final String comments;

  Review({
    this.id,
    required this.userId,
    required this.propertyId,
    required this.type,
    required this.rating,
    required this.comments,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      userId: json['user_id']['_id'],
      propertyId: json['property_id'],
      type: json['type'],
      rating: (json['rating'] as num).toDouble(),
      comments: json['comments'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? "",
      'user_id': userId,
      'property_id': propertyId,
      'type': type,
      'rating': rating.toString(),
      'comments': comments,
    };
  }
}
