import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/auth/register/data/models/register_request_model.dart';
import 'package:egypto/features/auth/register/data/models/register_response_model.dart';
import 'package:egypto/features/auth/register/data/repo/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerRepo) : super(RegisterInitial());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  final RegisterRepo registerRepo;
  Future<void> register() async {
    emit(RegisterLoading());
    final request = RegisterRequestModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole!,
    );
    try {
      final response = await registerRepo.register(request);
      emit(RegisterSuccess(response: response));
    } on AppException catch (exception) {
      emit(RegisterFailure(exception: exception));
    }
  }
}
