import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum IdentityImageSlot { selfie, nationalIdFront, nationalIdBack }

abstract interface class IdentityImagePicker {
  Future<XFile?> pick({
    required IdentityImageSlot slot,
    required ImageSource source,
  });
}

class DeviceIdentityImagePicker implements IdentityImagePicker {
  DeviceIdentityImagePicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> pick({
    required IdentityImageSlot slot,
    required ImageSource source,
  }) async {
    try {
      return await _picker.pickImage(
        source: source,
        preferredCameraDevice: slot == IdentityImageSlot.selfie
            ? CameraDevice.front
            : CameraDevice.rear,
      );
    } on PlatformException {
      rethrow;
    }
  }
}
