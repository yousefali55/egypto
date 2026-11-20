class CreatePropertyRequest {
  const CreatePropertyRequest({
    required this.title,
    required this.description,
    required this.beds,
    required this.rooms,
    required this.guests,
    required this.bathrooms,
    required this.nightlyPrice,
    required this.location,
    required this.amenityIds,
  });

  final String title;
  final String description;
  final int beds;
  final int rooms;
  final int guests;
  final int bathrooms;
  final double nightlyPrice;
  final PropertyLocationRequest location;
  final List<String> amenityIds;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'beds': beds,
    'rooms': rooms,
    'guests': guests,
    'bathrooms': bathrooms,
    'nightlyPrice': nightlyPrice,
    'location': location.toJson(),
    'amenityIds': amenityIds,
  };
}

class PropertyLocationRequest {
  const PropertyLocationRequest({
    required this.country,
    required this.governorate,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String country;
  final String governorate;
  final String city;
  final String address;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
    'country': country,
    'governorate': governorate,
    'city': city,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class Amenity {
  const Amenity({required this.id, required this.name});

  final String id;
  final String name;

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );
}
