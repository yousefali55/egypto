import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';
import 'package:egypto/features/home/data/repository/home_properties_repo.dart';

sealed class HomePropertiesState {}

final class HomePropertiesLoading extends HomePropertiesState {}

final class HomePropertiesFailure extends HomePropertiesState {
  HomePropertiesFailure(this.message);

  final String message;
}

final class HomePropertiesLoaded extends HomePropertiesState {
  HomePropertiesLoaded(this.page);

  final SearchPropertiesPage page;
}

class HomePropertiesCubit extends Cubit<HomePropertiesState> {
  HomePropertiesCubit(this._repository) : super(HomePropertiesLoading());

  final HomePropertiesRepo _repository;
  SearchPropertiesFilters _currentFilters = const SearchPropertiesFilters();
  SearchPropertiesFilters? _activeFilters;
  int _requestId = 0;
  bool _loading = false;

  SearchPropertiesFilters get currentFilters => _currentFilters;

  Future<void> load() => _fetch(_currentFilters);

  Future<void> search(SearchPropertiesFilters filters) {
    _currentFilters = filters;
    return _fetch(filters);
  }

  Future<void> _fetch(SearchPropertiesFilters filters) async {
    if (_loading && filters == _activeFilters) return;
    final requestId = ++_requestId;
    _loading = true;
    _activeFilters = filters;
    emit(HomePropertiesLoading());
    try {
      final page = await _repository.searchProperties(filters: filters);
      if (!isClosed && requestId == _requestId) {
        emit(HomePropertiesLoaded(page));
      }
    } on AppException catch (exception) {
      if (!isClosed && requestId == _requestId) {
        emit(HomePropertiesFailure(exception.message));
      }
    } catch (_) {
      if (!isClosed && requestId == _requestId) {
        emit(HomePropertiesFailure('Unable to load properties.'));
      }
    } finally {
      if (requestId == _requestId) _loading = false;
    }
  }
}
