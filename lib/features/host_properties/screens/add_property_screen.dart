import 'dart:io';

import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/presentation/cubit/property_creation_cubit.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({
    super.key,
    required this.profile,
    this.onSubmitted,
    this.allowAdmin = false,
  });

  final UserProfileModel profile;
  final VoidCallback? onSubmitted;
  final bool allowAdmin;

  @override
  Widget build(BuildContext context) {
    if (!profile.isHost && !(allowAdmin && profile.isAdmin)) {
      return Scaffold(
        appBar: AppBar(title: Text(S.of(context).addPropertyTitle)),
        body: Center(child: Text(S.of(context).addPropertyUnauthorized)),
      );
    }
    return BlocProvider(
      create: (_) => getIt<PropertyCreationCubit>()..loadAmenities(),
      child: _AddPropertyForm(onSubmitted: onSubmitted),
    );
  }
}

class _AddPropertyForm extends StatefulWidget {
  const _AddPropertyForm({this.onSubmitted});

  final VoidCallback? onSubmitted;

  @override
  State<_AddPropertyForm> createState() => _AddPropertyFormState();
}

class _AddPropertyFormState extends State<_AddPropertyForm> {
  static const int _minimumImages = 4;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _beds = TextEditingController();
  final _rooms = TextEditingController();
  final _guests = TextEditingController();
  final _bathrooms = TextEditingController();
  final _nightlyPrice = TextEditingController();
  final _country = TextEditingController(text: 'Egypt');
  final _governorate = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  final List<XFile> _images = [];
  bool _pickingImages = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _beds.dispose();
    _rooms.dispose();
    _guests.dispose();
    _bathrooms.dispose();
    _nightlyPrice.dispose();
    _country.dispose();
    _governorate.dispose();
    _city.dispose();
    _address.dispose();
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_pickingImages || _isWorking(context)) return;
    setState(() => _pickingImages = true);
    try {
      final selected = await _picker.pickMultiImage(imageQuality: 90);
      if (!mounted || selected.isEmpty) return;
      final existing = _images.map((image) => image.path).toSet();
      setState(() {
        _images.addAll(
          selected.where((image) => !existing.contains(image.path)),
        );
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).propertyWorkflowError)),
      );
    } finally {
      if (mounted) setState(() => _pickingImages = false);
    }
  }

  Future<void> _submit(PropertyCreationState state) async {
    if (!_formKey.currentState!.validate()) return;
    final strings = S.of(context);
    final imagePaths = _images.map((image) => image.path).toList();
    if (imagePaths.length < _minimumImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_imageSelectionSummary(strings, imagePaths.length)),
        ),
      );
      return;
    }

    final request = CreatePropertyRequest(
      title: _title.text.trim(),
      description: _description.text.trim(),
      beds: int.parse(_beds.text),
      rooms: int.parse(_rooms.text),
      guests: int.parse(_guests.text),
      bathrooms: int.parse(_bathrooms.text),
      nightlyPrice: double.parse(_nightlyPrice.text),
      location: PropertyLocationRequest(
        country: _country.text.trim(),
        governorate: _governorate.text.trim(),
        city: _city.text.trim(),
        address: _address.text.trim(),
        latitude: double.parse(_latitude.text),
        longitude: double.parse(_longitude.text),
      ),
      amenityIds: state.selectedAmenityIds.toList(growable: false),
    );
    await context.read<PropertyCreationCubit>().submit(request, imagePaths);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.addPropertyTitle)),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocConsumer<PropertyCreationCubit, PropertyCreationState>(
        listener: (context, state) {
          if (state.stage == PropertyCreationStage.succeeded) {
            widget.onSubmitted?.call();
          }
        },
        builder: (context, state) {
          final busy = _isWorking(context);
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 36.h),
              children: [
                _textField(
                  controller: _title,
                  label: strings.propertyTitleLabel,
                  requiredField: true,
                ),
                _textField(
                  controller: _description,
                  label: strings.propertyDescriptionLabel,
                  requiredField: true,
                  maxLines: 4,
                ),
                _countField(_beds, strings.bedsLabel, minimum: 0),
                _countField(_rooms, strings.roomsLabel, minimum: 1),
                _countField(_guests, strings.guestsLabel, minimum: 1),
                _countField(_bathrooms, strings.bathroomsLabel, minimum: 0),
                _textField(
                  controller: _nightlyPrice,
                  label: strings.nightlyPriceLabel,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final price = double.tryParse(value?.trim() ?? '');
                    if (price == null || !price.isFinite || price <= 0) {
                      return strings.invalidPositiveNumber;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),
                _textField(
                  controller: _country,
                  label: strings.countryLabel,
                  requiredField: true,
                ),
                _textField(
                  controller: _governorate,
                  label: strings.governorateLabel,
                  requiredField: true,
                ),
                _textField(
                  controller: _city,
                  label: strings.cityLabel,
                  requiredField: true,
                ),
                _textField(
                  controller: _address,
                  label: strings.addressLabel,
                  requiredField: true,
                  maxLines: 2,
                ),
                _coordinateField(
                  _latitude,
                  strings.latitudeLabel,
                  minimum: -90,
                  maximum: 90,
                  error: strings.invalidLatitude,
                ),
                _coordinateField(
                  _longitude,
                  strings.longitudeLabel,
                  minimum: -180,
                  maximum: 180,
                  error: strings.invalidLongitude,
                ),
                SizedBox(height: 14.h),
                Text(
                  strings.amenitiesLabel,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                if (state.stage == PropertyCreationStage.loadingAmenities)
                  const LinearProgressIndicator(),
                if (state.failedAt == PropertyCreationStage.loadingAmenities)
                  Row(
                    children: [
                      Expanded(child: Text(strings.amenitiesLoadError)),
                      IconButton(
                        onPressed: busy
                            ? null
                            : () => context
                                  .read<PropertyCreationCubit>()
                                  .loadAmenities(),
                        tooltip: strings.retry,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 2.h,
                  children: state.amenities
                      .map(
                        (amenity) => FilterChip(
                          label: Text(amenity.name),
                          selected: state.selectedAmenityIds.contains(
                            amenity.id,
                          ),
                          onSelected: busy
                              ? null
                              : (_) => context
                                    .read<PropertyCreationCubit>()
                                    .toggleAmenity(amenity.id),
                          selectedColor: AppColors.darkGlow.withValues(
                            alpha: 0.15,
                          ),
                          checkmarkColor: AppColors.darkGlow,
                        ),
                      )
                      .toList(growable: false),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.propertyImagesLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      _imageSelectionSummary(strings, _images.length),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 9.w,
                  runSpacing: 9.h,
                  children: [
                    ..._images.asMap().entries.map(
                      (entry) => _ImagePreview(
                        image: entry.value,
                        onRemove: busy
                            ? null
                            : () => setState(() => _images.removeAt(entry.key)),
                        removeLabel: strings.removePropertyImage,
                      ),
                    ),
                    SizedBox(
                      width: 82.w,
                      height: 82.w,
                      child: OutlinedButton(
                        onPressed: busy || _pickingImages ? null : _pickImages,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: _pickingImages
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.add_photo_alternate_outlined),
                      ),
                    ),
                  ],
                ),
                if (state.error != null) ...[
                  SizedBox(height: 14.h),
                  Text(
                    _localizedFailure(strings, state),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                if (state.stage == PropertyCreationStage.uploading) ...[
                  SizedBox(height: 12.h),
                  LinearProgressIndicator(value: state.uploadProgress),
                ],
                if (state.stage == PropertyCreationStage.succeeded) ...[
                  SizedBox(height: 14.h),
                  Text(
                    '${strings.propertySubmissionSuccess} ${state.status ?? ''}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                SizedBox(height: 20.h),
                if (state.stage == PropertyCreationStage.failed &&
                    state.canRetry &&
                    state.failedAt != PropertyCreationStage.creating)
                  FilledButton.icon(
                    onPressed: busy || _images.length < _minimumImages
                        ? null
                        : () => context.read<PropertyCreationCubit>().retry(
                            imagePaths: _images
                                .map((image) => image.path)
                                .toList(growable: false),
                          ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(strings.retry),
                  )
                else if (state.stage != PropertyCreationStage.succeeded &&
                    !(state.stage == PropertyCreationStage.failed &&
                        !state.canRetry))
                  FilledButton.icon(
                    onPressed: busy || _images.length < _minimumImages
                        ? null
                        : () => _submit(state),
                    icon: busy
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.publish_rounded),
                    label: Text(
                      state.stage == PropertyCreationStage.failed
                          ? strings.retry
                          : _stageLabel(strings, state),
                    ),
                  ),
                SizedBox(height: 60.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (value) => requiredField && (value == null || value.trim().isEmpty)
              ? S.of(context).fieldRequired
              : null,
    ),
  );

  Widget _countField(
    TextEditingController controller,
    String label, {
    required int minimum,
  }) => _textField(
    controller: controller,
    label: label,
    keyboardType: TextInputType.number,
    validator: (value) {
      final count = int.tryParse(value?.trim() ?? '');
      if (count == null || count < minimum) return S.of(context).invalidCount;
      return null;
    },
  );

  Widget _coordinateField(
    TextEditingController controller,
    String label, {
    required double minimum,
    required double maximum,
    required String error,
  }) => _textField(
    controller: controller,
    label: label,
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
      signed: true,
    ),
    validator: (value) {
      final coordinate = double.tryParse(value?.trim() ?? '');
      if (coordinate == null ||
          !coordinate.isFinite ||
          coordinate < minimum ||
          coordinate > maximum) {
        return error;
      }
      return null;
    },
  );
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.image,
    required this.onRemove,
    required this.removeLabel,
  });

  final XFile image;
  final VoidCallback? onRemove;
  final String removeLabel;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 82.w,
    height: 82.w,
    child: Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.file(File(image.path), fit: BoxFit.cover),
        ),
        PositionedDirectional(
          top: 2,
          end: 2,
          child: IconButton.filledTonal(
            onPressed: onRemove,
            tooltip: removeLabel,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close_rounded, size: 17),
          ),
        ),
      ],
    ),
  );
}

