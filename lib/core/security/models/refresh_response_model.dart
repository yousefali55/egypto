import 'package:json_annotation/json_annotation.dart';
part 'refresh_response_model.g.dart';

@JsonSerializable()
class RefreshResponseModel {
  final String accessToken;
  final String refreshToken;

  new({required this.accessToken, required this.refreshToken});
  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshResponseModelToJson(this);
}


