// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshResponseModel _$RefreshResponseModelFromJson(
  Map<String, dynamic> json,
) => RefreshResponseModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$RefreshResponseModelToJson(
  RefreshResponseModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
