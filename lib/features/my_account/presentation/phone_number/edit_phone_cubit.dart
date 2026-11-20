import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/phone_number/egyptian_phone_number.dart';

sealed class EditPhoneState {}

final class EditPhoneInitial extends EditPhoneState {}

final class EditPhoneLoading extends EditPhoneState {}

final class EditPhoneSuccess extends EditPhoneState {
  EditPhoneSuccess(this.phone);

  final String phone;
}

final class EditPhoneFailure extends EditPhoneState {
  EditPhoneFailure(this.errorType);

  final AppErrorType errorType;
}

class EditPhoneCubit extends Cubit<EditPhoneState> {
  EditPhoneCubit(this._repository) : super(EditPhoneInitial());

  final MyAccountRepo _repository;

  Future<void> savePhone(String input) async {
    if (state is EditPhoneLoading) return;

    final phone = normalizeEgyptianMobileNumber(input);
    if (phone == null) {
      emit(EditPhoneFailure(AppErrorType.validation));
      return;
    }

    emit(EditPhoneLoading());
    try {
      final confirmedPhone = await _repository.updatePhone(phone);
      if (!isClosed) emit(EditPhoneSuccess(confirmedPhone ?? phone));
    } on AppException catch (exception) {
      if (!isClosed) emit(EditPhoneFailure(exception.errorType));
    } catch (_) {
      if (!isClosed) emit(EditPhoneFailure(AppErrorType.unknown));
    }
  }
}
