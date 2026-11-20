import 'package:dio/dio.dart';
import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';
import 'package:egypto/features/host_properties/presentation/cubit/property_creation_cubit.dart';
import 'package:egypto/features/host_properties/screens/add_property_screen.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() async => getIt.reset());

  testWidgets('Guest profile cannot access the property form', (tester) async {
    await tester.pumpWidget(_app(const AddPropertyScreen(profile: _guest)));

    expect(find.text('Only Host accounts can add properties.'), findsOneWidget);
    expect(find.text('Property title'), findsNothing);
  });

  testWidgets('Host form supports Arabic RTL and dark theme', (tester) async {
    await getIt.reset();
    getIt.registerFactory<PropertyCreationCubit>(
      () => PropertyCreationCubit(_AmenitiesRepo()),
    );
    await tester.pumpWidget(
      _app(
        const AddPropertyScreen(profile: _host),
        locale: const Locale('ar'),
        theme: AppTheme.darkTheme,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('عنوان العقار'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('خط العرض'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('خط العرض'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Wi-Fi'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );
  });
}

Widget _app(
  Widget home, {
  Locale locale = const Locale('en'),
  ThemeData? theme,
}) => ScreenUtilInit(
  designSize: const Size(390, 844),
  builder: (context, child) => MaterialApp(
    locale: locale,
    theme: theme ?? AppTheme.lightTheme,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: home,
  ),
);

const _guest = UserProfileModel(
  firstName: 'Guest',
  lastName: 'User',
  email: 'guest@example.test',
);

const _host = UserProfileModel(
  firstName: 'Host',
  lastName: 'User',
  email: 'host@example.test',
  isHost: true,
);

class _AmenitiesRepo extends HostPropertiesRepo {
  _AmenitiesRepo() : super(ApiService(Dio()));

  @override
  Future<List<Amenity>> getAmenities() async => const [
    Amenity(id: 'real-wifi-id', name: 'Wi-Fi'),
  ];

  @override
  Future<HostPropertiesPage> getHostProperties({
    required int pageNumber,
    required int pageSize,
  }) async => const HostPropertiesPage(
    items: [],
    pageNumber: 1,
    totalPages: 1,
    totalCount: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );

  @override
  Future<String> createProperty(CreatePropertyRequest request) async => '';
}
