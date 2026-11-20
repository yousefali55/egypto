class PropertyDetails {
  const PropertyDetails({
    required this.id,
    required this.title,
    this.description,
    this.city,
    this.address,
    this.nightlyPrice,
    this.guests,
    this.coverImageUrl,
  });

  final String id;
  final String title;
  final String? description;
  final String? city;
  final String? address;
  final double? nightlyPrice;
  final int? guests;
  final String? coverImageUrl;

  factory PropertyDetails.fromJson(Map<String, dynamic> value) {
    final json = value['property'] is Map
        ? Map<String, dynamic>.from(value['property'] as Map)
        : value;
    final location = json['location'] is Map
        ? Map<String, dynamic>.from(json['location'] as Map)
        : const <String, dynamic>{};
    final price = json['nightlyPrice'];
    final capacity = json['guests'];
    return PropertyDetails(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      city: (json['city'] ?? location['city'])?.toString(),
      address: (json['address'] ?? location['address'])?.toString(),
      nightlyPrice: price is num ? price.toDouble() : null,
      guests: capacity is num ? capacity.toInt() : null,
      coverImageUrl: (json['coverImageUrl'] ?? json['imageUrl'])?.toString(),
    );
  }
}
