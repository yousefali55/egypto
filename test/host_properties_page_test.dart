import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'parses property fields, pagination, and unrecognized status values',
    () {
      final page = HostPropertiesPage.fromJson({
        'items': [
          {
            'id': '475f7139-9e73-4a9d-bfc5-44e5d792eff3',
            'title': 'شقة ببورسعيد',
            'status': 'AwaitingInspection',
            'nightlyPrice': 1000.00,
            'city': 'Port Said',
            'coverImageUrl': 'uploads/listing.jpg',
            'createdAt': '2026-10-20T18:28:07.323993Z',
          },
        ],
        'pageNumber': 1,
        'totalPages': 2,
        'totalCount': 21,
        'hasPreviousPage': false,
        'hasNextPage': true,
      });

      expect(page.items, hasLength(1));
      expect(page.items.single.id, '475f7139-9e73-4a9d-bfc5-44e5d792eff3');
      expect(page.items.single.nightlyPrice, 1000.0);
      expect(page.items.single.status, 'AwaitingInspection');
      expect(page.items.single.coverImageUrl, 'uploads/listing.jpg');
      expect(
        page.items.single.createdAt,
        DateTime.utc(2026, 10, 20, 18, 28, 7, 323, 993),
      );
      expect(page.pageNumber, 1);
      expect(page.totalPages, 2);
      expect(page.totalCount, 21);
      expect(page.hasPreviousPage, isFalse);
      expect(page.hasNextPage, isTrue);
    },
  );
}
