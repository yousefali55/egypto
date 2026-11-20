import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';

class HomePropertiesRepo {
  HomePropertiesRepo(this._apiService);

  final ApiService _apiService;

  Future<SearchPropertiesPage> searchProperties({
    SearchPropertiesFilters filters = const SearchPropertiesFilters(),
  }) async {
    try {
      return await _apiService.searchProperties(filters.toQueryParameters());
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }
}
