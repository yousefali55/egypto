import 'package:intl/intl.dart';

class SearchPropertiesFilters {
  const SearchPropertiesFilters({
    this.city,
    this.guests,
    this.checkIn,
    this.checkOut,
  });

  final String? city;
  final int? guests;
  final DateTime? checkIn;
  final DateTime? checkOut;

  Map<String, dynamic> toQueryParameters() {
    final parameters = <String, dynamic>{};
    final selectedCity = city?.trim();
    if (selectedCity != null && selectedCity.isNotEmpty) {
      parameters['city'] = selectedCity;
    }

    if (guests != null) {
      if (guests! < 1) {
        throw ArgumentError.value(guests, 'guests', 'Must be at least one.');
      }
      parameters['guests'] = guests;
    }

    if ((checkIn == null) != (checkOut == null)) {
      throw ArgumentError(
        'Check-in and check-out dates must be selected together.',
      );
    }
    if (checkIn != null && checkOut != null) {
      if (!checkOut!.isAfter(checkIn!)) {
        throw ArgumentError('Check-out must be after check-in.');
      }
      parameters['checkIn'] = DateFormat('yyyy-MM-dd').format(checkIn!);
      parameters['checkOut'] = DateFormat('yyyy-MM-dd').format(checkOut!);
    }

    return parameters;
  }

  @override
  bool operator ==(Object other) =>
      other is SearchPropertiesFilters &&
      other.city == city &&
      other.guests == guests &&
      other.checkIn == checkIn &&
      other.checkOut == checkOut;

  @override
  int get hashCode => Object.hash(city, guests, checkIn, checkOut);
}
