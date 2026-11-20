import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/my_account/data/models/identity_verification_request.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum IdentityVerificationStage { editing, submitting, submitted }

enum IdentityVerificationError {
  imageUnavailable,
  permissionDenied,
  network,
  unauthorized,
  validation,
  server,
  unknown,
}

class IdentityVerificationState {
  const IdentityVerificationState({
    this.currentStep = 0,
    this.images = const {},
    this.stage = IdentityVerificationStage.editing,
    this.progress = 0,
    this.confirmed = false,
    this.error,
    this.errorStep,
  });

  final int currentStep;
  final Map<IdentityImageSlot, XFile> images;
  final IdentityVerificationStage stage;
  final double progress;
  final bool confirmed;
  final IdentityVerificationError? error;
  final int? errorStep;

  bool get isReview => currentStep == 3;
  bool get canContinue =>
      currentStep < 3 &&
      images.containsKey(IdentityImageSlot.values[currentStep]);
  bool get canSubmit =>
      isReview &&
      IdentityImageSlot.values.every(images.containsKey) &&
      stage == IdentityVerificationStage.editing &&
      confirmed;

  IdentityVerificationState copyWith({
    int? currentStep,
    Map<IdentityImageSlot, XFile>? images,
    IdentityVerificationStage? stage,
    double? progress,
    bool? confirmed,
    IdentityVerificationError? error,
    int? errorStep,
    bool clearError = false,
  }) {
    return IdentityVerificationState(
      currentStep: currentStep ?? this.currentStep,
      images: images ?? this.images,
      stage: stage ?? this.stage,
      progress: progress ?? this.progress,
      confirmed: confirmed ?? this.confirmed,
      error: clearError ? null : error ?? this.error,
      errorStep: clearError ? null : errorStep ?? this.errorStep,
    );
  }
}

class IdentityVerificationCubit extends Cubit<IdentityVerificationState> {
  IdentityVerificationCubit(this._repository, this._imagePicker)
    : super(const IdentityVerificationState());

  final MyAccountRepo _repository;
  final IdentityImagePicker _imagePicker;

  Future<void> chooseImage(
    IdentityImageSlot slot,
    ImageSource source,
  ) async {
    if (state.stage == IdentityVerificationStage.submitting ||
        state.stage == IdentityVerificationStage.submitted) {
      return;
    }
    try {
      final image = await _imagePicker.pick(slot: slot, source: source);
      if (image == null || isClosed) return;
      final valid = await _validateImage(image);
      if (!valid) {
        emit(
          state.copyWith(
            error: IdentityVerificationError.imageUnavailable,
            errorStep: IdentityImageSlot.values.indexOf(slot),
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          images: Map.unmodifiable({...state.images, slot: image}),
          confirmed: false,
          error: null,
          errorStep: null,
          clearError: true,
        ),
      );
    } on PlatformException catch (error) {
      if (isClosed) return;
      final denied = error.code.toLowerCase().contains('denied');
      emit(
        state.copyWith(
          error: denied
              ? IdentityVerificationError.permissionDenied
              : IdentityVerificationError.unknown,
          errorStep: IdentityImageSlot.values.indexOf(slot),
        ),
      );
    } on FileSystemException {
      if (!isClosed) {
        emit(
          state.copyWith(
            error: IdentityVerificationError.imageUnavailable,
            errorStep: IdentityImageSlot.values.indexOf(slot),
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            error: IdentityVerificationError.unknown,
            errorStep: IdentityImageSlot.values.indexOf(slot),
          ),
        );
      }
    }
  }

  Future<bool> _validateImage(XFile image) async {
    final file = File(image.path);
    if (!await file.exists()) return false;
    return await file.length() > 0;
  }

  void nextStep() {
    if (state.stage != IdentityVerificationStage.editing ||
        !state.canContinue) {
      return;
    }
    emit(state.copyWith(currentStep: state.currentStep + 1, clearError: true));
  }

  void previousStep() {
    if (state.stage != IdentityVerificationStage.editing ||
        state.currentStep == 0) {
      return;
    }
    emit(state.copyWith(currentStep: state.currentStep - 1, clearError: true));
  }

  void goToStep(int index) {
    if (state.stage != IdentityVerificationStage.editing ||
        index < 0 ||
        index > 3 ||
        (index < 3 && !state.images.containsKey(IdentityImageSlot.values[index]))) {
      return;
    }
    emit(state.copyWith(currentStep: index, clearError: true));
  }

  void setConfirmed(bool value) {
    if (state.stage == IdentityVerificationStage.editing) {
      emit(state.copyWith(confirmed: value, clearError: true));
    }
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;

    final selfie = state.images[IdentityImageSlot.selfie];
    final front = state.images[IdentityImageSlot.nationalIdFront];
    final back = state.images[IdentityImageSlot.nationalIdBack];
    if (selfie == null || front == null || back == null) return;

    emit(
      state.copyWith(
        stage: IdentityVerificationStage.submitting,
        progress: 0,
        clearError: true,
      ),
    );
    try {
      await _repository.submitIdentityVerification(
        IdentityVerificationRequest(
          selfiePath: selfie.path,
          nationalIdFrontPath: front.path,
          nationalIdBackPath: back.path,
        ),
        onSendProgress: (sent, total) {
          if (!isClosed && total > 0) {
            emit(
              state.copyWith(
                progress: (sent / total).clamp(0.0, 1.0),
              ),
            );
          }
        },
      );
      if (!isClosed) {
        emit(state.copyWith(stage: IdentityVerificationStage.submitted));
      }
    } on AppException catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            stage: IdentityVerificationStage.editing,
            error: _mapError(error.errorType),
            errorStep: 3,
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            stage: IdentityVerificationStage.editing,
            error: error is DioException
                ? _mapError(ApiErrorHandler.handle(error).errorType)
                : IdentityVerificationError.unknown,
            errorStep: 3,
          ),
        );
      }
    }
  }

  IdentityVerificationError _mapError(AppErrorType type) {
    return switch (type) {
      AppErrorType.network || AppErrorType.timeout =>
        IdentityVerificationError.network,
      AppErrorType.unauthorized || AppErrorType.forbidden =>
        IdentityVerificationError.unauthorized,
      AppErrorType.validation => IdentityVerificationError.validation,
      AppErrorType.server => IdentityVerificationError.server,
      AppErrorType.invalidUpload => IdentityVerificationError.imageUnavailable,
      _ => IdentityVerificationError.unknown,
    };
  }
}
