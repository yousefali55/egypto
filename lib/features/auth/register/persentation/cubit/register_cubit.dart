import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/auth/register/data/models/register_request_model.dart';
import 'package:egypto/features/auth/register/data/models/register_response_model.dart';
import 'package:egypto/features/auth/register/data/repo/register_repo.dart';
import 'package:flutter/material.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerRepo) : super(RegisterInitial());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  final RegisterRepo registerRepo;
  bool _registrationInFlight = false;

  Future<void> register() async {
    if (_registrationInFlight) return;
    final role = selectedRole;
    if (role == null) {
      emit(RegisterRoleRequired());
      return;
    }

    final submittedEmail = emailController.text.trim();
    _registrationInFlight = true;
    emit(RegisterLoading());
    final request = RegisterRequestModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: submittedEmail,
      password: passwordController.text,
      role: role,
    );
    try {
      final response = await registerRepo.register(request);
      emit(RegisterSuccess(response: response, email: submittedEmail));
    } on AppException catch (exception) {
      emit(RegisterFailure(exception: exception));
    } catch (_) {
      emit(
        RegisterFailure(
          exception: const AppException(
            errorType: AppErrorType.unknown,
            message: 'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      _registrationInFlight = false;
    }
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
