class SearchPropertiesPage {
  const SearchPropertiesPage({
    required this.items,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  final List<SearchProperty> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  factory SearchPropertiesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return SearchPropertiesPage(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) =>
                      SearchProperty.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList(growable: false)
          : const [],
      pageNumber: _pageInteger(json['pageNumber'], 1),
      totalPages: _pageInteger(json['totalPages'], 0),
      totalCount: _pageInteger(json['totalCount'], 0),
      hasPreviousPage: json['hasPreviousPage'] == true,
      hasNextPage: json['hasNextPage'] == true,
    );
  }
}

class SearchProperty {
  const SearchProperty({
    required this.id,
    required this.title,
    required this.nightlyPrice,
    required this.city,
    required this.coverImageUrl,
  });

  final String id;
  final String title;
  final double nightlyPrice;
  final String? city;
  final String? coverImageUrl;

  factory SearchProperty.fromJson(Map<String, dynamic> json) => SearchProperty(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    nightlyPrice: json['nightlyPrice'] is num
        ? (json['nightlyPrice'] as num).toDouble()
        : 0,
    city: json['city']?.toString(),
    coverImageUrl: json['coverImageUrl']?.toString(),
  );
}

int _pageInteger(Object? value, int fallback) => value is num
    ? value.toInt()
    : int.tryParse(value?.toString() ?? '') ?? fallback;
