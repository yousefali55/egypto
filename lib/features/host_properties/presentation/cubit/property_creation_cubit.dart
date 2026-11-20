import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';

enum PropertyCreationStage {
  idle,
  loadingAmenities,
  ready,
  creating,
  uploading,
  submitting,
  failed,
  succeeded,
}

class PropertyCreationState {
  const PropertyCreationState({
    this.stage = PropertyCreationStage.idle,
    this.amenities = const [],
    this.selectedAmenityIds = const {},
    this.propertyId,
    this.status,
    this.error,
    this.failedAt,
    this.canRetry = false,
    this.uploadProgress = 0,
  });

  final PropertyCreationStage stage;
  final List<Amenity> amenities;
  final Set<String> selectedAmenityIds;
  final String? propertyId;
  final String? status;
  final String? error;
  final PropertyCreationStage? failedAt;
  final bool canRetry;
  final double uploadProgress;
}

class PropertyCreationCubit extends Cubit<PropertyCreationState> {
  PropertyCreationCubit(this._repository)
    : super(const PropertyCreationState());

  final HostPropertiesRepo _repository;
  bool _isWorking = false;
  CreatePropertyRequest? _pendingRequest;
  List<String> _pendingImagePaths = const [];
  String? _propertyId;
  bool _creationAttempted = false;
  bool _canRetryCreation = true;
  bool _imagesUploaded = false;
  final Set<String> _uploadedImagePaths = {};
  bool _submitRequestSucceeded = false;

  Future<void> loadAmenities() async {
    if (_isWorking || state.amenities.isNotEmpty) return;
    _isWorking = true;
    emit(_copy(stage: PropertyCreationStage.loadingAmenities));
    try {
      final amenities = await _repository.getAmenities();
      if (!isClosed) {
        emit(_copy(stage: PropertyCreationStage.ready, amenities: amenities));
      }
    } on AppException catch (exception) {
      if (!isClosed) {
        emit(
          _copy(
            stage: PropertyCreationStage.failed,
            error: exception.message,
            failedAt: PropertyCreationStage.loadingAmenities,
            canRetry: true,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          _copy(
            stage: PropertyCreationStage.failed,
            error: 'Unable to load amenities.',
            failedAt: PropertyCreationStage.loadingAmenities,
            canRetry: true,
          ),
        );
      }
    } finally {
      _isWorking = false;
    }
  }

  void toggleAmenity(String amenityId) {
    if (_isWorking) return;
    final selected = {...state.selectedAmenityIds};
    if (!selected.add(amenityId)) selected.remove(amenityId);
    emit(
      _copy(stage: PropertyCreationStage.ready, selectedAmenityIds: selected),
    );
  }

  Future<void> submit(
    CreatePropertyRequest request,
    List<String> imagePaths,
  ) async {
    if (_isWorking) return;
    if (imagePaths.length < 4) {
      emit(
        _copy(
          stage: PropertyCreationStage.ready,
          error: 'Select at least four property images.',
          canRetry: false,
        ),
      );
      return;
    }
    if (_propertyId == null && _creationAttempted && !_canRetryCreation) {
      emit(
        _copy(
          stage: PropertyCreationStage.failed,
          error: 'The create request may have succeeded, but its ID was not received. It will not be sent again to avoid creating a duplicate property.',
          failedAt: PropertyCreationStage.creating,
          canRetry: false,
        ),
      );
      return;
    }
    _pendingRequest = request;
    _pendingImagePaths = List.unmodifiable(imagePaths);
    await _runWorkflow();
  }

  Future<void> retry({List<String>? imagePaths}) async {
    if (_isWorking) return;
    if (state.failedAt == PropertyCreationStage.loadingAmenities) {
      await loadAmenities();
      return;
    }
    if (_pendingRequest == null || _pendingImagePaths.length < 4) return;
    if (_propertyId == null && !_canRetryCreation) return;
    if (_propertyId != null &&
        state.failedAt == PropertyCreationStage.uploading &&
        imagePaths != null) {
      if (imagePaths.length < 4) return;
      _pendingImagePaths = List.unmodifiable(imagePaths);
      _imagesUploaded = false;
    }
    await _runWorkflow();
  }

  Future<void> _runWorkflow() async {
    _isWorking = true;
    try {
      if (_propertyId == null) {
        _creationAttempted = true;
        emit(_copy(stage: PropertyCreationStage.creating));
        _propertyId = await _repository.createProperty(_pendingRequest!);
      }

      if (!_imagesUploaded) {
        emit(_copy(stage: PropertyCreationStage.uploading, uploadProgress: 0));
        await _repository.uploadPropertyImages(
          _propertyId!,
          _pendingImagePaths,
          alreadyUploadedPaths: _uploadedImagePaths,
          onImageUploaded: (path) {
            _uploadedImagePaths.add(path);
          },
          onSendProgress: (sent, total) {
            if (isClosed || total <= 0) return;
            emit(_copy(uploadProgress: sent / total));
          },
        );
        _imagesUploaded = true;
      }

      emit(_copy(stage: PropertyCreationStage.submitting));
      String? status;
      if (!_submitRequestSucceeded) {
        status = await _repository.submitProperty(_propertyId!);
        _submitRequestSucceeded = true;
      }
      status ??= await _repository.getPropertyStatus(_propertyId!);
      if (status == null || status.trim().isEmpty) {
        throw StateError(
          'Backend did not return the resulting property status.',
        );
      }
      if (!isClosed) {
        emit(
          _copy(
            stage: PropertyCreationStage.succeeded,
            status: status,
            canRetry: false,
          ),
        );
      }
    } on AppException catch (exception) {
      if (_propertyId == null) {
        _canRetryCreation = _isDefiniteRejection(exception);
      }
      if (!isClosed) {
        emit(
          _copy(
            stage: PropertyCreationStage.failed,
            error: exception.message,
            failedAt: _stageFromException(),
            canRetry: _propertyId != null || _canRetryCreation,
          ),
        );
      }
    } catch (error) {
      if (_propertyId == null) _canRetryCreation = false;
      if (!isClosed) {
        emit(
          _copy(
            stage: PropertyCreationStage.failed,
            error: error is StateError
                ? error.message
                : 'Unable to complete property submission.',
            failedAt: _stageFromException(),
            canRetry: _propertyId != null || _canRetryCreation,
          ),
        );
      }
    } finally {
      _isWorking = false;
    }
  }

  PropertyCreationStage _stageFromException() {
    if (_propertyId == null) return PropertyCreationStage.creating;
    if (!_imagesUploaded) return PropertyCreationStage.uploading;
    return PropertyCreationStage.submitting;
  }

  bool _isDefiniteRejection(AppException exception) =>
      exception.errorType == AppErrorType.unauthorized ||
      exception.errorType == AppErrorType.forbidden ||
      exception.errorType == AppErrorType.validation ||
      exception.errorType == AppErrorType.notFound;

  PropertyCreationState _copy({
    PropertyCreationStage? stage,
    List<Amenity>? amenities,
    Set<String>? selectedAmenityIds,
    String? status,
    String? error,
    PropertyCreationStage? failedAt,
    bool? canRetry,
    double? uploadProgress,
  }) => PropertyCreationState(
    stage: stage ?? state.stage,
    amenities: amenities ?? state.amenities,
    selectedAmenityIds: selectedAmenityIds ?? state.selectedAmenityIds,
    propertyId: _propertyId,
    status: status ?? state.status,
    error: error,
    failedAt: failedAt,
    canRetry: canRetry ?? state.canRetry,
    uploadProgress: uploadProgress ?? state.uploadProgress,
  );
}
