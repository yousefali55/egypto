import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/auth/register/data/repo/register_repo.dart';
import 'package:egypto/features/auth/register/persentation/cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'registration forwards the submitted email and ignores duplicate taps',
    () async {
      final response = Completer<ResponseBody>();
      final requestStarted = Completer<void>();
      var requestCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter((options) {
          requestCount++;
          if (!requestStarted.isCompleted) requestStarted.complete();
          expect(options.uri.path, '/api/v1/auth/register');
          return response.future;
        });
      final cubit = RegisterCubit(RegisterRepo(ApiService(dio)))
        ..firstNameController.text = 'Taylor'
        ..lastNameController.text = 'Example'
        ..emailController.text = ' submitted@example.test '
        ..passwordController.text = 'not-logged'
        ..selectedRole = 'Guest';

      final registration = cubit.register();
      await requestStarted.future;
      await cubit.register();
      expect(requestCount, 1);

      response.complete(
        ResponseBody.fromString(
          jsonEncode({
            'userId': 'user-id',
            'email': 'submitted@example.test',
            'message': 'Registration initiated',
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      await registration;

      expect(cubit.state, isA<RegisterSuccess>());
      expect((cubit.state as RegisterSuccess).email, 'submitted@example.test');
      await cubit.close();
    },
  );

  test(
    'failed registration never emits the OTP handoff success state',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter(
          (_) async => ResponseBody.fromString(
            jsonEncode({'detail': 'invalid'}),
            400,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ),
        );
      final cubit = RegisterCubit(RegisterRepo(ApiService(dio)))
        ..firstNameController.text = 'Taylor'
        ..lastNameController.text = 'Example'
        ..emailController.text = 'registered@example.test'
        ..passwordController.text = 'not-logged'
        ..selectedRole = 'Guest';

      await cubit.register();

      expect(cubit.state, isA<RegisterFailure>());
      expect(cubit.state, isNot(isA<RegisterSuccess>()));
      await cubit.close();
    },
  );
}

class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.callback);

  final Future<ResponseBody> Function(RequestOptions options) callback;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => callback(options);

  @override
  void close({bool force = false}) {}
}
