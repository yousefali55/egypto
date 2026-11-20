import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';
import 'package:egypto/features/home/data/repository/home_properties_repo.dart';
import 'package:egypto/features/home/presentation/cubit/home_properties_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'failed searches retain filters for retry and reset to no parameters',
    () async {
      final repository = _HomePropertiesRepo();
      final cubit = HomePropertiesCubit(repository);
      final filters = SearchPropertiesFilters(
        city: 'Port Said',
        guests: 4,
        checkIn: DateTime(2026, 11, 10),
        checkOut: DateTime(2026, 11, 15),
      );
      repository.error = StateError('Temporary failure');

      await cubit.search(filters);

      expect(cubit.state, isA<HomePropertiesFailure>());
      expect(cubit.currentFilters, filters);
      expect(repository.requests, [filters]);

      repository.error = null;
      await cubit.load();
      expect(repository.requests.last, filters);
      expect(cubit.state, isA<HomePropertiesLoaded>());

      await cubit.search(const SearchPropertiesFilters());
      expect(repository.requests.last.toQueryParameters(), isEmpty);
      expect(cubit.currentFilters.toQueryParameters(), isEmpty);

      await cubit.close();
    },
  );

  test('empty API results stay empty in the loaded state', () async {
    final repository = _HomePropertiesRepo();
    final cubit = HomePropertiesCubit(repository);

    await cubit.load();

    final state = cubit.state as HomePropertiesLoaded;
    expect(state.page.items, isEmpty);

    await cubit.close();
  });
}

class _HomePropertiesRepo extends HomePropertiesRepo {
  _HomePropertiesRepo() : super(ApiService(Dio()));

  final List<SearchPropertiesFilters> requests = [];
  Object? error;

  @override
  Future<SearchPropertiesPage> searchProperties({
    SearchPropertiesFilters filters = const SearchPropertiesFilters(),
  }) async {
    requests.add(filters);
    final failure = error;
    if (failure != null) throw failure;
    return const SearchPropertiesPage(
      items: [],
      pageNumber: 1,
      totalPages: 0,
      totalCount: 0,
      hasPreviousPage: false,
      hasNextPage: false,
    );
  }
}
