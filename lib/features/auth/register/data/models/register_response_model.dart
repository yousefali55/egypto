import 'package:json_annotation/json_annotation.dart';
part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final String userId;
  final String email;
  final String message;

  new({required this.userId, required this.email, required this.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}

// {
//     "userId": "10bf3e1a-f28e-428f-9f1f-4065774ec007",
//     "email": "Elyoo1@egypto.com",
//     "message": "Registration initiated. Please verify your email with the OTP sent."
// }
