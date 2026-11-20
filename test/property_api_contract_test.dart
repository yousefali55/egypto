import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/auth_intercptors.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/features/admin/data/repository/admin_repo.dart';
import 'package:egypto/features/admin/presentation/widgets/admin_document_image.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/admin/data/models/admin_pending_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const propertyId = '475f7139-9e73-4a9d-bfc5-44e5d792eff3';

  test('activation is a bodyless POST to the documented endpoint', () async {
    RequestOptions? captured;
    final service = _service((options) async {
      captured = options;
      return _response({});
    });

    await service.activateHost();

    expect(captured?.method, 'POST');
    expect(captured?.path, 'profile/activate-host');
    expect(captured?.data, isNull);
  });

  test(
    'activation carries the stored access token through AuthInterceptor',
    () async {
      final storage = TokenStorage(_MemorySecureStorage());
      await storage.saveToken(
        accessToken: 'current-access-token',
        refreshToken: 'refresh-token',
      );
      final baseOptions = BaseOptions(baseUrl: 'https://test.invalid/api/v1/');
      final refreshDio = Dio(baseOptions)
        ..httpClientAdapter = _CallbackAdapter((_) async => _response({}));
      final refreshService = RefreshTokenService(
        apiService: ApiService(refreshDio),
        tokenStorage: storage,
      );
      RequestOptions? captured;
      final dio = Dio(baseOptions)
        ..httpClientAdapter = _CallbackAdapter((options) async {
          captured = options;
          return _response({});
        });
      dio.interceptors.add(
        AuthInterceptor(
          tokenStorage: storage,
          refreshTokenService: refreshService,
          dio: dio,
        ),
      );

      await ApiService(dio).activateHost();

      expect(captured?.headers['Authorization'], 'Bearer current-access-token');
    },
  );

  test(
    'create, batch image upload, and submit use documented contracts',
    () async {
      final requests = <RequestOptions>[];
      final service = _service((options) async {
        requests.add(options);
        return _response(
          options.path == 'properties'
              ? {'id': propertyId}
              : {'status': 'Pending'},
        );
      });
      const request = CreatePropertyRequest(
        title: 'Listing',
        description: 'Details',
        beds: 1,
        rooms: 1,
        guests: 2,
        bathrooms: 1,
        nightlyPrice: 500,
        location: PropertyLocationRequest(
          country: 'Egypt',
          governorate: 'Cairo',
          city: 'Cairo',
          address: 'Street 1',
          latitude: 30.0444,
          longitude: 31.2357,
        ),
        amenityIds: ['00000000-0000-0000-0000-000000000001'],
      );

      final created = await service.createProperty(request.toJson());
      expect((created as Map<String, dynamic>)['id'], propertyId);
      expect(requests[0].method, 'POST');
      expect(requests[0].path, 'properties');
      expect(requests[0].data, request.toJson());

      await service.uploadPropertyImages(propertyId, [
        MultipartFile.fromBytes([1, 2, 3], filename: 'one.jpg'),
      ], null);
      final upload = requests[1];
      expect(upload.method, 'POST');
      expect(upload.path, 'properties/$propertyId/images');
      expect(
        upload.contentType,
        startsWith(Headers.multipartFormDataContentType),
      );
      final formData = upload.data as FormData;
      expect(formData.files.map((entry) => entry.key), ['Files']);

      final submitted = await service.submitProperty(propertyId);
      expect((submitted as Map<String, dynamic>)['status'], 'Pending');
      expect(requests[2].method, 'POST');
      expect(requests[2].path, 'properties/$propertyId/submit');
      expect(requests[2].data, isNull);
    },
  );

  test('host properties sends the documented pagination query', () async {
    RequestOptions? captured;
    final service = _service((options) async {
      captured = options;
      return _response({
        'items': [],
        'pageNumber': 2,
        'totalPages': 2,
        'totalCount': 0,
        'hasPreviousPage': true,
        'hasNextPage': false,
      });
    });

    await service.getHostProperties(2, 20);

    expect(captured?.method, 'GET');
    expect(captured?.path, 'properties/host');
    expect(captured?.queryParameters, {'pageNumber': 2, 'pageSize': 20});
  });

  test('property search sends only selected documented filters', () async {
    final requests = <RequestOptions>[];
    final service = _service((options) async {
      requests.add(options);
      return _response({
        'items': [],
        'pageNumber': 1,
        'totalPages': 0,
        'totalCount': 0,
        'hasPreviousPage': false,
        'hasNextPage': false,
      });
    });
    final checkIn = DateTime(2026, 11, 10);
    final checkOut = DateTime(2026, 11, 15);
    final combinations = <SearchPropertiesFilters>[
      const SearchPropertiesFilters(),
      const SearchPropertiesFilters(city: 'Port Said'),
      const SearchPropertiesFilters(guests: 4),
      const SearchPropertiesFilters(city: 'Port Said', guests: 4),
      SearchPropertiesFilters(checkIn: checkIn, checkOut: checkOut),
      SearchPropertiesFilters(
        city: 'Port Said',
        checkIn: checkIn,
        checkOut: checkOut,
      ),
      SearchPropertiesFilters(guests: 4, checkIn: checkIn, checkOut: checkOut),
      SearchPropertiesFilters(
        city: 'Port Said',
        guests: 4,
        checkIn: checkIn,
        checkOut: checkOut,
      ),
    ];

    for (final filters in combinations) {
      await service.searchProperties(filters.toQueryParameters());
    }

    expect(requests.map((request) => request.method), everyElement('GET'));
    expect(
      requests.map((request) => request.path),
      everyElement(ApiConstants.searchProperties),
    );
    expect(requests[0].queryParameters, isEmpty);
    expect(requests[1].queryParameters, {'city': 'Port Said'});
    expect(requests[2].queryParameters, {'guests': 4});
    expect(requests[3].queryParameters, {'city': 'Port Said', 'guests': 4});
    expect(requests[4].queryParameters, {
      'checkIn': '2026-11-10',
      'checkOut': '2026-11-15',
    });
    expect(requests[5].queryParameters, {
      'city': 'Port Said',
      'checkIn': '2026-11-10',
      'checkOut': '2026-11-15',
    });
    expect(requests[6].queryParameters, {
      'guests': 4,
      'checkIn': '2026-11-10',
      'checkOut': '2026-11-15',
    });
    expect(requests[7].queryParameters, {
      'city': 'Port Said',
      'guests': 4,
      'checkIn': '2026-11-10',
      'checkOut': '2026-11-15',
    });
  });

  test(
    'property search filters omit empty values and reject invalid ranges',
    () {
      expect(
        const SearchPropertiesFilters(city: '  ').toQueryParameters(),
        isEmpty,
      );
      expect(
        () =>
            SearchPropertiesFilters(checkIn: DateTime(2026, 11, 10))
                .toQueryParameters(),
        throwsArgumentError,
      );
      expect(
        () => SearchPropertiesFilters(
          checkIn: DateTime(2026, 11, 10),
          checkOut: DateTime(2026, 11, 10),
        ).toQueryParameters(),
        throwsArgumentError,
      );
      expect(
        () => const SearchPropertiesFilters(guests: 0).toQueryParameters(),
        throwsArgumentError,
      );
    },
  );

  test(
    'Admin routes match the published bodyless endpoint contracts',
    () async {
      const userId = '00000000-0000-4000-8000-000000000001';
      final requests = <RequestOptions>[];
      final service = _service((options) async {
        requests.add(options);
        return _response({});
      });

      await service.getAdminPendingIdentity(2, 20);
      await service.getAdminIdentityDetails(userId);
      await service.approveAdminIdentity(userId);
      await service.rejectAdminIdentity(userId);
      await service.getAdminPendingProperties(2, 20);
      await service.getAdminPropertyDetails(propertyId);
      await service.approveAdminProperty(propertyId);
      await service.rejectAdminProperty(propertyId);

      expect(requests.map((request) => request.method), [
        'GET',
        'GET',
        'POST',
        'POST',
        'GET',
        'GET',
        'POST',
        'POST',
      ]);
      expect(requests.map((request) => request.path), [
        'admin/identity/pending',
        'admin/identity/$userId',
        'admin/identity/$userId/approve',
        'admin/identity/$userId/reject',
        'admin/properties/pending',
        'admin/properties/$propertyId',
        'admin/properties/$propertyId/approve',
        'admin/properties/$propertyId/reject',
      ]);
      expect(requests[0].queryParameters, {'pageNumber': 2, 'pageSize': 20});
      expect(requests[4].queryParameters, {'pageNumber': 2, 'pageSize': 20});
      for (final request in requests.where(
        (request) => request.method == 'POST',
      )) {
        expect(request.data, isNull);
      }
    },
  );

  test('Admin pending page preserves raw response fields and pagination', () {
    final page = AdminPendingPage.fromJson({
      'items': [
        {'userId': 'user-1', 'status': 'Pending', 'documentUrl': '/id.jpg'},
      ],
      'pageNumber': 2,
      'totalPages': 3,
      'totalCount': 41,
      'hasPreviousPage': true,
      'hasNextPage': true,
    });

    expect(page.pageNumber, 2);
    expect(page.totalPages, 3);
    expect(page.totalCount, 41);
    expect(page.hasPreviousPage, isTrue);
    expect(page.hasNextPage, isTrue);
    expect(page.items.single['documentUrl'], '/id.jpg');
  });

  test('identity detail response maps all nested document URLs', () async {
    const userId = '52c7b677-d6ae-42c8-b1b2-674102799b14';
    const selfie = '/uploads/selfie.jpg';
    const front = '/uploads/front.jpg';
    const back = '/uploads/back.jpg';
    RequestOptions? captured;
    final repository = AdminRepo(
      _service((options) async {
        captured = options;
        return _response({
          'userId': userId,
          'firstName': 'Yousef',
          'lastName': 'Ali',
          'email': 'yousef@example.test',
          'status': 'Pending',
          'submittedAt': '2026-10-23T15:42:40.617609Z',
          'documents': {
            'selfieViewUrl': selfie,
            'nationalIdFrontViewUrl': front,
            'nationalIdBackViewUrl': back,
          },
        });
      }),
      Dio(),
    );

    final details = await repository.getIdentityDetails(userId);

    expect(captured?.method, 'GET');
    expect(captured?.path, 'admin/identity/$userId');
    expect(details.userId, userId);
    expect(details.fullName, 'Yousef Ali');
    expect(details.status, 'Pending');
    expect(details.documents.selfieViewUrl, selfie);
    expect(details.documents.nationalIdFrontViewUrl, front);
    expect(details.documents.nationalIdBackViewUrl, back);
  });

  test('identity document requests use root-relative image URLs', () async {
    RequestOptions? captured;
    final imageDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response<List<int>>(
                requestOptions: options,
                data: [0xff, 0xd8, 0xff],
                headers: Headers.fromMap({
                  Headers.contentTypeHeader: ['image/jpeg'],
                }),
              ),
            );
          },
        ),
      );
    final repository = AdminRepo(
      _service((options) async => _response({})),
      imageDio,
    );

    final bytes = await repository.getIdentityDocumentImage(
      '/uploads/identity.jpg',
    );

    expect(captured?.uri.origin, Uri.parse(ApiConstants.baseUrl).origin);
    expect(captured?.uri.path, '/uploads/identity.jpg');
    expect(bytes, [0xff, 0xd8, 0xff]);
  });

  test(
    'Admin document paths resolve at API origin without changing absolute URLs',
    () {
      final origin = Uri.parse(ApiConstants.baseUrl).origin;

      expect(
        resolveAdminDocumentUrl('/uploads/id-front.jpg'),
        '$origin/uploads/id-front.jpg',
      );
      expect(
        resolveAdminDocumentUrl('uploads/id-back.jpg'),
        '$origin/uploads/id-back.jpg',
      );
      expect(
        resolveAdminDocumentUrl('https://cdn.example.test/id.jpg'),
        'https://cdn.example.test/id.jpg',
      );
      expect(resolveAdminDocumentUrl(''), isNull);
      expect(resolveAdminDocumentUrl(null), isNull);
      expect(resolveAdminDocumentUrl('file:///uploads/id.jpg'), isNull);
      expect(resolveAdminDocumentUrl('https:///uploads/id.jpg'), isNull);
    },
  );

  test(
    'status lookup finds the created ID across host-property pages',
    () async {
      final requestedPages = <int>[];
      final service = _service((options) async {
        final pageNumber = options.queryParameters['pageNumber'] as int;
        requestedPages.add(pageNumber);
        return _response({
          'items': pageNumber == 2
              ? [
                  {
                    'id': propertyId,
                    'title': 'Listing',
                    'status': 'Published',
                    'nightlyPrice': 500,
                    'city': 'Cairo',
                  },
                ]
              : [],
          'pageNumber': pageNumber,
          'totalPages': 2,
          'totalCount': 21,
          'hasPreviousPage': pageNumber > 1,
          'hasNextPage': pageNumber == 1,
        });
      });

      final status = await HostPropertiesRepo(service)
          .getPropertyStatus(propertyId);

      expect(status, 'Published');
      expect(requestedPages, [1, 2]);
    },
  );

  test(
    'image retry uploads only unconfirmed files as singleton Files arrays',
    () async {
      final directory = await Directory.systemTemp.createTemp('egypto-images-');
      addTearDown(() => directory.delete(recursive: true));
      final first = await File('${directory.path}/first.jpg').writeAsBytes([1]);
      final second = await File('${directory.path}/second.jpg')
          .writeAsBytes([2]);
      final requests = <RequestOptions>[];
      final repository = HostPropertiesRepo(
        _service((options) async {
          requests.add(options);
          return _response({});
        }),
      );
      final confirmed = <String>[];

      await repository.uploadPropertyImages(
        propertyId,
        [first.path, second.path],
        alreadyUploadedPaths: {first.path},
        onImageUploaded: confirmed.add,
      );

      expect(confirmed, [second.path]);
      expect(requests, hasLength(1));
      expect(requests.single.path, 'properties/$propertyId/images');
      final formData = requests.single.data as FormData;
      expect(formData.files.map((entry) => entry.key), ['Files']);
      expect(formData.files, hasLength(1));
    },
  );
}

ApiService _service(Future<ResponseBody> Function(RequestOptions) callback) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
    ..httpClientAdapter = _CallbackAdapter(callback);
  return ApiService(dio);
}

ResponseBody _response(Map<String, dynamic> body) => ResponseBody.fromString(
  jsonEncode(body),
  200,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.callback);

  final Future<ResponseBody> Function(RequestOptions) callback;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await requestStream?.drain<void>();
    return callback(options);
  }

  @override
  void close({bool force = false}) {}
}

class _MemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _values[key];

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.remove(key);
  }
}
