import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/phone_number/edit_phone_cubit.dart';
import 'package:egypto/features/my_account/presentation/phone_number/egyptian_phone_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Egyptian mobile number normalization', () {
    test('normalizes each supported Egyptian mobile prefix', () {
      for (final prefix in ['010', '011', '012', '015']) {
        expect(
          normalizeEgyptianMobileNumber('${prefix}12345678'),
          '+20${prefix.substring(1)}12345678',
        );
      }
    });

    test(
      'accepts international format without duplicating the country code',
      () {
        expect(normalizeEgyptianMobileNumber('+201012345678'), '+201012345678');
      },
    );

    test('accepts formatting characters and removes them safely', () {
      expect(
        normalizeEgyptianMobileNumber('+20 (10) 1234-5678'),
        '+201012345678',
      );
    });

    test(
      'rejects empty, incomplete, landline, alphabetic, and malformed input',
      () {
        for (final value in [
          '',
          '   ',
          '0101234567',
          '02021234567',
          '0101234567x',
          '+20101234567',
          '+20+201012345678',
          '+2001012345678',
          '201012345678',
          '010123456789',
        ]) {
          expect(
            normalizeEgyptianMobileNumber(value),
            isNull,
            reason: 'Expected "$value" to be rejected',
          );
        }
      },
    );

    test('converts an existing international number to local input format', () {
      expect(egyptianMobileInputValue('+201012345678'), '01012345678');
      expect(egyptianMobileInputValue(null), '');
    });
  });

  group('Phone profile update', () {
    test('sends current names and normalized phone in PUT profile', () async {
      late RequestOptions request;
      var profileRequests = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter((options) async {
          if (options.method == 'GET') {
            profileRequests++;
            return _response(200, {
              'firstName': 'Current',
              'lastName': 'Account',
              'email': 'user@example.test',
            });
          }
          request = options;
          return _response(200, {'phone': '+201012345678'});
        });
      final repository = MyAccountRepo(ApiService(dio));
      await repository.getProfile();
      final cubit = EditPhoneCubit(repository);

      await cubit.savePhone('01012345678');

      expect(request.method, 'PUT');
      expect(request.uri.path, '/api/v1/profile');
      final requestBody = request.data is String
          ? jsonDecode(request.data as String)
          : request.data;
      expect(requestBody, {
        'firstName': 'Current',
        'lastName': 'Account',
        'phone': '+201012345678',
      });
      expect(profileRequests, 1);
      expect(cubit.state, isA<EditPhoneSuccess>());
      expect((cubit.state as EditPhoneSuccess).phone, '+201012345678');
      await cubit.close();
    });

    test(
      'fetches profile before update when repository has no profile cache',
      () async {
        final methods = <String>[];
        late RequestOptions updateRequest;
        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
          ..httpClientAdapter = _CallbackAdapter((options) async {
            methods.add(options.method);
            if (options.method == 'GET') {
              return _response(200, {
                'firstName': 'Fetched',
                'lastName': 'Profile',
                'email': 'user@example.test',
              });
            }
            updateRequest = options;
            return _response(200, {});
          });
        final cubit = EditPhoneCubit(MyAccountRepo(ApiService(dio)));

        await cubit.savePhone('01112345678');

        expect(methods, ['GET', 'PUT']);
        expect(updateRequest.data, {
          'firstName': 'Fetched',
          'lastName': 'Profile',
          'phone': '+201112345678',
        });
        expect(cubit.state, isA<EditPhoneSuccess>());
        await cubit.close();
      },
    );

    test('does not submit when profile names are still incomplete', () async {
      var updateRequests = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter((options) async {
          if (options.method == 'PUT') updateRequests++;
          return _response(200, {
            'firstName': ' ',
            'lastName': '',
            'email': 'user@example.test',
          });
        });
      final cubit = EditPhoneCubit(MyAccountRepo(ApiService(dio)));

      await cubit.savePhone('01012345678');

      expect(updateRequests, 0);
      expect(cubit.state, isA<EditPhoneFailure>());
      expect(
        (cubit.state as EditPhoneFailure).errorType,
        AppErrorType.profileUnavailable,
      );
      await cubit.close();
    });

    test('does not send invalid phone input', () async {
      var requests = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter((_) async {
          requests++;
          return _response(200, {});
        });
      final cubit = EditPhoneCubit(MyAccountRepo(ApiService(dio)));

      await cubit.savePhone('010123');

      expect(requests, 0);
      expect(cubit.state, isA<EditPhoneFailure>());
      expect(
        (cubit.state as EditPhoneFailure).errorType,
        AppErrorType.validation,
      );
      await cubit.close();
    });

    test('retains a backend validation failure as a failure state', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter((_) async {
          return _response(422, {'detail': 'invalid phone'});
        });
      final cubit = EditPhoneCubit(MyAccountRepo(ApiService(dio)));

      await cubit.savePhone('01012345678');

      expect(cubit.state, isA<EditPhoneFailure>());
      expect(
        (cubit.state as EditPhoneFailure).errorType,
        AppErrorType.validation,
      );
      await cubit.close();
    });

    test(
      'prevents duplicate submission while the request is running',
      () async {
        final requestCompleter = Completer<ResponseBody>();
        final requestStarted = Completer<void>();
        var requests = 0;
        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
          ..httpClientAdapter = _CallbackAdapter((options) {
            if (options.method == 'GET') {
              return Future.value(
                _response(200, {
                  'firstName': 'Current',
                  'lastName': 'Account',
                  'email': 'user@example.test',
                }),
              );
            }
            requests++;
            requestStarted.complete();
            return requestCompleter.future;
          });
        final cubit = EditPhoneCubit(MyAccountRepo(ApiService(dio)));

        final firstSubmit = cubit.savePhone('01012345678');
        await requestStarted.future;
        await cubit.savePhone('01112345678');
        expect(requests, 1);

        requestCompleter.complete(_response(200, {'phone': '+201012345678'}));
        await firstSubmit;
        expect(cubit.state, isA<EditPhoneSuccess>());
        await cubit.close();
      },
    );

    test(
      'uses the submitted number when the successful response omits phone',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
          ..httpClientAdapter = _CallbackAdapter(
            (_) async => _response(200, {
              'firstName': 'Cached',
              'lastName': 'User',
              'email': 'user@example.test',
            }),
          );
        final repository = MyAccountRepo(ApiService(dio));
        await repository.getProfile();
        final cubit = EditPhoneCubit(repository);

        await cubit.savePhone('01012345678');

        expect(cubit.state, isA<EditPhoneSuccess>());
        expect((cubit.state as EditPhoneSuccess).phone, '+201012345678');
        await cubit.close();
      },
    );
  });
}

class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.callback);

  final Future<ResponseBody> Function(RequestOptions options) callback;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return callback(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _response(int statusCode, Object data) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
