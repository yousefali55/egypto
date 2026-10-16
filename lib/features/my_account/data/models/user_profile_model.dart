import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  const UserProfileModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.isHost = false,
    this.isAdmin = false,
    this.identityVerificationStatus,
    this.createdAt,
  });

  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final bool isHost;
  final bool isAdmin;
  final String? identityVerificationStatus;
  final DateTime? createdAt;

  String get fullName => '$firstName $lastName'.trim();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
