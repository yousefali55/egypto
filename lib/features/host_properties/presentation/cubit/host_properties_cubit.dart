import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';

sealed class HostPropertiesState {}

final class HostPropertiesInitial extends HostPropertiesState {}

final class HostPropertiesLoading extends HostPropertiesState {}

final class HostPropertiesFailure extends HostPropertiesState {
  HostPropertiesFailure(this.message);

  final String message;
}

final class HostPropertiesLoaded extends HostPropertiesState {
  HostPropertiesLoaded(
    this.page, {
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final HostPropertiesPage page;
  final bool isLoadingMore;
  final String? loadMoreError;
}

class HostPropertiesCubit extends Cubit<HostPropertiesState> {
  HostPropertiesCubit(this._repository) : super(HostPropertiesInitial());

  static const int _pageSize = 20;
  final HostPropertiesRepo _repository;
  bool _isLoading = false;

  Future<void> loadFirstPage() async {
    if (_isLoading) return;
    _isLoading = true;
    emit(HostPropertiesLoading());
    try {
      final page = await _repository.getHostProperties(
        pageNumber: 1,
        pageSize: _pageSize,
      );
      if (!isClosed) emit(HostPropertiesLoaded(page));
    } on AppException catch (exception) {
      if (!isClosed) emit(HostPropertiesFailure(exception.message));
    } catch (_) {
      if (!isClosed) {
        emit(HostPropertiesFailure('Unable to load host properties.'));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (_isLoading || currentState is! HostPropertiesLoaded) return;
    if (!currentState.page.hasNextPage) return;

    _isLoading = true;
    emit(HostPropertiesLoaded(currentState.page, isLoadingMore: true));
    try {
      final nextPage = await _repository.getHostProperties(
        pageNumber: currentState.page.pageNumber + 1,
        pageSize: _pageSize,
      );
      if (!isClosed) {
        emit(
          HostPropertiesLoaded(
            HostPropertiesPage(
              items: [...currentState.page.items, ...nextPage.items],
              pageNumber: nextPage.pageNumber,
              totalPages: nextPage.totalPages,
              totalCount: nextPage.totalCount,
              hasPreviousPage: nextPage.hasPreviousPage,
              hasNextPage: nextPage.hasNextPage,
            ),
          ),
        );
      }
    } on AppException catch (exception) {
      if (!isClosed) {
        emit(
          HostPropertiesLoaded(
            currentState.page,
            loadMoreError: exception.message,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          HostPropertiesLoaded(
            currentState.page,
            loadMoreError: 'Unable to load more properties.',
          ),
        );
      }
    } finally {
      _isLoading = false;
    }
  }
}
