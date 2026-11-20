part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterRoleRequired extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterResponseModel response;
  final String email;

  RegisterSuccess({required this.response, required this.email});
}

final class RegisterFailure extends RegisterState {
  final AppException exception;

  RegisterFailure({required this.exception});
}
