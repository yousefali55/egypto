class AdminIdentityDetails {
  const AdminIdentityDetails({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
    required this.submittedAt,
    required this.documents,
  });

  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? status;
  final DateTime? submittedAt;
  final AdminIdentityDocuments documents;

  String get fullName => [firstName, lastName]
      .whereType<String>()
      .map((name) => name.trim())
      .where((name) => name.isNotEmpty)
      .join(' ');

  factory AdminIdentityDetails.fromJson(Map<String, dynamic> json) {
    final rawDocuments = json['documents'];
    final documents = rawDocuments is Map
        ? Map<String, dynamic>.from(rawDocuments)
        : const <String, dynamic>{};
    return AdminIdentityDetails(
      userId: _optionalString(json['userId']),
      firstName: _optionalString(json['firstName']),
      lastName: _optionalString(json['lastName']),
      email: _optionalString(json['email']),
      status: _optionalString(json['status']),
      submittedAt: DateTime.tryParse(json['submittedAt']?.toString() ?? ''),
      documents: AdminIdentityDocuments.fromJson(documents),
    );
  }
}

class AdminIdentityDocuments {
  const AdminIdentityDocuments({
    this.selfieViewUrl,
    this.nationalIdFrontViewUrl,
    this.nationalIdBackViewUrl,
  });

  final String? selfieViewUrl;
  final String? nationalIdFrontViewUrl;
  final String? nationalIdBackViewUrl;

  factory AdminIdentityDocuments.fromJson(Map<String, dynamic> json) =>
      AdminIdentityDocuments(
        selfieViewUrl: _optionalString(json['selfieViewUrl']),
        nationalIdFrontViewUrl: _optionalString(json['nationalIdFrontViewUrl']),
        nationalIdBackViewUrl: _optionalString(json['nationalIdBackViewUrl']),
      );
}

String? _optionalString(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value;
}
