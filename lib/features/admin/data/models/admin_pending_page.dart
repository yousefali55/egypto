class AdminPendingPage {
  const AdminPendingPage({
    required this.items,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  final List<Map<String, dynamic>> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  factory AdminPendingPage.fromJson(Object? value) {
    final json = value is Map ? Map<String, dynamic>.from(value) : const {};
    final rawItems = json['items'];
    return AdminPendingPage(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList(growable: false)
          : const [],
      pageNumber: _intValue(json['pageNumber'], fallback: 1),
      totalPages: _intValue(json['totalPages']),
      totalCount: _intValue(json['totalCount']),
      hasPreviousPage: json['hasPreviousPage'] == true,
      hasNextPage: json['hasNextPage'] == true,
    );
  }
}

int _intValue(Object? value, {int fallback = 0}) => value is num
    ? value.toInt()
    : int.tryParse(value?.toString() ?? '') ?? fallback;