bool _isWorking(BuildContext context) {
  final stage = context.read<PropertyCreationCubit>().state.stage;
  return stage == PropertyCreationStage.loadingAmenities ||
      stage == PropertyCreationStage.creating ||
      stage == PropertyCreationStage.uploading ||
      stage == PropertyCreationStage.submitting;
}

String _stageLabel(S strings, PropertyCreationState state) =>
    switch (state.stage) {
      PropertyCreationStage.creating => strings.propertyCreating,
      PropertyCreationStage.uploading =>
        '${strings.propertyUploading} ${(state.uploadProgress * 100).round()}%',
      PropertyCreationStage.submitting => strings.propertySubmitting,
      _ => strings.submitProperty,
    };

String _localizedFailure(S strings, PropertyCreationState state) {
  if (state.failedAt == PropertyCreationStage.loadingAmenities) {
    return strings.amenitiesLoadError;
  }
  if (state.failedAt == PropertyCreationStage.creating && !state.canRetry) {
    return strings.propertyCreationIdMissing;
  }
  if (state.failedAt == PropertyCreationStage.submitting &&
      state.error?.toLowerCase().contains('status') == true) {
    return strings.propertyStatusMissing;
  }
  if (state.error == 'Select at least four property images.') {
    return strings.minimumImagesRequired;
  }
  return strings.propertyWorkflowError;
}

String _imageSelectionSummary(S strings, int selected) =>
    '$selected/4 ${strings.imageSelectionCount} '
    '(${strings.minimumImagesRequired})';
