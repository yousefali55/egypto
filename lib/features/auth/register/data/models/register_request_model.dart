import 'package:json_annotation/json_annotation.dart';
part 'register_request_model.g.dart';
@JsonSerializable()
class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;

  new({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => 
  _$RegisterRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}

// {
//   "firstName": "Abdo",
//   "lastName": "Zikel",
//   "email": "zikel@egypto.com",
//   "password": "Test@1234",
//   "role": "Guest"
// }
