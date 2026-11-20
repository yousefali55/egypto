import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/auth/otp/data/repository/otp_repo.dart';
import 'package:egypto/features/auth/otp/persentaion/cubit/otp_cubit.dart';
import 'package:egypto/features/auth/otp/persentaion/otp_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('verify and resend send the exact endpoint payloads', () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter((options) async {
        requests.add(options);
        return _jsonResponse(200, {'message': 'ok'});
      });
    final cubit = OtpCubit(
      otpRepo: OtpRepo(ApiService(dio)),
      email: 'registered@example.test',
    );

    await cubit.verify('123456');
    expect(cubit.state, isA<OtpVerified>());
    await cubit.resend();
    expect(cubit.state, isA<OtpResent>());

    expect(requests, hasLength(2));
    expect(requests[0].method, 'POST');
    expect(requests[0].uri.path, '/api/v1/auth/verify-otp');
    expect(_decodeBody(requests[0].data), {
      'email': 'registered@example.test',
      'otp': '123456',
    });
    expect(requests[1].method, 'POST');
    expect(requests[1].uri.path, '/api/v1/auth/resend-otp');
    expect(_decodeBody(requests[1].data), {'email': 'registered@example.test'});
    await cubit.close();
  });

  test(
    'repeated verify and resend calls are coalesced while pending',
    () async {
      final response = Completer<ResponseBody>();
      final requestStarted = Completer<void>();
      var requestCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
        ..httpClientAdapter = _CallbackAdapter((_) {
          requestCount++;
          if (!requestStarted.isCompleted) requestStarted.complete();
          return response.future;
        });
      final cubit = OtpCubit(
        otpRepo: OtpRepo(ApiService(dio)),
        email: 'registered@example.test',
      );

      final firstVerify = cubit.verify('123456');
      await requestStarted.future;
      await cubit.verify('123456');
      expect(requestCount, 1);
      response.complete(_jsonResponse(200, {'message': 'ok'}));
      await firstVerify;
      expect(cubit.state, isA<OtpVerified>());

      await cubit.close();
    },
  );

  test('repeated resend calls are coalesced while pending', () async {
    final response = Completer<ResponseBody>();
    final requestStarted = Completer<void>();
    var requestCount = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter((_) {
        requestCount++;
        if (!requestStarted.isCompleted) requestStarted.complete();
        return response.future;
      });
    final cubit = OtpCubit(
      otpRepo: OtpRepo(ApiService(dio)),
      email: 'registered@example.test',
    );

    final firstResend = cubit.resend();
    await requestStarted.future;
    await cubit.resend();
    expect(requestCount, 1);
    response.complete(_jsonResponse(200, {'message': 'ok'}));
    await firstResend;
    expect(cubit.state, isA<OtpResent>());
    await cubit.close();
  });

  test('invalid verification response is exposed as a failure state', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter(
        (_) async => _jsonResponse(400, {'detail': 'invalid'}),
      );
    final cubit = OtpCubit(
      otpRepo: OtpRepo(ApiService(dio)),
      email: 'registered@example.test',
    );

    await cubit.verify('123456');

    expect(cubit.state, isA<OtpVerificationFailure>());
    await cubit.close();
  });

  test('non-numeric verification code is not submitted', () async {
    var requestCount = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter((_) async {
        requestCount++;
        return _jsonResponse(200, {'message': 'ok'});
      });
    final cubit = OtpCubit(
      otpRepo: OtpRepo(ApiService(dio)),
      email: 'registered@example.test',
    );

    await cubit.verify('abc123');

    expect(requestCount, 0);
    expect(cubit.state, isA<OtpInitial>());
    await cubit.close();
  });

  test('failed resend leaves retry available and reports failure', () async {
    var requestCount = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter((_) async {
        requestCount++;
        return requestCount == 1
            ? _jsonResponse(503, {'detail': 'unavailable'})
            : _jsonResponse(200, {'message': 'ok'});
      });
    final cubit = OtpCubit(
      otpRepo: OtpRepo(ApiService(dio)),
      email: 'registered@example.test',
    );

    await cubit.resend();
    expect(cubit.state, isA<OtpResendFailure>());
    await cubit.resend();
    expect(cubit.state, isA<OtpResent>());
    expect(requestCount, 2);
    await cubit.close();
  });

  testWidgets('countdown enables resend at zero and cancels on dispose', (
    tester,
  ) async {
    var resendCount = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(428, 875),
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: OtpCountdown(
              duration: const Duration(seconds: 2),
              isResending: false,
              onResend: () => resendCount++,
            ),
          ),
        ),
      ),
    );

    expect(find.text('00:02'), findsOneWidget);
    expect(find.text('Resend code'), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Resend code'), findsOneWidget);
    await tester.tap(find.text('Resend code'));
    expect(resendCount, 1);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('countdown uses Arabic text and RTL direction', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(428, 875),
        child: MaterialApp(
          locale: const Locale('ar'),
          theme: ThemeData.dark(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: OtpCountdown(
              duration: const Duration(seconds: 5),
              isResending: false,
              onResend: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('يمكنك إعادة إرسال الرمز خلال'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(OtpCountdown))),
      TextDirection.rtl,
    );
  });
}

Object? _decodeBody(Object? body) {
  if (body is String) return jsonDecode(body);
  return body;
}

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> data) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
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
