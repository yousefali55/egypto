part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterResponseModel response;

  new({required this.response});
}

final class RegisterFailure extends RegisterState {
  final AppException exception;

  new({required this.exception});
}
