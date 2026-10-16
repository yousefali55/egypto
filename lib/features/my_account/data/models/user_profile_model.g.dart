// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      isHost: json['isHost'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
      identityVerificationStatus: json['identityVerificationStatus'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'isHost': instance.isHost,
      'isAdmin': instance.isAdmin,
      'identityVerificationStatus': instance.identityVerificationStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
