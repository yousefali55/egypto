class HostPropertiesPage {
  const HostPropertiesPage({
    required this.items,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  final List<HostProperty> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  factory HostPropertiesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return HostPropertiesPage(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) =>
                      HostProperty.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList(growable: false)
          : const [],
      pageNumber: _asInt(json['pageNumber'], fallback: 1),
      totalPages: _asInt(json['totalPages']),
      totalCount: _asInt(json['totalCount']),
      hasPreviousPage: json['hasPreviousPage'] == true,
      hasNextPage: json['hasNextPage'] == true,
    );
  }
}

class HostProperty {
  const HostProperty({
    required this.id,
    required this.title,
    required this.status,
    required this.nightlyPrice,
    required this.city,
    required this.coverImageUrl,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String status;
  final double nightlyPrice;
  final String? city;
  final String? coverImageUrl;
  final DateTime? createdAt;

  factory HostProperty.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['nightlyPrice'];
    return HostProperty(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      nightlyPrice: rawPrice is num ? rawPrice.toDouble() : 0,
      city: json['city']?.toString(),
      coverImageUrl: json['coverImageUrl']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

int _asInt(Object? value, {int fallback = 0}) => value is num
    ? value.toInt()
    : int.tryParse(value?.toString() ?? '') ?? fallback;
