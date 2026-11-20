class ApiConstants {
  static const String baseUrl =
      "https://botanist-envy-reference.ngrok-free.dev/api/v1/";

  static String? resolveUploadUrl(String? path) {
    if (path == null || path.trim().isEmpty) return null;

    final value = path.trim();
    final uri = Uri.tryParse(value);
    if (uri == null) return null;

    if (uri.hasScheme) {
      if ((uri.scheme != 'http' && uri.scheme != 'https') ||
          !uri.hasAuthority ||
          uri.host.isEmpty) {
        return null;
      }
      return uri.toString();
    }

    final rootRelativePath = '/${value.replaceFirst(RegExp(r'^/+'), '')}';
    return Uri.parse(baseUrl).resolve(rootRelativePath).toString();
  }

  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String verifyOtp = "auth/verify-otp";
  static const String resendOtp = "auth/resend-otp";
  static const String refresh = "auth/refresh";
  static const String getProfile = 'profile';
  static const String identity = 'identity';
  static const String hostProperties = 'properties/host';
  static const String activateHost = 'profile/activate-host';
  static const String properties = 'properties';
  static const String amenities = 'amenities';
  static const String searchProperties = 'search/properties';
  static const String bookings = 'bookings';
  static const String hostBookings = 'host/bookings';
  static const String adminPayments = 'admin/payments';
  static const String adminIdentity = 'admin/identity';
  static const String adminProperties = 'admin/properties';
  static const String adminPendingProperties = '$adminProperties/pending';
}
