import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';

sealed class MyAccountState {}

final class MyAccountInitial extends MyAccountState {}

final class MyAccountLoading extends MyAccountState {}

final class MyAccountUnauthenticated extends MyAccountState {}

final class MyAccountLoaded extends MyAccountState {
  MyAccountLoaded(this.profile);

  final UserProfileModel profile;
}

final class MyAccountFailure extends MyAccountState {
  MyAccountFailure({required this.message, this.profile});

  final String message;
  final UserProfileModel? profile;
}

class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit(this._repository, this._tokenStorage)
    : super(MyAccountInitial());

  final MyAccountRepo _repository;
  final TokenStorage _tokenStorage;
  Future<void>? _activeLoad;

  Future<void> loadProfile() async {
    final activeLoad = _activeLoad;
    if (activeLoad != null) return activeLoad;

    final load = _loadProfile();
    _activeLoad = load;
    try {
      await load;
    } finally {
      if (identical(_activeLoad, load)) _activeLoad = null;
    }
  }

  Future<void> _loadProfile() async {
    String? accessToken;
    try {
      accessToken = await _tokenStorage.getAccessToken();
    } catch (_) {
      if (!isClosed) {
        emit(MyAccountFailure(message: 'تعذر تحميل بيانات حسابك'));
      }
      return;
    }
    if (isClosed) return;
    if (accessToken == null || accessToken.isEmpty) {
      emit(MyAccountUnauthenticated());
      return;
    }

    emit(MyAccountLoading());
    try {
      final profile = await _repository.getProfile();
      if (isClosed) return;
      emit(MyAccountLoaded(profile));
    } on AppException catch (exception) {
      await _emitFailureOrUnauthenticated(exception);
    } catch (_) {
      await _emitFailureOrUnauthenticated();
    }
  }

  Future<void> _emitFailureOrUnauthenticated([AppException? exception]) async {
    String? accessToken;
    try {
      accessToken = await _tokenStorage.getAccessToken();
    } catch (_) {
      if (!isClosed) {
        emit(MyAccountFailure(message: 'تعذر تحميل بيانات حسابك'));
      }
      return;
    }
    if (isClosed) return;
    if (accessToken == null || accessToken.isEmpty) {
      emit(MyAccountUnauthenticated());
      return;
    }

    emit(
      MyAccountFailure(
        message: exception?.errorType == AppErrorType.unauthorized
            ? 'تعذر التحقق من الجلسة. حاول مرة أخرى.'
            : 'تعذر تحميل بيانات حسابك',
      ),
    );
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    if (isClosed) return;
    emit(MyAccountUnauthenticated());
  }
}
