class CreateBookingRequest {
  const CreateBookingRequest({
    required this.propertyId,
    required this.checkInDate,
    required this.checkOutDate,
  });

  final String propertyId;
  final String checkInDate;
  final String checkOutDate;

  Map<String, dynamic> toJson() => {
    'propertyId': propertyId,
    'checkInDate': checkInDate,
    'checkOutDate': checkOutDate,
  };
}

class BookingFinancialSnapshot {
  const BookingFinancialSnapshot({
    this.nightlyPrice,
    this.numberOfNights,
    this.grossAmount,
    this.serviceFee,
    this.hostAmount,
  });

  final double? nightlyPrice;
  final int? numberOfNights;
  final double? grossAmount;
  final double? serviceFee;
  final double? hostAmount;

  factory BookingFinancialSnapshot.fromJson(Object? value) {
    final json = _asMap(value);
    return BookingFinancialSnapshot(
      nightlyPrice: _asDouble(json['nightlyPrice']),
      numberOfNights: _asInt(json['numberOfNights']),
      grossAmount: _asDouble(json['grossAmount']),
      serviceFee: _asDouble(json['serviceFee']),
      hostAmount: _asDouble(json['hostAmount']),
    );
  }
}

class BookingDetails {
  const BookingDetails({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    this.propertyAddress,
    this.checkInDate,
    this.checkOutDate,
    this.status,
    this.financialSnapshot = const BookingFinancialSnapshot(),
    this.paymentStatus,
    this.createdAt,
    this.expiresAt,
    this.decidedAt,
    this.paymentReceiptSubmitted,
    this.paymentReceiptStatus,
    this.paymentRejectionReason,
    this.paymentReceiptUrl,
    this.resubmissionAllowed,
  });

  final String id;
  final String propertyId;
  final String propertyTitle;
  final String? propertyAddress;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? status;
  final BookingFinancialSnapshot financialSnapshot;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? decidedAt;
  final bool? paymentReceiptSubmitted;
  final String? paymentReceiptStatus;
  final String? paymentRejectionReason;
  final String? paymentReceiptUrl;
  final bool? resubmissionAllowed;

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    final property = _asMap(json['property']);
    return BookingDetails(
      id: _asString(json['id']),
      propertyId: _asString(json['propertyId']).isNotEmpty
          ? _asString(json['propertyId'])
          : _asString(property['id']),
      propertyTitle: _asString(json['propertyTitle']).isNotEmpty
          ? _asString(json['propertyTitle'])
          : _asString(property['title']),
      propertyAddress: _nullableString(property['address']),
      checkInDate: _asDate(json['checkInDate']),
      checkOutDate: _asDate(json['checkOutDate']),
      status: _nullableString(json['status']),
      financialSnapshot: BookingFinancialSnapshot.fromJson(
        json['financialSnapshot'] ??
            (json.containsKey('grossAmount')
                ? {'grossAmount': json['grossAmount']}
                : null),
      ),
      paymentStatus: _nullableString(json['paymentStatus']),
      createdAt: _asDateTime(json['createdAt']),
      expiresAt: _asDateTime(json['expiresAt']),
      decidedAt: _asDateTime(json['decidedAt']),
      paymentReceiptSubmitted:
          _asBool(json['paymentReceiptSubmitted']) ??
          _asBool(json['receiptSubmitted']),
      paymentReceiptStatus: _nullableString(
        json['paymentReceiptStatus'] ?? json['receiptStatus'],
      ),
      paymentRejectionReason: _nullableString(
        json['paymentRejectionReason'] ??
            json['rejectionReason'] ??
            json['receiptRejectionReason'],
      ),
      paymentReceiptUrl: _nullableString(
        json['paymentReceiptUrl'] ?? json['receiptUrl'],
      ),
      resubmissionAllowed:
          _asBool(json['paymentResubmissionAllowed']) ??
          _asBool(json['resubmissionAllowed']),
    );
  }
}

