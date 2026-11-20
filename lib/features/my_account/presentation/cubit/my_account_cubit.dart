import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:flutter/foundation.dart';

sealed class MyAccountState {}

final class MyAccountInitial extends MyAccountState {}

final class MyAccountLoading extends MyAccountState {}

final class MyAccountSessionRestored extends MyAccountState {}

final class MyAccountUnauthenticated extends MyAccountState {}

final class MyAccountLoaded extends MyAccountState {
  MyAccountLoaded(this.profile, {this.isActivatingHost = false});

  final UserProfileModel profile;
  final bool isActivatingHost;
}

final class MyAccountFailure extends MyAccountState {
  MyAccountFailure({required this.message, this.profile});

  final String message;
  final UserProfileModel? profile;
}

class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit(
    this._repository,
    this._tokenStorage,
    this._refreshTokenService,
  ) : super(MyAccountInitial());

  final MyAccountRepo _repository;
  final TokenStorage _tokenStorage;
  final RefreshTokenService _refreshTokenService;
  Future<void>? _activeLoad;
  Future<bool>? _activeRefresh;
  Future<bool>? _sessionRestore;
  bool _isActivatingHost = false;

  Future<bool> restoreSession() {
    final activeRestore = _sessionRestore;
    if (activeRestore != null) {
      _log('Session restoration already requested; reusing its result.');
      return activeRestore;
    }

    final restore = _restoreSession();
    _sessionRestore = restore;
    restore.then((hasSession) {
      if (!hasSession &&
          state is MyAccountFailure &&
          identical(_sessionRestore, restore)) {
        _sessionRestore = null;
      }
    });
    return restore;
  }

  Future<void> loadProfile({bool forceSessionRestore = false}) async {
    if (forceSessionRestore) _sessionRestore = null;

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

  Future<bool> refreshProfile() {
    final activeRefresh = _activeRefresh;
    if (activeRefresh != null) return activeRefresh;

    final activeLoad = _activeLoad;
    if (activeLoad != null) {
      return activeLoad.then((_) => state is MyAccountLoaded);
    }

    final refresh = _refreshProfile();
    _activeRefresh = refresh;
    refresh.whenComplete(() {
      if (identical(_activeRefresh, refresh)) _activeRefresh = null;
    });
    return refresh;
  }

  Future<bool> activateHost() async {
    final currentState = state;
    if (currentState is! MyAccountLoaded ||
        currentState.profile.isHost ||
        _isActivatingHost) {
      return false;
    }

    _isActivatingHost = true;
    emit(MyAccountLoaded(currentState.profile, isActivatingHost: true));
    try {
      final profile = await _repository.activateHost();
      if (isClosed) return false;
      emit(MyAccountLoaded(profile));
      return true;
    } on AppException catch (exception) {
      _log('Host activation failed (${exception.errorType.name}).');
      if (!isClosed) emit(MyAccountLoaded(currentState.profile));
      return false;
    } catch (error) {
      _log('Host activation failed (${error.runtimeType}).');
      if (!isClosed) emit(MyAccountLoaded(currentState.profile));
      return false;
    } finally {
      _isActivatingHost = false;
    }
  }

  Future<bool> _refreshProfile() async {
    final currentState = state;
    if (currentState is! MyAccountLoaded) return false;

    try {
      final profile = await _repository.getProfile();
      if (isClosed) return false;
      _log('Profile refreshed successfully.');
      emit(MyAccountLoaded(profile));
      return true;
    } on AppException catch (exception) {
      _log('Profile refresh failed (${exception.errorType.name}).');
      return false;
    } catch (error) {
      _log('Profile refresh failed (${error.runtimeType}).');
      return false;
    }
  }

  Future<void> _loadProfile() async {
    final hasSession = await restoreSession();
    if (isClosed || !hasSession) return;

    emit(MyAccountLoading());
    try {
      final profile = await _repository.getProfile();
      if (isClosed) return;
      _log('Profile restored for the stored session.');
      emit(MyAccountLoaded(profile));
    } on AppException catch (exception) {
      _log('Profile request failed (${exception.errorType.name}).');
      await _emitFailureOrUnauthenticated(exception);
    } catch (error) {
      _log('Profile request failed (${error.runtimeType}).');
      await _emitFailureOrUnauthenticated();
    }
  }

  Future<bool> _restoreSession() async {
    _log('Session restoration started.');
    try {
      final storedTokens = await Future.wait([
        _tokenStorage.getAccessToken(),
        _tokenStorage.getRefreshToken(),
      ]);
      final accessToken = storedTokens[0];
      final refreshToken = storedTokens[1];
      final hasAccessToken = accessToken != null && accessToken.isNotEmpty;
      final hasRefreshToken = refreshToken != null && refreshToken.isNotEmpty;

      _log(
        'Stored session found (access=$hasAccessToken, '
        'refresh=$hasRefreshToken).',
      );

      if (!hasAccessToken && !hasRefreshToken) {
        if (!isClosed) emit(MyAccountUnauthenticated());
        _log('Session restoration finished (guest session).');
        return false;
      }

      if (!hasAccessToken) {
        _log(
          'Access token missing; attempting refresh with stored refresh token.',
        );
        final refreshed = await _refreshTokenService.refreshToken();
        if (!refreshed) {
          await _tokenStorage.clearTokens();
          if (!isClosed) emit(MyAccountUnauthenticated());
          _log('Session restoration finished (refresh rejected).');
          return false;
        }
      }

      if (isClosed) return false;
      emit(MyAccountSessionRestored());
      _log('Session restoration finished (credentials restored).');
      return true;
    } catch (error) {
      _log('Session restoration failed (${error.runtimeType}).');
      if (!isClosed) {
        emit(MyAccountFailure(message: 'تعذر تحميل بيانات حسابك'));
      }
      return false;
    }
  }

  Future<void> _emitFailureOrUnauthenticated([AppException? exception]) async {
    String? accessToken;
    try {
      accessToken = await _tokenStorage.getAccessToken();
    } catch (error) {
      _log(
        'Could not read credentials after profile failure (${error.runtimeType}).',
      );
      if (!isClosed) {
        emit(MyAccountFailure(message: 'تعذر تحميل بيانات حسابك'));
      }
      return;
    }
    if (isClosed) return;
    if (accessToken == null || accessToken.isEmpty) {
      _sessionRestore = Future<bool>.value(false);
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
    _sessionRestore = Future<bool>.value(false);
    _log('Explicit logout completed.');
    emit(MyAccountUnauthenticated());
  }

  void applyPhoneNumber(String phone) {
    final currentState = state;
    if (currentState is! MyAccountLoaded) return;

    final profile = currentState.profile;
    emit(
      MyAccountLoaded(
        UserProfileModel(
          id: profile.id,
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: profile.email,
          phone: phone,
          isHost: profile.isHost,
          isAdmin: profile.isAdmin,
          identityVerificationStatus: profile.identityVerificationStatus,
          createdAt: profile.createdAt,
        ),
      ),
    );
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[Auth] $message');
  }
}
