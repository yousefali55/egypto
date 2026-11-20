import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_image_picker.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  late Directory tempDirectory;
  late Map<IdentityImageSlot, XFile> images;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('egypto-identity-');
    images = {};
    for (final slot in IdentityImageSlot.values) {
      final file = File('${tempDirectory.path}/${slot.name}.jpg');
      await file.writeAsBytes(utf8.encode('image-${slot.name}'));
      images[slot] = XFile(file.path);
    }
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  test(
    'submits exact multipart field names and retries after network failure',
    () async {
      final adapter = _RecordingAdapter(failFirstRequest: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
        ..httpClientAdapter = adapter;
      final picker = _FakeImagePicker(images);
      final cubit = IdentityVerificationCubit(
        MyAccountRepo(ApiService(dio)),
        picker,
      );
      addTearDown(cubit.close);

      await _selectAllImages(cubit);
      expect(cubit.state.isReview, isTrue);
      expect(cubit.state.canSubmit, isFalse);

      cubit.setConfirmed(true);
      expect(cubit.state.canSubmit, isTrue);
      cubit.goToStep(0);
      await cubit.chooseImage(IdentityImageSlot.selfie, ImageSource.camera);
      expect(cubit.state.confirmed, isFalse);
      cubit.goToStep(3);

      await cubit.submit();
      expect(cubit.state.stage, IdentityVerificationStage.editing);
      expect(cubit.state.canSubmit, isFalse);
      cubit.setConfirmed(true);
      await cubit.submit();
      expect(cubit.state.error, IdentityVerificationError.network);
      expect(cubit.state.images.length, 3);
      expect(adapter.requestCount, 1);

      await cubit.submit();
      expect(cubit.state.stage, IdentityVerificationStage.submitted);
      expect(adapter.requestCount, 2);
      expect(adapter.lastMethod, 'POST');
      expect(adapter.lastUri, '/api/v1/identity');
      expect(adapter.lastContentType, startsWith('multipart/form-data;'));
      expect(adapter.lastBody, contains('name="Selfie"'));
      expect(adapter.lastBody, contains('name="NationalIdFront"'));
      expect(adapter.lastBody, contains('name="NationalIdBack"'));
      expect(adapter.lastBody, contains('image-selfie'));
      expect(adapter.lastBody, contains('image-nationalIdFront'));
      expect(adapter.lastBody, contains('image-nationalIdBack'));
      expect(
        picker.picks,
        contains((IdentityImageSlot.selfie, ImageSource.camera)),
      );
    },
  );

  test(
    'does not submit until all three images and explicit confirmation exist',
    () async {
      final adapter = _RecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
        ..httpClientAdapter = adapter;
      final picker = _FakeImagePicker(images);
      final cubit = IdentityVerificationCubit(
        MyAccountRepo(ApiService(dio)),
        picker,
      );
      addTearDown(cubit.close);

      await cubit.chooseImage(IdentityImageSlot.selfie, ImageSource.camera);
      cubit.nextStep();
      await cubit.chooseImage(
        IdentityImageSlot.nationalIdFront,
        ImageSource.gallery,
      );
      cubit.nextStep();
      await cubit.chooseImage(
        IdentityImageSlot.nationalIdBack,
        ImageSource.gallery,
      );
      cubit.nextStep();

      expect(cubit.state.isReview, isTrue);
      expect(cubit.state.canSubmit, isFalse);
      await cubit.submit();
      expect(adapter.requestCount, 0);

      cubit.setConfirmed(true);
      await Future.wait([cubit.submit(), cubit.submit()]);
      expect(cubit.state.stage, IdentityVerificationStage.submitted);
      expect(adapter.requestCount, 1);
      expect(picker.picks, [
        (IdentityImageSlot.selfie, ImageSource.camera),
        (IdentityImageSlot.nationalIdFront, ImageSource.gallery),
        (IdentityImageSlot.nationalIdBack, ImageSource.gallery),
      ]);
    },
  );

  test('preserves selected images after a server validation error', () async {
    final adapter = _RecordingAdapter(
      responseStatus: 400,
      responseBody: '{"detail":"unsupported image"}',
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
      ..httpClientAdapter = adapter;
    final cubit = IdentityVerificationCubit(
      MyAccountRepo(ApiService(dio)),
      _FakeImagePicker(images),
    );
    addTearDown(cubit.close);

    await _selectAllImages(cubit);
    cubit.setConfirmed(true);
    await cubit.submit();

    expect(cubit.state.error, IdentityVerificationError.validation);
    expect(cubit.state.images.length, 3);
    expect(cubit.state.canSubmit, isTrue);
  });
}

Future<void> _selectAllImages(IdentityVerificationCubit cubit) async {
  for (final slot in IdentityImageSlot.values.take(3)) {
    await cubit.chooseImage(slot, ImageSource.gallery);
    cubit.nextStep();
  }
}

class _FakeImagePicker implements IdentityImagePicker {
  _FakeImagePicker(this.images);

  final Map<IdentityImageSlot, XFile> images;
  final picks = <(IdentityImageSlot, ImageSource)>[];

  @override
  Future<XFile?> pick({
    required IdentityImageSlot slot,
    required ImageSource source,
  }) async => _pick(slot, source);

  XFile? _pick(IdentityImageSlot slot, ImageSource source) {
    picks.add((slot, source));
    return images[slot];
  }
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({
    this.failFirstRequest = false,
    this.responseStatus = 204,
    this.responseBody = '',
  });

  final bool failFirstRequest;
  final int responseStatus;
  final String responseBody;
  int requestCount = 0;
  String? lastMethod;
  String? lastUri;
  String? lastContentType;
  String lastBody = '';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    if (failFirstRequest && requestCount == 1) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    lastMethod = options.method;
    lastUri = options.uri.path;
    lastContentType = options.headers['content-type']?.toString();
    final body = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        body.addAll(chunk);
      }
    }
    lastBody = utf8.decode(body, allowMalformed: true);
    return ResponseBody.fromString(
      responseBody,
      responseStatus,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
