String? normalizeEgyptianMobileNumber(String input) {
  final normalized = input.trim().replaceAll(RegExp(r'[\s()-]'), '');

  if (RegExp(r'^\+20[1][0125]\d{8}$').hasMatch(normalized)) {
    return normalized;
  }

  if (RegExp(r'^01[0125]\d{8}$').hasMatch(normalized)) {
    return '+20${normalized.substring(1)}';
  }

  return null;
}

String egyptianMobileInputValue(String? phone) {
  final value = phone?.trim() ?? '';
  if (RegExp(r'^\+20[1][0125]\d{8}$').hasMatch(value)) {
    return '0${value.substring(3)}';
  }
  return value;
}
