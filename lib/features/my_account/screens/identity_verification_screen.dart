import 'dart:io';

import 'package:egypto/features/my_account/presentation/identity_verification/identity_image_picker.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key, this.currentStatus});

  final String? currentStatus;

  @override
  Widget build(BuildContext context) {
    final status = _normalizeIdentityStatus(currentStatus);
    if (status.isNotEmpty && status != 'notsubmitted') {
      return _ExistingIdentityStatusScreen(
        status: status,
        onTryAgain: status == 'rejected'
            ? () => _openResubmission(context)
            : null,
      );
    }

    return BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
      builder: (context, state) {
        if (state.stage == IdentityVerificationStage.submitted) {
          return _SubmissionSuccessScreen(
            onDone: () => Navigator.of(context).pop(true),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).identityFlowTitle),
            leading: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: state.stage == IdentityVerificationStage.submitting
                  ? null
                  : () => Navigator.of(context).maybePop(),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 620.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        22.w,
                        8.h,
                        22.w,
                        8.h,
                      ),
                      child: _ProgressHeader(currentStep: state.currentStep),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 220),
                        child: state.isReview
                            ? _ReviewStep(state: state)
                            : _CaptureStep(
                                key: ValueKey(state.currentStep),
                                step: state.currentStep,
                                state: state,
                              ),
                      ),
                    ),
                    if (state.error != null)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          20.w,
                          0,
                          20.w,
                          10.h,
                        ),
                        child: _InlineError(
                          message: _errorMessage(context, state.error!),
                        ),
                      ),
                    _BottomControls(state: state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openResubmission(BuildContext context) async {
    final cubit = context.read<IdentityVerificationCubit>();
    final submitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const IdentityVerificationScreen(),
        ),
      ),
    );
    if (submitted == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  String _errorMessage(BuildContext context, IdentityVerificationError error) {
    final strings = S.of(context);
    return switch (error) {
      IdentityVerificationError.imageUnavailable =>
        strings.identityImageUnavailable,
      IdentityVerificationError.permissionDenied =>
        strings.identityPermissionDenied,
      IdentityVerificationError.network => strings.identityNetworkError,
      IdentityVerificationError.unauthorized => strings.identityAuthError,
      IdentityVerificationError.validation => strings.identityValidationError,
      IdentityVerificationError.server => strings.identityServerError,
      IdentityVerificationError.unknown => strings.identityGenericError,
    };
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final labels = [
      strings.identitySelfie,
      strings.identityIdFront,
      strings.identityIdBack,
      strings.identityReview,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              if (i > 0)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i <= currentStep
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              _StepDot(number: i + 1, active: i <= currentStep),
            ],
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          labels[currentStep],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.number, required this.active});

  final int number;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outlineVariant;
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      width: 29.r,
      height: 29.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: active
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CaptureStep extends StatelessWidget {
  const _CaptureStep({super.key, required this.step, required this.state});

  final int step;
  final IdentityVerificationState state;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final slot = IdentityImageSlot.values[step];
    final image = state.images[slot];
    final title = switch (step) {
      0 => strings.identitySelfie,
      1 => strings.identityIdFront,
      _ => strings.identityIdBack,
    };
    final instructions = switch (step) {
      0 => strings.identitySelfieInstructions,
      1 => strings.identityIdFrontInstructions,
      _ => strings.identityIdBackInstructions,
    };

    return SingleChildScrollView(
      key: ValueKey(step),
      padding: EdgeInsetsDirectional.fromSTEB(22.w, 12.h, 22.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8.h),
          Text(
            instructions,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          SizedBox(height: 22.h),
          _ImageFrame(image: image, slot: slot),
          SizedBox(height: 18.h),
          OutlinedButton.icon(
            onPressed: state.stage == IdentityVerificationStage.submitting
                ? null
                : () => _showImageSource(context, slot),
            icon: Icon(
              image == null
                  ? Icons.add_a_photo_outlined
                  : Icons.refresh_rounded,
            ),
            label: Text(
              image == null
                  ? strings.identityChooseImage
                  : strings.identityReplaceImage,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(52.h),
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: .65),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          if (image != null) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 17.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  strings.identityImageReady,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          Text(
            strings.identityPrivacyNote,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImageSource(
    BuildContext context,
    IdentityImageSlot slot,
  ) async {
    final strings = S.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 4.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(strings.identityCamera),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(strings.identityGallery),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source != null && context.mounted) {
      await context.read<IdentityVerificationCubit>().chooseImage(slot, source);
    }
  }
}

class _ImageFrame extends StatelessWidget {
  const _ImageFrame({required this.image, required this.slot});

  final XFile? image;
  final IdentityImageSlot slot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selfie = slot == IdentityImageSlot.selfie;
    final preview = image;
    return Container(
      height: selfie ? 280.h : 235.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .65),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: preview == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selfie
                      ? Icons.face_retouching_natural_rounded
                      : Icons.badge_outlined,
                  size: 52.sp,
                  color: theme.colorScheme.primary.withValues(alpha: .8),
                ),
                SizedBox(height: 12.h),
                Text(
                  selfie
                      ? S.of(context).identitySelfie
                      : S.of(context).identityDocument,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
          : Image.file(
              File(preview.path),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  Center(child: Text(S.of(context).identityImageUnavailable)),
            ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({required this.state});

  final IdentityVerificationState state;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final slots = IdentityImageSlot.values.take(3).toList();
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.identityReviewTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 7.h),
          Text(
            strings.identityReviewDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 17.h),
          for (final slot in slots)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _ReviewImageTile(
                slot: slot,
                image: state.images[slot]!,
                onEdit: () => context
                    .read<IdentityVerificationCubit>()
                    .goToStep(slot.index),
              ),
            ),
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(8.w, 7.h, 12.w, 7.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: .08),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: state.confirmed,
                  onChanged: (value) => context
                      .read<IdentityVerificationCubit>()
                      .setConfirmed(value ?? false),
                ),
                Expanded(
                  child: Text(
                    strings.identityConfirmation,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewImageTile extends StatelessWidget {
  const _ReviewImageTile({
    required this.slot,
    required this.image,
    required this.onEdit,
  });

  final IdentityImageSlot slot;
  final XFile image;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final title = switch (slot) {
      IdentityImageSlot.selfie => strings.identitySelfie,
      IdentityImageSlot.nationalIdFront => strings.identityIdFront,
      IdentityImageSlot.nationalIdBack => strings.identityIdBack,
    };
    return Container(
      height: 92.h,
      padding: EdgeInsets.all(9.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest
            .withValues(alpha: .55),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11.r),
            child: Image.file(
              File(image.path),
              width: 78.w,
              height: 74.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          IconButton(
            tooltip: strings.identityReplaceImage,
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.state});

  final IdentityVerificationState state;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final cubit = context.read<IdentityVerificationCubit>();
    final submitting = state.stage == IdentityVerificationStage.submitting;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 8.h, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (submitting) ...[
            LinearProgressIndicator(
              value: state.progress > 0 ? state.progress : null,
              borderRadius: BorderRadius.circular(20.r),
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 10.h),
          ],
          Row(
            children: [
              if (state.currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: submitting ? null : cubit.previousStep,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(52.h),
                    ),
                    child: Text(strings.back),
                  ),
                ),
              if (state.currentStep > 0) SizedBox(width: 12.w),
              Expanded(
                flex: state.currentStep == 0 ? 1 : 2,
                child: FilledButton(
                  onPressed: submitting
                      ? null
                      : state.isReview
                      ? (state.canSubmit ? cubit.submit : null)
                      : (state.canContinue ? cubit.nextStep : null),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size.fromHeight(52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: submitting
                      ? Text(strings.identityUploading)
                      : Text(
                          state.isReview
                              ? strings.identityConfirmSubmit
                              : strings.continueLabel,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }
}

class _SubmissionSuccessScreen extends StatefulWidget {
  const _SubmissionSuccessScreen({required this.onDone});

  final VoidCallback onDone;

  @override
  State<_SubmissionSuccessScreen> createState() =>
      _SubmissionSuccessScreenState();
}

class _SubmissionSuccessScreenState extends State<_SubmissionSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 950),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(28.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final value = Curves.easeOutCubic.transform(
                      _controller.value,
                    );
                    return SizedBox(
                      width: 142.r,
                      height: 142.r,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 118.r + 16.r * value,
                            height: 118.r + 16.r * value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primary.withValues(
                                alpha: .07 * (1 - value),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 112.r,
                            height: 112.r,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 3.5,
                              backgroundColor: primary.withValues(alpha: .15),
                              color: primary,
                            ),
                          ),
                          Icon(
                            Icons.check_rounded,
                            size: 58.sp * value,
                            color: primary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 28.h),
                Text(
                  strings.identitySubmissionReceived,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 10.h),
                Text(
                  strings.identitySubmissionPending,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 30.h),
                FilledButton(
                  onPressed: widget.onDone,
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 52.h),
                    backgroundColor: primary,
                  ),
                  child: Text(strings.done),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExistingIdentityStatusScreen extends StatelessWidget {
  const _ExistingIdentityStatusScreen({required this.status, this.onTryAgain});

  final String status;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final text = switch (status) {
      'pending' || 'underreview' => strings.identityPending,
      'verified' || 'approved' => strings.identityVerified,
      'rejected' => strings.identityRejected,
      _ => strings.identityUnknown,
    };
    final description = status == 'rejected'
        ? strings.identityRejectedRetryPrompt
        : strings.identityExistingRequest;
    return Scaffold(
      appBar: AppBar(title: Text(strings.identityFlowTitle)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(28.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 64.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 18.h),
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 12.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (onTryAgain != null) ...[
                SizedBox(height: 20.h),
                FilledButton.icon(
                  onPressed: onTryAgain,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(strings.identityTryAgain),
                ),
              ],
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(strings.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _normalizeIdentityStatus(String? status) =>
    status?.trim().toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '') ?? '';
