import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/features/auth/login/data/model/login_request_model.dart';
import 'package:egypto/features/auth/login/data/model/login_response_model.dart';
import 'package:egypto/features/auth/login/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo, this.tokenStorage) : super(LoginInitial());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginRepo loginRepo;
  final TokenStorage tokenStorage;

  Future<void> login() async {
    emit(LoginLoading());
    final request = LoginRequestModel(
      email: emailController.text,
      password: passwordController.text,
    );
    try {
      final response = await loginRepo.login(request);

      await tokenStorage.saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      emit(LoginSuccess(responseModel: response));
    } on AppException catch (exception) {
      emit(LoginFailure(exception: exception));
    } catch (_) {
      emit(
        LoginFailure(
          exception: AppException(
            errorType: AppErrorType.unknown,
            message: 'Something went wrong. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