class BookingPage {
  const BookingPage({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final List<BookingDetails> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  factory BookingPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems is! List || rawItems.any((item) => item is! Map)) {
      throw const FormatException(
        'Booking page items must be a list of objects.',
      );
    }
    return BookingPage(
      items: rawItems
          .map(
            (item) =>
                BookingDetails.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
      totalCount: _asInt(json['totalCount']) ?? 0,
      pageNumber: _asInt(json['pageNumber']) ?? 1,
      pageSize: _asInt(json['pageSize']) ?? 20,
      totalPages: _asInt(json['totalPages']) ?? 0,
      hasNextPage: json['hasNextPage'] == true,
      hasPreviousPage: json['hasPreviousPage'] == true,
    );
  }
}

class HostBookingRequest {
  const HostBookingRequest({
    required this.id,
    required this.guestName,
    required this.propertyTitle,
    this.checkInDate,
    this.checkOutDate,
    this.grossAmount,
    this.createdAt,
    this.hoursRemaining,
    this.status,
    this.paymentStatus,
  });

  final String id;
  final String guestName;
  final String propertyTitle;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final double? grossAmount;
  final DateTime? createdAt;
  final double? hoursRemaining;
  final String? status;
  final String? paymentStatus;

  factory HostBookingRequest.fromJson(Map<String, dynamic> json) =>
      HostBookingRequest(
        id: _asString(json['id']),
        guestName: _asString(json['guestName']),
        propertyTitle: _asString(json['propertyTitle']),
        checkInDate: _asDate(json['checkInDate']),
        checkOutDate: _asDate(json['checkOutDate']),
        grossAmount: _asDouble(json['grossAmount']),
        createdAt: _asDateTime(json['createdAt']),
        hoursRemaining: _asDouble(json['hoursRemaining']),
        status: _nullableString(json['status']),
        paymentStatus: _nullableString(json['paymentStatus']),
      );
}

class HostBookingPage {
  const HostBookingPage({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final List<HostBookingRequest> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  factory HostBookingPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems is! List || rawItems.any((item) => item is! Map)) {
      throw const FormatException(
        'Host booking items must be a list of objects.',
      );
    }
    return HostBookingPage(
      items: rawItems
          .map(
            (item) => HostBookingRequest.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
      totalCount: _asInt(json['totalCount']) ?? 0,
      pageNumber: _asInt(json['pageNumber']) ?? 1,
      pageSize: _asInt(json['pageSize']) ?? 20,
      totalPages: _asInt(json['totalPages']) ?? 0,
      hasNextPage: json['hasNextPage'] == true,
      hasPreviousPage: json['hasPreviousPage'] == true,
    );
  }
}

class BookingDecisionResponse {
  const BookingDecisionResponse({
    required this.id,
    this.status,
    this.paymentStatus,
    this.decidedAt,
    this.message,
  });

  final String id;
  final String? status;
  final String? paymentStatus;
  final DateTime? decidedAt;
  final String? message;

  factory BookingDecisionResponse.fromJson(Map<String, dynamic> json) {
    final id = _asString(json['id']);
    final status = _nullableString(json['status']);
    final paymentStatus = _nullableString(json['paymentStatus']);
    if (id.isEmpty || status == null || paymentStatus == null) {
      throw const FormatException('Booking decision response is incomplete.');
    }
    return BookingDecisionResponse(
      id: id,
      status: status,
      paymentStatus: paymentStatus,
      decidedAt: _asDateTime(json['decidedAt']),
      message: _nullableString(json['message']),
    );
  }
}

class BookingApiException implements Exception {
  const BookingApiException({this.code, this.statusCode, this.cause});

  final String? code;
  final int? statusCode;
  final Object? cause;
}

Map<String, dynamic> _asMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

String _asString(Object? value) => value?.toString() ?? '';

String? _nullableString(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int? _asInt(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');

double? _asDouble(Object? value) =>
    value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '');

bool? _asBool(Object? value) =>
    value is bool ? value : bool.tryParse(value?.toString() ?? '');

DateTime? _asDate(Object? value) {
  final text = value?.toString();
  if (text == null || text.length < 10) return null;
  return DateTime.tryParse(text.substring(0, 10));
}

DateTime? _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '');

String dateOnly(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
