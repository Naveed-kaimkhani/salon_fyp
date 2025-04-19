class ServicesModel {
  final String uid;
  final String name;
  final String imageUrl;
  final String duration;
  final String gender;
  final double price;
  final String salonId;

  ServicesModel({
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.duration,
    required this.gender,
    required this.price,
    required this.salonId,
  });

  // From JSON
  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      duration: json['duration'] ?? '',
      gender: json['gender'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      salonId: json['salonId'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'duration': duration,
      'gender': gender,
      'price': price,
      'salonId': salonId,
    };
  }

  // CopyWith
  ServicesModel copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    String? duration,
    String? gender,
    double? price,
    String? salonId,
  }) {
    return ServicesModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      gender: gender ?? this.gender,
      price: price ?? this.price,
      salonId: salonId ?? this.salonId,
    );
  }
}
