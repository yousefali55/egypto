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
