class IdentityVerificationRequest {
  const IdentityVerificationRequest({
    required this.selfiePath,
    required this.nationalIdFrontPath,
    required this.nationalIdBackPath,
  });

  final String selfiePath;
  final String nationalIdFrontPath;
  final String nationalIdBackPath;
}
