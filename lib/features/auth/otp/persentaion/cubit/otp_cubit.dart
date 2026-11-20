import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/auth/otp/data/models/otp_requests.dart';
import 'package:egypto/features/auth/otp/data/repository/otp_repo.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({required this.otpRepo, required this.email}) : super(OtpInitial());

  final OtpRepo otpRepo;
  final String email;
  bool _verificationInFlight = false;
  bool _resendInFlight = false;

  Future<void> verify(String otp) async {
    final normalizedOtp = otp.trim();
    if (_verificationInFlight ||
        _resendInFlight ||
        !RegExp(r'^[0-9]{6}$').hasMatch(normalizedOtp)) {
      return;
    }

    _verificationInFlight = true;
    emit(OtpVerifying());
    try {
      await otpRepo.verifyOtp(
        VerifyOtpRequest(email: email, otp: normalizedOtp),
      );
      emit(OtpVerified());
    } on AppException catch (exception) {
      emit(OtpVerificationFailure(exception));
    } catch (_) {
      emit(
        OtpVerificationFailure(
          const AppException(
            errorType: AppErrorType.unknown,
            message: 'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      _verificationInFlight = false;
    }
  }

  Future<void> resend() async {
    if (_verificationInFlight || _resendInFlight) return;

    _resendInFlight = true;
    emit(OtpResending());
    try {
      await otpRepo.resendOtp(ResendOtpRequest(email: email));
      emit(OtpResent());
    } on AppException catch (exception) {
      emit(OtpResendFailure(exception));
    } catch (_) {
      emit(
        OtpResendFailure(
          const AppException(
            errorType: AppErrorType.unknown,
            message: 'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      _resendInFlight = false;
    }
  }
}
