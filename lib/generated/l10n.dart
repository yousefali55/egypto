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

  /// `Unknown`
  String get identityUnknown {
    return Intl.message('Unknown', name: 'identityUnknown', desc: '', args: []);
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
