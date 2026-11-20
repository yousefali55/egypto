import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';
import 'package:egypto/features/host_properties/presentation/cubit/property_creation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes the complete documented create-property JSON contract', () {
    const request = CreatePropertyRequest(
      title: 'Sea apartment',
      description: 'A place near the sea',
      beds: 1,
      rooms: 1,
      guests: 2,
      bathrooms: 1,
      nightlyPrice: 1000,
      location: PropertyLocationRequest(
        country: 'Egypt',
        governorate: 'Port Said',
        city: 'Port Said',
        address: 'Sea road',
        latitude: 31.270056,
        longitude: 32.302503,
      ),
      amenityIds: ['00000000-0000-0000-0000-000000000001'],
    );

    expect(request.toJson(), {
      'title': 'Sea apartment',
      'description': 'A place near the sea',
      'beds': 1,
      'rooms': 1,
      'guests': 2,
      'bathrooms': 1,
      'nightlyPrice': 1000.0,
      'location': {
        'country': 'Egypt',
        'governorate': 'Port Said',
        'city': 'Port Said',
        'address': 'Sea road',
        'latitude': 31.270056,
        'longitude': 32.302503,
      },
      'amenityIds': ['00000000-0000-0000-0000-000000000001'],
    });
  });

  test('does not create before the four-image minimum is met', () async {
    final repository = _FakeHostPropertiesRepo();
    final cubit = PropertyCreationCubit(repository);

    await cubit.submit(_request, ['a', 'b', 'c']);

    expect(repository.createCalls, 0);
    expect(repository.uploadCalls, 0);
    expect(repository.submitCalls, 0);
    expect(cubit.state.stage, PropertyCreationStage.ready);
    await cubit.close();
  });

  test(
    'upload retry reuses property ID and does not recreate the property',
    () async {
      final repository = _FakeHostPropertiesRepo()..failFirstUpload = true;
      final cubit = PropertyCreationCubit(repository);

      await cubit.submit(_request, ['a', 'b', 'c', 'd']);
      expect(cubit.state.stage, PropertyCreationStage.failed);
      expect(cubit.state.propertyId, _propertyId);
      expect(repository.createCalls, 1);
      expect(repository.submitCalls, 0);

      await cubit.retry();

      expect(cubit.state.stage, PropertyCreationStage.succeeded);
      expect(cubit.state.propertyId, _propertyId);
      expect(cubit.state.status, 'Published');
      expect(repository.createCalls, 1);
      expect(repository.uploadCalls, 2);
      expect(repository.submitCalls, 1);
      expect(repository.events, ['create', 'upload', 'upload', 'submit']);
      expect(repository.attemptedImagePaths, ['a', 'b', 'b', 'c', 'd']);
      await cubit.close();
    },
  );

  test(
    'does not repeat a create request after an uncertain network failure',
    () async {
      final repository = _FakeHostPropertiesRepo()..failCreate = true;
      final cubit = PropertyCreationCubit(repository);
      const images = ['a', 'b', 'c', 'd'];

      await cubit.submit(_request, images);
      expect(cubit.state.canRetry, isFalse);
      await cubit.retry();
      await cubit.submit(_request, images);

      expect(repository.createCalls, 1);
      expect(repository.uploadCalls, 0);
      expect(repository.submitCalls, 0);
      await cubit.close();
    },
  );

  test('status retry does not repeat upload or submit operations', () async {
    final repository = _FakeHostPropertiesRepo()..failFirstStatusRead = true;
    final cubit = PropertyCreationCubit(repository);
    const paths = ['a', 'b', 'c', 'd'];

    await cubit.submit(_request, paths);
    expect(cubit.state.stage, PropertyCreationStage.failed);
    expect(repository.createCalls, 1);
    expect(repository.uploadCalls, 1);
    expect(repository.submitCalls, 1);

    await cubit.retry(imagePaths: paths);

    expect(cubit.state.stage, PropertyCreationStage.succeeded);
    expect(repository.createCalls, 1);
    expect(repository.uploadCalls, 1);
    expect(repository.submitCalls, 1);
    expect(repository.statusCalls, 2);
    await cubit.close();
  });
}

const _propertyId = '475f7139-9e73-4a9d-bfc5-44e5d792eff3';

const _request = CreatePropertyRequest(
  title: 'Sea apartment',
  description: 'A place near the sea',
  beds: 1,
  rooms: 1,
  guests: 2,
  bathrooms: 1,
  nightlyPrice: 1000,
  location: PropertyLocationRequest(
    country: 'Egypt',
    governorate: 'Port Said',
    city: 'Port Said',
    address: 'Sea road',
    latitude: 31.270056,
    longitude: 32.302503,
  ),
  amenityIds: [],
);

class _FakeHostPropertiesRepo extends HostPropertiesRepo {
  _FakeHostPropertiesRepo() : super(ApiService(Dio()));

  final events = <String>[];
  final attemptedImagePaths = <String>[];
  int createCalls = 0;
  int uploadCalls = 0;
  int submitCalls = 0;
  bool failFirstUpload = false;
  bool failCreate = false;
  bool failFirstStatusRead = false;
  int statusCalls = 0;

  @override
  Future<List<Amenity>> getAmenities() async => const [];

  @override
  Future<HostPropertiesPage> getHostProperties({
    required int pageNumber,
    required int pageSize,
  }) async => const HostPropertiesPage(
    items: [],
    pageNumber: 1,
    totalPages: 1,
    totalCount: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );

  @override
  Future<String> createProperty(CreatePropertyRequest request) async {
    createCalls++;
    events.add('create');
    if (failCreate) {
      throw const AppException(
        errorType: AppErrorType.network,
        message: 'network error',
      );
    }
    return _propertyId;
  }

  @override
  Future<void> uploadPropertyImages(
    String propertyId,
    List<String> paths, {
    Set<String> alreadyUploadedPaths = const {},
    void Function(String)? onImageUploaded,
    ProgressCallback? onSendProgress,
  }) async {
    expect(propertyId, _propertyId);
    uploadCalls++;
    events.add('upload');
    for (final path in paths.where(
      (path) => !alreadyUploadedPaths.contains(path),
    )) {
      attemptedImagePaths.add(path);
      if (failFirstUpload && path == 'b') {
        failFirstUpload = false;
        throw const AppException(
          errorType: AppErrorType.network,
          message: 'upload failed',
        );
      }
      onImageUploaded?.call(path);
    }
  }

  @override
  Future<String?> submitProperty(String propertyId) async {
    expect(propertyId, _propertyId);
    submitCalls++;
    events.add('submit');
    return failFirstStatusRead ? null : 'Published';
  }

  @override
  Future<String?> getPropertyStatus(String propertyId) async {
    statusCalls++;
    if (failFirstStatusRead && statusCalls == 1) return null;
    return 'Published';
  }
}
