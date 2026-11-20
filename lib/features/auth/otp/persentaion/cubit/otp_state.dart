part of 'otp_cubit.dart';

sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpVerifying extends OtpState {}

final class OtpVerified extends OtpState {}

final class OtpVerificationFailure extends OtpState {
  OtpVerificationFailure(this.exception);

  final AppException exception;
}

final class OtpResending extends OtpState {}

final class OtpResent extends OtpState {}

final class OtpResendFailure extends OtpState {
  OtpResendFailure(this.exception);

  final AppException exception;
}
