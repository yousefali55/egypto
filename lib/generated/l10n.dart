// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Search Easily`
  String get onBoardingTitle {
    return Intl.message(
      'Search Easily',
      name: 'onBoardingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Discover the best housing available in your area with ease and speed`
  String get onBoardingDescription {
    return Intl.message(
      'Discover the best housing available in your area with ease and speed',
      name: 'onBoardingDescription',
      desc: '',
      args: [],
    );
  }

  /// `Book with Confidence`
  String get onBoardingTitle2 {
    return Intl.message(
      'Book with Confidence',
      name: 'onBoardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Connect directly with the owner and book the perfect accommodation for you safely`
  String get onBoardingDescription2 {
    return Intl.message(
      'Connect directly with the owner and book the perfect accommodation for you safely',
      name: 'onBoardingDescription2',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy Your Stay`
  String get onBoardingTitle3 {
    return Intl.message(
      'Enjoy Your Stay',
      name: 'onBoardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy your stay in the accommodation you chose and have an unforgettable experience`
  String get onBoardingDescription3 {
    return Intl.message(
      'Enjoy your stay in the accommodation you chose and have an unforgettable experience',
      name: 'onBoardingDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Enter your data to continue`
  String get enterData {
    return Intl.message(
      'Enter your data to continue',
      name: 'enterData',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Register New Account`
  String get registerNewAcc {
    return Intl.message(
      'Register New Account',
      name: 'registerNewAcc',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Create Account`
  String get register {
    return Intl.message('Create Account', name: 'register', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter Verification Code`
  String get enterVerficationCode {
    return Intl.message(
      'Enter Verification Code',
      name: 'enterVerficationCode',
      desc: '',
      args: [],
    );
  }

  /// `Check the message sent to your email`
  String get checkOtp {
    return Intl.message(
      'Check the message sent to your email',
      name: 'checkOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get resendCode {
    return Intl.message('Resend code', name: 'resendCode', desc: '', args: []);
  }

  /// `Resend code in`
  String get otpResendAvailableIn {
    return Intl.message(
      'Resend code in',
      name: 'otpResendAvailableIn',
      desc: '',
      args: [],
    );
  }

  /// `Sending a new code...`
  String get otpResending {
    return Intl.message(
      'Sending a new code...',
      name: 'otpResending',
      desc: '',
      args: [],
    );
  }

  /// `A new verification code has been sent.`
  String get otpResendSuccess {
    return Intl.message(
      'A new verification code has been sent.',
      name: 'otpResendSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Email verified. Please sign in to continue.`
  String get otpVerificationSuccess {
    return Intl.message(
      'Email verified. Please sign in to continue.',
      name: 'otpVerificationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Enter the complete six-digit code.`
  String get otpCodeRequired {
    return Intl.message(
      'Enter the complete six-digit code.',
      name: 'otpCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `This code is invalid or expired. Check it and try again.`
  String get otpInvalidOrExpired {
    return Intl.message(
      'This code is invalid or expired. Check it and try again.',
      name: 'otpInvalidOrExpired',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect. Check your connection and try again.`
  String get otpNetworkError {
    return Intl.message(
      'Could not connect. Check your connection and try again.',
      name: 'otpNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `The service is temporarily unavailable. Please try again later.`
  String get otpServerError {
    return Intl.message(
      'The service is temporarily unavailable. Please try again later.',
      name: 'otpServerError',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't complete that request. Please try again.`
  String get otpGenericError {
    return Intl.message(
      'We couldn\'t complete that request. Please try again.',
      name: 'otpGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Choose an account type to continue.`
  String get roleRequired {
    return Intl.message(
      'Choose an account type to continue.',
      name: 'roleRequired',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Cairo, Egypt`
  String get homeLocation {
    return Intl.message(
      'Cairo, Egypt',
      name: 'homeLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `Coming soon`
  String get comingSoon {
    return Intl.message('Coming soon', name: 'comingSoon', desc: '', args: []);
  }

  /// `Family apartment`
  String get propertyFamilyApartment {
    return Intl.message(
      'Family apartment',
      name: 'propertyFamilyApartment',
      desc: '',
      args: [],
    );
  }

  /// `Modern apartment with a stunning view`
  String get propertyModernApartment {
    return Intl.message(
      'Modern apartment with a stunning view',
      name: 'propertyModernApartment',
      desc: '',
      args: [],
    );
  }

  /// `Furnished apartment near services`
  String get propertyFurnishedApartment {
    return Intl.message(
      'Furnished apartment near services',
      name: 'propertyFurnishedApartment',
      desc: '',
      args: [],
    );
  }

  /// `Giza, Egypt`
  String get propertyLocationGiza {
    return Intl.message(
      'Giza, Egypt',
      name: 'propertyLocationGiza',
      desc: '',
      args: [],
    );
  }

  /// `New Cairo, Egypt`
  String get propertyLocationNewCairo {
    return Intl.message(
      'New Cairo, Egypt',
      name: 'propertyLocationNewCairo',
      desc: '',
      args: [],
    );
  }

  /// `Nasr City, Egypt`
  String get propertyLocationNasrCity {
    return Intl.message(
      'Nasr City, Egypt',
      name: 'propertyLocationNasrCity',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message('Filters', name: 'filters', desc: '', args: []);
  }

  /// `Choose or enter a city`
  String get cityFieldHint {
    return Intl.message(
      'Choose or enter a city',
      name: 'cityFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Stay dates`
  String get datesLabel {
    return Intl.message('Stay dates', name: 'datesLabel', desc: '', args: []);
  }

  /// `Check-in`
  String get checkInDate {
    return Intl.message('Check-in', name: 'checkInDate', desc: '', args: []);
  }

  /// `Check-out`
  String get checkOutDate {
    return Intl.message('Check-out', name: 'checkOutDate', desc: '', args: []);
  }

  /// `Select date`
  String get selectDate {
    return Intl.message('Select date', name: 'selectDate', desc: '', args: []);
  }

  /// `Guests`
  String get guestsLabel {
    return Intl.message('Guests', name: 'guestsLabel', desc: '', args: []);
  }

  /// `Any number`
  String get anyGuests {
    return Intl.message('Any number', name: 'anyGuests', desc: '', args: []);
  }

  /// `{count, plural, one{1 guest} other{{count} guests}}`
  String guestCount(num count) {
    return Intl.plural(
      count,
      one: '1 guest',
      other: '$count guests',
      name: 'guestCount',
      desc: '',
      args: [count],
    );
  }

  /// `Increase guests`
  String get increaseGuests {
    return Intl.message(
      'Increase guests',
      name: 'increaseGuests',
      desc: '',
      args: [],
    );
  }

  /// `Decrease guests`
  String get decreaseGuests {
    return Intl.message(
      'Decrease guests',
      name: 'decreaseGuests',
      desc: '',
      args: [],
    );
  }

  /// `Apply filters`
  String get applyFilters {
    return Intl.message(
      'Apply filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Reset filters`
  String get resetFilters {
    return Intl.message(
      'Reset filters',
      name: 'resetFilters',
      desc: '',
      args: [],
    );
  }

  /// `Clear filters and search`
  String get clearFilters {
    return Intl.message(
      'Clear filters and search',
      name: 'clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Select both check-in and check-out dates.`
  String get selectBothDates {
    return Intl.message(
      'Select both check-in and check-out dates.',
      name: 'selectBothDates',
      desc: '',
      args: [],
    );
  }

  /// `Check-out must be later than check-in.`
  String get invalidDateRange {
    return Intl.message(
      'Check-out must be later than check-in.',
      name: 'invalidDateRange',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Remove from favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `No properties match your search`
  String get noPropertiesFound {
    return Intl.message(
      'No properties match your search',
      name: 'noPropertiesFound',
      desc: '',
      args: [],
    );
  }

  /// `Property details`
  String get propertyDetailsTitle {
    return Intl.message(
      'Property details',
      name: 'propertyDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Up to 1 guest} other{Up to {count} guests}}`
  String propertyCapacity(num count) {
    return Intl.plural(
      count,
      one: 'Up to 1 guest',
      other: 'Up to $count guests',
      name: 'propertyCapacity',
      desc: '',
      args: [count],
    );
  }

  /// `Choose your stay`
  String get bookingDatesLabel {
    return Intl.message(
      'Choose your stay',
      name: 'bookingDatesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Log in to request booking`
  String get loginToBook {
    return Intl.message(
      'Log in to request booking',
      name: 'loginToBook',
      desc: '',
      args: [],
    );
  }

  /// `Only Guests can request bookings`
  String get guestBookingOnly {
    return Intl.message(
      'Only Guests can request bookings',
      name: 'guestBookingOnly',
      desc: '',
      args: [],
    );
  }

  /// `Complete identity verification`
  String get completeIdentityVerification {
    return Intl.message(
      'Complete identity verification',
      name: 'completeIdentityVerification',
      desc: '',
      args: [],
    );
  }

  /// `Request booking`
  String get requestBooking {
    return Intl.message(
      'Request booking',
      name: 'requestBooking',
      desc: '',
      args: [],
    );
  }

  /// `Select check-in and check-out dates.`
  String get selectBookingDates {
    return Intl.message(
      'Select check-in and check-out dates.',
      name: 'selectBookingDates',
      desc: '',
      args: [],
    );
  }

  /// `Check-in cannot be before today.`
  String get bookingCheckInPast {
    return Intl.message(
      'Check-in cannot be before today.',
      name: 'bookingCheckInPast',
      desc: '',
      args: [],
    );
  }

  /// `Choose a stay between 1 and 30 nights.`
  String get bookingStayLengthInvalid {
    return Intl.message(
      'Choose a stay between 1 and 30 nights.',
      name: 'bookingStayLengthInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Review your booking request`
  String get confirmBookingTitle {
    return Intl.message(
      'Review your booking request',
      name: 'confirmBookingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm request`
  String get confirmBooking {
    return Intl.message(
      'Confirm request',
      name: 'confirmBooking',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{1 night} other{{count} nights}}`
  String bookingNights(num count) {
    return Intl.plural(
      count,
      one: '1 night',
      other: '$count nights',
      name: 'bookingNights',
      desc: '',
      args: [count],
    );
  }

  /// `Nights`
  String get bookingNightsLabel {
    return Intl.message(
      'Nights',
      name: 'bookingNightsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Booking request`
  String get bookingConfirmationTitle {
    return Intl.message(
      'Booking request',
      name: 'bookingConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your booking request was submitted.`
  String get bookingCreatedMessage {
    return Intl.message(
      'Your booking request was submitted.',
      name: 'bookingCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get bookingPending {
    return Intl.message('Pending', name: 'bookingPending', desc: '', args: []);
  }

  /// `Confirmed`
  String get bookingConfirmed {
    return Intl.message(
      'Confirmed',
      name: 'bookingConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get bookingRejected {
    return Intl.message(
      'Rejected',
      name: 'bookingRejected',
      desc: '',
      args: [],
    );
  }

  /// `Held`
  String get paymentHeld {
    return Intl.message('Held', name: 'paymentHeld', desc: '', args: []);
  }

  /// `Refunded`
  String get paymentRefunded {
    return Intl.message(
      'Refunded',
      name: 'paymentRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Gross amount`
  String get grossAmountLabel {
    return Intl.message(
      'Gross amount',
      name: 'grossAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Service fee`
  String get serviceFeeLabel {
    return Intl.message(
      'Service fee',
      name: 'serviceFeeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Host amount`
  String get hostAmountLabel {
    return Intl.message(
      'Host amount',
      name: 'hostAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Booking status`
  String get bookingStatusLabel {
    return Intl.message(
      'Booking status',
      name: 'bookingStatusLabel',
      desc: '',
      args: [],
    );
  }

  /// `Payment status`
  String get paymentStatusLabel {
    return Intl.message(
      'Payment status',
      name: 'paymentStatusLabel',
      desc: '',
      args: [],
    );
  }

  /// `Requested on`
  String get bookingCreatedAt {
    return Intl.message(
      'Requested on',
      name: 'bookingCreatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Decision time`
  String get bookingDecidedAt {
    return Intl.message(
      'Decision time',
      name: 'bookingDecidedAt',
      desc: '',
      args: [],
    );
  }

  /// `Request expires`
  String get bookingExpiresAt {
    return Intl.message(
      'Request expires',
      name: 'bookingExpiresAt',
      desc: '',
      args: [],
    );
  }

  /// `My bookings`
  String get guestBookingsTitle {
    return Intl.message(
      'My bookings',
      name: 'guestBookingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Guest bookings are not available for this account.`
  String get guestBookingsUnauthorized {
    return Intl.message(
      'Guest bookings are not available for this account.',
      name: 'guestBookingsUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `You have no bookings yet.`
  String get noGuestBookings {
    return Intl.message(
      'You have no bookings yet.',
      name: 'noGuestBookings',
      desc: '',
      args: [],
    );
  }

  /// `Booking details`
  String get bookingDetailsTitle {
    return Intl.message(
      'Booking details',
      name: 'bookingDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Booking financial summary`
  String get financialSnapshotTitle {
    return Intl.message(
      'Booking financial summary',
      name: 'financialSnapshotTitle',
      desc: '',
      args: [],
    );
  }

  /// `You are not authorized to view this booking.`
  String get bookingUnauthorized {
    return Intl.message(
      'You are not authorized to view this booking.',
      name: 'bookingUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `This booking could not be found.`
  String get bookingNotFound {
    return Intl.message(
      'This booking could not be found.',
      name: 'bookingNotFound',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't complete this booking request. Please try again.`
  String get bookingGenericError {
    return Intl.message(
      'We couldn\'t complete this booking request. Please try again.',
      name: 'bookingGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect. Check your connection and try again.`
  String get bookingNetworkError {
    return Intl.message(
      'Could not connect. Check your connection and try again.',
      name: 'bookingNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Identity verification is required before booking.`
  String get identityNotVerifiedForBooking {
    return Intl.message(
      'Identity verification is required before booking.',
      name: 'identityNotVerifiedForBooking',
      desc: '',
      args: [],
    );
  }

  /// `These dates are no longer available. Choose another range.`
  String get bookingDatesUnavailable {
    return Intl.message(
      'These dates are no longer available. Choose another range.',
      name: 'bookingDatesUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `The payment hold could not be completed. Please try again.`
  String get bookingPaymentFailed {
    return Intl.message(
      'The payment hold could not be completed. Please try again.',
      name: 'bookingPaymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `The booking details were rejected. Review the dates and try again.`
  String get bookingValidationFailed {
    return Intl.message(
      'The booking details were rejected. Review the dates and try again.',
      name: 'bookingValidationFailed',
      desc: '',
      args: [],
    );
  }

  /// `This booking request is no longer available to decide.`
  String get bookingStateNoLongerValid {
    return Intl.message(
      'This booking request is no longer available to decide.',
      name: 'bookingStateNoLongerValid',
      desc: '',
      args: [],
    );
  }

  /// `Booking requests`
  String get hostBookingsTitle {
    return Intl.message(
      'Booking requests',
      name: 'hostBookingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Host booking requests are only available to Hosts.`
  String get hostBookingsUnauthorized {
    return Intl.message(
      'Host booking requests are only available to Hosts.',
      name: 'hostBookingsUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `There are no pending booking requests.`
  String get noHostBookings {
    return Intl.message(
      'There are no pending booking requests.',
      name: 'noHostBookings',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guestNameLabel {
    return Intl.message('Guest', name: 'guestNameLabel', desc: '', args: []);
  }

  /// `{hours} hours remaining to respond`
  String bookingHoursRemaining(Object hours) {
    return Intl.message(
      '$hours hours remaining to respond',
      name: 'bookingHoursRemaining',
      desc: '',
      args: [hours],
    );
  }

  /// `Accept booking request?`
  String get acceptBookingTitle {
    return Intl.message(
      'Accept booking request?',
      name: 'acceptBookingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reject booking request?`
  String get rejectBookingTitle {
    return Intl.message(
      'Reject booking request?',
      name: 'rejectBookingTitle',
      desc: '',
      args: [],
    );
  }

  /// `The booking will be confirmed and the payment remains held.`
  String get acceptBookingConfirmation {
    return Intl.message(
      'The booking will be confirmed and the payment remains held.',
      name: 'acceptBookingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `The booking will be rejected and the backend will handle any refund.`
  String get rejectBookingConfirmation {
    return Intl.message(
      'The booking will be rejected and the backend will handle any refund.',
      name: 'rejectBookingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get acceptBooking {
    return Intl.message('Accept', name: 'acceptBooking', desc: '', args: []);
  }

  /// `Reject`
  String get rejectBooking {
    return Intl.message('Reject', name: 'rejectBooking', desc: '', args: []);
  }

  /// `Booking status: {status}. Payment status: {paymentStatus}.`
  String hostDecisionSuccess(Object status, Object paymentStatus) {
    return Intl.message(
      'Booking status: $status. Payment status: $paymentStatus.',
      name: 'hostDecisionSuccess',
      desc: '',
      args: [status, paymentStatus],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message('Monthly', name: 'monthly', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Explore`
  String get explore {
    return Intl.message('Explore', name: 'explore', desc: '', args: []);
  }

  /// `My Home`
  String get myHome {
    return Intl.message('My Home', name: 'myHome', desc: '', args: []);
  }

  /// `Account`
  String get MyAccount {
    return Intl.message('Account', name: 'MyAccount', desc: '', args: []);
  }

  /// `Choose your role`
  String get chooseYourRole {
    return Intl.message(
      'Choose your role',
      name: 'chooseYourRole',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message('Guest', name: 'guest', desc: '', args: []);
  }

  /// `Host`
  String get host {
    return Intl.message('Host', name: 'host', desc: '', args: []);
  }

  /// `Login Success`
  String get loginSuccessfull {
    return Intl.message(
      'Login Success',
      name: 'loginSuccessfull',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Loading your account...`
  String get loadingAccount {
    return Intl.message(
      'Loading your account...',
      name: 'loadingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Egypto`
  String get accountWaiting {
    return Intl.message(
      'Welcome to Egypto',
      name: 'accountWaiting',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to manage your reservations, hosts, and personal profile.`
  String get accountWelcomeText {
    return Intl.message(
      'Sign in to manage your reservations, hosts, and personal profile.',
      name: 'accountWelcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message('Full name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Edit phone number`
  String get editPhoneNumber {
    return Intl.message(
      'Edit phone number',
      name: 'editPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Your phone number`
  String get editPhoneTitle {
    return Intl.message(
      'Your phone number',
      name: 'editPhoneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add a phone number to keep your account details up to date.`
  String get editPhoneDescription {
    return Intl.message(
      'Add a phone number to keep your account details up to date.',
      name: 'editPhoneDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add phone number`
  String get addPhoneNumber {
    return Intl.message(
      'Add phone number',
      name: 'addPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Save phone number`
  String get savePhoneNumber {
    return Intl.message(
      'Save phone number',
      name: 'savePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number.`
  String get phoneRequired {
    return Intl.message(
      'Enter your phone number.',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid Egyptian mobile number.`
  String get invalidEgyptianMobile {
    return Intl.message(
      'Enter a valid Egyptian mobile number.',
      name: 'invalidEgyptianMobile',
      desc: '',
      args: [],
    );
  }

  /// `Enter an Egyptian mobile number, with or without +20.`
  String get egyptMobileHint {
    return Intl.message(
      'Enter an Egyptian mobile number, with or without +20.',
      name: 'egyptMobileHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone number updated successfully.`
  String get phoneUpdateSuccess {
    return Intl.message(
      'Phone number updated successfully.',
      name: 'phoneUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `The phone number was not accepted. Check it and try again.`
  String get phoneUpdateValidationError {
    return Intl.message(
      'The phone number was not accepted. Check it and try again.',
      name: 'phoneUpdateValidationError',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect. Check your connection and try again.`
  String get phoneUpdateNetworkError {
    return Intl.message(
      'Could not connect. Check your connection and try again.',
      name: 'phoneUpdateNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Your session may have expired. Sign in again and retry.`
  String get phoneUpdateAuthError {
    return Intl.message(
      'Your session may have expired. Sign in again and retry.',
      name: 'phoneUpdateAuthError',
      desc: '',
      args: [],
    );
  }

  /// `The service is temporarily unavailable. Try again later.`
  String get phoneUpdateServerError {
    return Intl.message(
      'The service is temporarily unavailable. Try again later.',
      name: 'phoneUpdateServerError',
      desc: '',
      args: [],
    );
  }

  /// `Could not update your phone number. Please try again.`
  String get phoneUpdateGenericError {
    return Intl.message(
      'Could not update your phone number. Please try again.',
      name: 'phoneUpdateGenericError',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load your profile details. Please try again before updating your number.`
  String get phoneProfileUnavailable {
    return Intl.message(
      'We couldn\'t load your profile details. Please try again before updating your number.',
      name: 'phoneProfileUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Account type`
  String get accountType {
    return Intl.message(
      'Account type',
      name: 'accountType',
      desc: '',
      args: [],
    );
  }

  /// `Identity verification`
  String get identityVerification {
    return Intl.message(
      'Identity verification',
      name: 'identityVerification',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get notAvailable {
    return Intl.message(
      'Not available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Unable to log out. Please try again.`
  String get logoutFailed {
    return Intl.message(
      'Unable to log out. Please try again.',
      name: 'logoutFailed',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get personalInfo {
    return Intl.message(
      'Personal information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Verification not submitted`
  String get identityNotSubmitted {
    return Intl.message(
      'Verification not submitted',
      name: 'identityNotSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Under review`
  String get identityPending {
    return Intl.message(
      'Under review',
      name: 'identityPending',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get identityVerified {
    return Intl.message(
      'Verified',
      name: 'identityVerified',
      desc: '',
      args: [],
    );
  }

  /// `Verification rejected`
  String get identityRejected {
    return Intl.message(
      'Verification rejected',
      name: 'identityRejected',
      desc: '',
      args: [],
    );
  }

  /// `Your identity verification was rejected. You can try again by uploading your documents again.`
  String get identityRejectedRetryPrompt {
    return Intl.message(
      'Your identity verification was rejected. You can try again by uploading your documents again.',
      name: 'identityRejectedRetryPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get identityTryAgain {
    return Intl.message(
      'Try Again',
      name: 'identityTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get identityUnknown {
    return Intl.message('Unknown', name: 'identityUnknown', desc: '', args: []);
  }

  /// `Identity verification`
  String get identityFlowTitle {
    return Intl.message(
      'Identity verification',
      name: 'identityFlowTitle',
      desc: '',
      args: [],
    );
  }

  /// `Selfie`
  String get identitySelfie {
    return Intl.message('Selfie', name: 'identitySelfie', desc: '', args: []);
  }

  /// `National ID — front`
  String get identityIdFront {
    return Intl.message(
      'National ID — front',
      name: 'identityIdFront',
      desc: '',
      args: [],
    );
  }

  /// `National ID — back`
  String get identityIdBack {
    return Intl.message(
      'National ID — back',
      name: 'identityIdBack',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get identityReview {
    return Intl.message('Review', name: 'identityReview', desc: '', args: []);
  }

  /// `Take a clear photo of your face in good lighting. Make sure your face is fully visible.`
  String get identitySelfieInstructions {
    return Intl.message(
      'Take a clear photo of your face in good lighting. Make sure your face is fully visible.',
      name: 'identitySelfieInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Capture the front of your national ID. Keep the entire card in frame and the text readable.`
  String get identityIdFrontInstructions {
    return Intl.message(
      'Capture the front of your national ID. Keep the entire card in frame and the text readable.',
      name: 'identityIdFrontInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Capture the back of your national ID. Keep the entire card in frame and the text readable.`
  String get identityIdBackInstructions {
    return Intl.message(
      'Capture the back of your national ID. Keep the entire card in frame and the text readable.',
      name: 'identityIdBackInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Choose image`
  String get identityChooseImage {
    return Intl.message(
      'Choose image',
      name: 'identityChooseImage',
      desc: '',
      args: [],
    );
  }

  /// `Retake or replace`
  String get identityReplaceImage {
    return Intl.message(
      'Retake or replace',
      name: 'identityReplaceImage',
      desc: '',
      args: [],
    );
  }

  /// `Image added`
  String get identityImageReady {
    return Intl.message(
      'Image added',
      name: 'identityImageReady',
      desc: '',
      args: [],
    );
  }

  /// `Your images are uploaded securely only after you review and confirm them.`
  String get identityPrivacyNote {
    return Intl.message(
      'Your images are uploaded securely only after you review and confirm them.',
      name: 'identityPrivacyNote',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get identityCamera {
    return Intl.message(
      'Take a photo',
      name: 'identityCamera',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get identityGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'identityGallery',
      desc: '',
      args: [],
    );
  }

  /// `National ID photo`
  String get identityDocument {
    return Intl.message(
      'National ID photo',
      name: 'identityDocument',
      desc: '',
      args: [],
    );
  }

  /// `Review your photos`
  String get identityReviewTitle {
    return Intl.message(
      'Review your photos',
      name: 'identityReviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Make sure all three images are clear and readable before submitting.`
  String get identityReviewDescription {
    return Intl.message(
      'Make sure all three images are clear and readable before submitting.',
      name: 'identityReviewDescription',
      desc: '',
      args: [],
    );
  }

  /// `I confirm these images belong to me and are ready to submit for identity review.`
  String get identityConfirmation {
    return Intl.message(
      'I confirm these images belong to me and are ready to submit for identity review.',
      name: 'identityConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Uploading…`
  String get identityUploading {
    return Intl.message(
      'Uploading…',
      name: 'identityUploading',
      desc: '',
      args: [],
    );
  }

  /// `Confirm and submit`
  String get identityConfirmSubmit {
    return Intl.message(
      'Confirm and submit',
      name: 'identityConfirmSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Submission received`
  String get identitySubmissionReceived {
    return Intl.message(
      'Submission received',
      name: 'identitySubmissionReceived',
      desc: '',
      args: [],
    );
  }

  /// `Your documents were sent successfully. Submission does not mean your identity has been approved.`
  String get identitySubmissionPending {
    return Intl.message(
      'Your documents were sent successfully. Submission does not mean your identity has been approved.',
      name: 'identitySubmissionPending',
      desc: '',
      args: [],
    );
  }

  /// `A verification submission already exists for your account. Its current status is shown above.`
  String get identityExistingRequest {
    return Intl.message(
      'A verification submission already exists for your account. Its current status is shown above.',
      name: 'identityExistingRequest',
      desc: '',
      args: [],
    );
  }

  /// `This image could not be opened. Please choose it again.`
  String get identityImageUnavailable {
    return Intl.message(
      'This image could not be opened. Please choose it again.',
      name: 'identityImageUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Camera or photo access was denied. Allow access in your device settings and try again.`
  String get identityPermissionDenied {
    return Intl.message(
      'Camera or photo access was denied. Allow access in your device settings and try again.',
      name: 'identityPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect. Your selected images are saved on this screen; please try again.`
  String get identityNetworkError {
    return Intl.message(
      'Could not connect. Your selected images are saved on this screen; please try again.',
      name: 'identityNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Your session may have expired. Sign in again before submitting.`
  String get identityAuthError {
    return Intl.message(
      'Your session may have expired. Sign in again before submitting.',
      name: 'identityAuthError',
      desc: '',
      args: [],
    );
  }

  /// `The server could not accept these images. Check them and try again.`
  String get identityValidationError {
    return Intl.message(
      'The server could not accept these images. Check them and try again.',
      name: 'identityValidationError',
      desc: '',
      args: [],
    );
  }

  /// `The service is temporarily unavailable. Your selected images are still here; try again later.`
  String get identityServerError {
    return Intl.message(
      'The service is temporarily unavailable. Your selected images are still here; try again later.',
      name: 'identityServerError',
      desc: '',
      args: [],
    );
  }

  /// `Unable to submit your identity documents. Please try again.`
  String get identityGenericError {
    return Intl.message(
      'Unable to submit your identity documents. Please try again.',
      name: 'identityGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Continue`
  String get continueLabel {
    return Intl.message('Continue', name: 'continueLabel', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Refresh profile`
  String get refreshProfile {
    return Intl.message(
      'Refresh profile',
      name: 'refreshProfile',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't refresh your profile. Check your connection and try again.`
  String get profileRefreshError {
    return Intl.message(
      'Couldn\'t refresh your profile. Check your connection and try again.',
      name: 'profileRefreshError',
      desc: '',
      args: [],
    );
  }

  /// `My properties`
  String get hostPropertiesTitle {
    return Intl.message(
      'My properties',
      name: 'hostPropertiesTitle',
      desc: '',
      args: [],
    );
  }

  /// `You haven't listed any properties yet.`
  String get noHostProperties {
    return Intl.message(
      'You haven\'t listed any properties yet.',
      name: 'noHostProperties',
      desc: '',
      args: [],
    );
  }

  /// `Load more`
  String get loadMore {
    return Intl.message('Load more', name: 'loadMore', desc: '', args: []);
  }

  /// `EGP`
  String get egp {
    return Intl.message('EGP', name: 'egp', desc: '', args: []);
  }

  /// `night`
  String get night {
    return Intl.message('night', name: 'night', desc: '', args: []);
  }

  /// `Unknown status`
  String get unknownStatus {
    return Intl.message(
      'Unknown status',
      name: 'unknownStatus',
      desc: '',
      args: [],
    );
  }

  /// `Become a Host`
  String get becomeHost {
    return Intl.message(
      'Become a Host',
      name: 'becomeHost',
      desc: '',
      args: [],
    );
  }

  /// `Become a Host?`
  String get becomeHostTitle {
    return Intl.message(
      'Become a Host?',
      name: 'becomeHostTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your account will be activated for hosting.`
  String get becomeHostConfirmation {
    return Intl.message(
      'Your account will be activated for hosting.',
      name: 'becomeHostConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Your account is now a Host account.`
  String get hostActivationSuccess {
    return Intl.message(
      'Your account is now a Host account.',
      name: 'hostActivationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Host activation failed. Please try again.`
  String get hostActivationFailure {
    return Intl.message(
      'Host activation failed. Please try again.',
      name: 'hostActivationFailure',
      desc: '',
      args: [],
    );
  }

  /// `Add property`
  String get addPropertyTitle {
    return Intl.message(
      'Add property',
      name: 'addPropertyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Property title`
  String get propertyTitleLabel {
    return Intl.message(
      'Property title',
      name: 'propertyTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get propertyDescriptionLabel {
    return Intl.message(
      'Description',
      name: 'propertyDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Beds`
  String get bedsLabel {
    return Intl.message('Beds', name: 'bedsLabel', desc: '', args: []);
  }

  /// `Rooms`
  String get roomsLabel {
    return Intl.message('Rooms', name: 'roomsLabel', desc: '', args: []);
  }

  /// `Bathrooms`
  String get bathroomsLabel {
    return Intl.message(
      'Bathrooms',
      name: 'bathroomsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Nightly price`
  String get nightlyPriceLabel {
    return Intl.message(
      'Nightly price',
      name: 'nightlyPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get countryLabel {
    return Intl.message('Country', name: 'countryLabel', desc: '', args: []);
  }

  /// `Governorate`
  String get governorateLabel {
    return Intl.message(
      'Governorate',
      name: 'governorateLabel',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get cityLabel {
    return Intl.message('City', name: 'cityLabel', desc: '', args: []);
  }

  /// `Address`
  String get addressLabel {
    return Intl.message('Address', name: 'addressLabel', desc: '', args: []);
  }

  /// `Latitude`
  String get latitudeLabel {
    return Intl.message('Latitude', name: 'latitudeLabel', desc: '', args: []);
  }

  /// `Longitude`
  String get longitudeLabel {
    return Intl.message(
      'Longitude',
      name: 'longitudeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Amenities`
  String get amenitiesLabel {
    return Intl.message(
      'Amenities',
      name: 'amenitiesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Property images`
  String get propertyImagesLabel {
    return Intl.message(
      'Property images',
      name: 'propertyImagesLabel',
      desc: '',
      args: [],
    );
  }

  /// `images selected`
  String get imageSelectionCount {
    return Intl.message(
      'images selected',
      name: 'imageSelectionCount',
      desc: '',
      args: [],
    );
  }

  /// `minimum 4 images`
  String get minimumImagesRequired {
    return Intl.message(
      'minimum 4 images',
      name: 'minimumImagesRequired',
      desc: '',
      args: [],
    );
  }

  /// `Choose images`
  String get choosePropertyImages {
    return Intl.message(
      'Choose images',
      name: 'choosePropertyImages',
      desc: '',
      args: [],
    );
  }

  /// `Remove image`
  String get removePropertyImage {
    return Intl.message(
      'Remove image',
      name: 'removePropertyImage',
      desc: '',
      args: [],
    );
  }

  /// `Create and submit for review`
  String get submitProperty {
    return Intl.message(
      'Create and submit for review',
      name: 'submitProperty',
      desc: '',
      args: [],
    );
  }

  /// `Creating property…`
  String get propertyCreating {
    return Intl.message(
      'Creating property…',
      name: 'propertyCreating',
      desc: '',
      args: [],
    );
  }

  /// `Uploading images…`
  String get propertyUploading {
    return Intl.message(
      'Uploading images…',
      name: 'propertyUploading',
      desc: '',
      args: [],
    );
  }

  /// `Submitting for review…`
  String get propertySubmitting {
    return Intl.message(
      'Submitting for review…',
      name: 'propertySubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Could not load amenities.`
  String get amenitiesLoadError {
    return Intl.message(
      'Could not load amenities.',
      name: 'amenitiesLoadError',
      desc: '',
      args: [],
    );
  }

  /// `The operation failed. Review the details and retry.`
  String get propertyWorkflowError {
    return Intl.message(
      'The operation failed. Review the details and retry.',
      name: 'propertyWorkflowError',
      desc: '',
      args: [],
    );
  }

  /// `The server did not return a property ID. The property will not be created again automatically.`
  String get propertyCreationIdMissing {
    return Intl.message(
      'The server did not return a property ID. The property will not be created again automatically.',
      name: 'propertyCreationIdMissing',
      desc: '',
      args: [],
    );
  }

  /// `The server did not return the resulting status.`
  String get propertyStatusMissing {
    return Intl.message(
      'The server did not return the resulting status.',
      name: 'propertyStatusMissing',
      desc: '',
      args: [],
    );
  }

  /// `Property submitted with status:`
  String get propertySubmissionSuccess {
    return Intl.message(
      'Property submitted with status:',
      name: 'propertySubmissionSuccess',
      desc: '',
      args: [],
    );
  }

  /// `This field is required.`
  String get fieldRequired {
    return Intl.message(
      'This field is required.',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number greater than zero.`
  String get invalidPositiveNumber {
    return Intl.message(
      'Enter a valid number greater than zero.',
      name: 'invalidPositiveNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid whole-number count.`
  String get invalidCount {
    return Intl.message(
      'Enter a valid whole-number count.',
      name: 'invalidCount',
      desc: '',
      args: [],
    );
  }

  /// `Latitude must be between -90 and 90.`
  String get invalidLatitude {
    return Intl.message(
      'Latitude must be between -90 and 90.',
      name: 'invalidLatitude',
      desc: '',
      args: [],
    );
  }

  /// `Longitude must be between -180 and 180.`
  String get invalidLongitude {
    return Intl.message(
      'Longitude must be between -180 and 180.',
      name: 'invalidLongitude',
      desc: '',
      args: [],
    );
  }

  /// `Only Host accounts can add properties.`
  String get addPropertyUnauthorized {
    return Intl.message(
      'Only Host accounts can add properties.',
      name: 'addPropertyUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Could not load properties. Check your connection and try again.`
  String get propertiesLoadError {
    return Intl.message(
      'Could not load properties. Check your connection and try again.',
      name: 'propertiesLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Identity`
  String get adminIdentityTab {
    return Intl.message(
      'Identity',
      name: 'adminIdentityTab',
      desc: '',
      args: [],
    );
  }

  /// `Pending Properties`
  String get adminPendingPropertiesTab {
    return Intl.message(
      'Pending Properties',
      name: 'adminPendingPropertiesTab',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get adminProfileTab {
    return Intl.message('Profile', name: 'adminProfileTab', desc: '', args: []);
  }

  /// `Administrator`
  String get adminRole {
    return Intl.message('Administrator', name: 'adminRole', desc: '', args: []);
  }

  /// `Pending identity requests`
  String get adminIdentityTitle {
    return Intl.message(
      'Pending identity requests',
      name: 'adminIdentityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pending properties`
  String get adminPropertiesTitle {
    return Intl.message(
      'Pending properties',
      name: 'adminPropertiesTitle',
      desc: '',
      args: [],
    );
  }

  /// `There are no pending identity requests.`
  String get adminNoIdentityRequests {
    return Intl.message(
      'There are no pending identity requests.',
      name: 'adminNoIdentityRequests',
      desc: '',
      args: [],
    );
  }

  /// `There are no pending properties.`
  String get adminNoPendingProperties {
    return Intl.message(
      'There are no pending properties.',
      name: 'adminNoPendingProperties',
      desc: '',
      args: [],
    );
  }

  /// `Could not load review requests. Check your connection and try again.`
  String get adminLoadError {
    return Intl.message(
      'Could not load review requests. Check your connection and try again.',
      name: 'adminLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Could not load these details. Check your connection and try again.`
  String get adminDetailsError {
    return Intl.message(
      'Could not load these details. Check your connection and try again.',
      name: 'adminDetailsError',
      desc: '',
      args: [],
    );
  }

  /// `Review details`
  String get adminReviewDetails {
    return Intl.message(
      'Review details',
      name: 'adminReviewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get adminApprove {
    return Intl.message('Approve', name: 'adminApprove', desc: '', args: []);
  }

  /// `Reject`
  String get adminReject {
    return Intl.message('Reject', name: 'adminReject', desc: '', args: []);
  }

  /// `Approve this request?`
  String get adminApproveConfirmation {
    return Intl.message(
      'Approve this request?',
      name: 'adminApproveConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Reject this request?`
  String get adminRejectConfirmation {
    return Intl.message(
      'Reject this request?',
      name: 'adminRejectConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Request approved.`
  String get adminApproveSuccess {
    return Intl.message(
      'Request approved.',
      name: 'adminApproveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Request rejected.`
  String get adminRejectSuccess {
    return Intl.message(
      'Request rejected.',
      name: 'adminRejectSuccess',
      desc: '',
      args: [],
    );
  }

  /// `The request could not be completed. It remains in the pending queue.`
  String get adminActionError {
    return Intl.message(
      'The request could not be completed. It remains in the pending queue.',
      name: 'adminActionError',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get adminReference {
    return Intl.message(
      'Reference',
      name: 'adminReference',
      desc: '',
      args: [],
    );
  }

  /// `Your account is not authorized to use Admin tools.`
  String get adminUnauthorized {
    return Intl.message(
      'Your account is not authorized to use Admin tools.',
      name: 'adminUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `This document was not provided.`
  String get adminDocumentMissing {
    return Intl.message(
      'This document was not provided.',
      name: 'adminDocumentMissing',
      desc: '',
      args: [],
    );
  }

  /// `Could not load this image. Check your connection and retry.`
  String get adminImageLoadError {
    return Intl.message(
      'Could not load this image. Check your connection and retry.',
      name: 'adminImageLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Submitted at`
  String get adminSubmittedAt {
    return Intl.message(
      'Submitted at',
      name: 'adminSubmittedAt',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get adminPendingPaymentsTab {
    return Intl.message(
      'Payments',
      name: 'adminPendingPaymentsTab',
      desc: '',
      args: [],
    );
  }

  /// `There are no pending payment receipts.`
  String get adminNoPendingPayments {
    return Intl.message(
      'There are no pending payment receipts.',
      name: 'adminNoPendingPayments',
      desc: '',
      args: [],
    );
  }

  /// `Payment review`
  String get adminPaymentReviewTitle {
    return Intl.message(
      'Payment review',
      name: 'adminPaymentReviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Booking reference`
  String get bookingReferenceLabel {
    return Intl.message(
      'Booking reference',
      name: 'bookingReferenceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Pay with InstaPay`
  String get paymentUploadButton {
    return Intl.message(
      'Pay with InstaPay',
      name: 'paymentUploadButton',
      desc: '',
      args: [],
    );
  }

  /// `InstaPay payment`
  String get paymentInstructionsTitle {
    return Intl.message(
      'InstaPay payment',
      name: 'paymentInstructionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transfer the exact booking amount through InstaPay, then upload a clear screenshot of the receipt.`
  String get instapayInstructions {
    return Intl.message(
      'Transfer the exact booking amount through InstaPay, then upload a clear screenshot of the receipt.',
      name: 'instapayInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Official InstaPay account information is not configured in the app yet. Do not transfer funds until it is available.`
  String get instapayConfigurationMissing {
    return Intl.message(
      'Official InstaPay account information is not configured in the app yet. Do not transfer funds until it is available.',
      name: 'instapayConfigurationMissing',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipt`
  String get paymentReceiptLabel {
    return Intl.message(
      'Payment receipt',
      name: 'paymentReceiptLabel',
      desc: '',
      args: [],
    );
  }

  /// `No receipt image was returned for this payment.`
  String get paymentReceiptMissing {
    return Intl.message(
      'No receipt image was returned for this payment.',
      name: 'paymentReceiptMissing',
      desc: '',
      args: [],
    );
  }

  /// `Choose receipt image`
  String get paymentReceiptChoose {
    return Intl.message(
      'Choose receipt image',
      name: 'paymentReceiptChoose',
      desc: '',
      args: [],
    );
  }

  /// `Replace receipt image`
  String get paymentReceiptReplace {
    return Intl.message(
      'Replace receipt image',
      name: 'paymentReceiptReplace',
      desc: '',
      args: [],
    );
  }

  /// `Select an InstaPay screenshot`
  String get paymentReceiptSelectImage {
    return Intl.message(
      'Select an InstaPay screenshot',
      name: 'paymentReceiptSelectImage',
      desc: '',
      args: [],
    );
  }

  /// `Submit receipt`
  String get paymentReceiptSubmit {
    return Intl.message(
      'Submit receipt',
      name: 'paymentReceiptSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Uploading receipt...`
  String get paymentReceiptUploading {
    return Intl.message(
      'Uploading receipt...',
      name: 'paymentReceiptUploading',
      desc: '',
      args: [],
    );
  }

  /// `Receipt submitted successfully. It is waiting for Admin review.`
  String get paymentReceiptSubmitted {
    return Intl.message(
      'Receipt submitted successfully. It is waiting for Admin review.',
      name: 'paymentReceiptSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Could not submit the receipt. Please try again.`
  String get paymentReceiptUploadError {
    return Intl.message(
      'Could not submit the receipt. Please try again.',
      name: 'paymentReceiptUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Select a receipt image first.`
  String get paymentReceiptSelectFirst {
    return Intl.message(
      'Select a receipt image first.',
      name: 'paymentReceiptSelectFirst',
      desc: '',
      args: [],
    );
  }

  /// `Only JPG and PNG receipt images are supported.`
  String get paymentReceiptFormatError {
    return Intl.message(
      'Only JPG and PNG receipt images are supported.',
      name: 'paymentReceiptFormatError',
      desc: '',
      args: [],
    );
  }

  /// `The receipt image must be 10 MB or smaller.`
  String get paymentReceiptSizeError {
    return Intl.message(
      'The receipt image must be 10 MB or smaller.',
      name: 'paymentReceiptSizeError',
      desc: '',
      args: [],
    );
  }

  /// `Could not open the selected image.`
  String get paymentReceiptImageError {
    return Intl.message(
      'Could not open the selected image.',
      name: 'paymentReceiptImageError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
