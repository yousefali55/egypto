import 'package:json_annotation/json_annotation.dart';

part 'refresh_request_model.g.dart';

@JsonSerializable()
class RefreshRequestModel {
  final String refreshToken;

  const RefreshRequestModel({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() =>
      _$RefreshRequestModelToJson(this);

  factory RefreshRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RefreshRequestModelFromJson(json);
}