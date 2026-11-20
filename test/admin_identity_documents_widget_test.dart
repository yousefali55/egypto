import 'dart:convert';
import 'dart:typed_data';

import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/features/admin/data/models/admin_identity_details.dart';
import 'package:egypto/features/admin/presentation/widgets/admin_document_image.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses image paths only from the nested documents object', () {
    final details = AdminIdentityDetails.fromJson({
      'selfieViewUrl': '/uploads/root-selfie.jpg',
      'nationalIdFrontViewUrl': '/uploads/root-front.jpg',
      'nationalIdBackViewUrl': '/uploads/root-back.jpg',
      'documents': {
        'selfieViewUrl': '/uploads/selfie.jpg',
        'nationalIdFrontViewUrl': '/uploads/front.jpg',
        'nationalIdBackViewUrl': '/uploads/back.jpg',
      },
    });

    expect(details.documents.selfieViewUrl, '/uploads/selfie.jpg');
    expect(details.documents.nationalIdFrontViewUrl, '/uploads/front.jpg');
    expect(details.documents.nationalIdBackViewUrl, '/uploads/back.jpg');
  });

  test('missing and empty documents are safe', () {
    for (final value in [null, <String, dynamic>{}]) {
      final json = <String, dynamic>{'documents': value};
      final details = AdminIdentityDetails.fromJson(json);

      expect(details.documents.selfieViewUrl, isNull);
      expect(details.documents.nationalIdFrontViewUrl, isNull);
      expect(details.documents.nationalIdBackViewUrl, isNull);
    }

    final details = AdminIdentityDetails.fromJson({
      'documents': {
        'selfieViewUrl': '  ',
        'nationalIdFrontViewUrl': null,
        'nationalIdBackViewUrl': 12,
      },
    });
    expect(details.documents.selfieViewUrl, isNull);
    expect(details.documents.nationalIdFrontViewUrl, isNull);
    expect(details.documents.nationalIdBackViewUrl, isNull);
  });

  test('resolves uploads at the backend root and preserves absolute URLs', () {
    final origin = Uri.parse(ApiConstants.baseUrl).origin;

    expect(
      ApiConstants.resolveUploadUrl(
        '/uploads/91603abb9aac4e2fab9a07111575542f.jpg',
      ),
      '$origin/uploads/91603abb9aac4e2fab9a07111575542f.jpg',
    );
    expect(
      ApiConstants.resolveUploadUrl('uploads/front.jpg'),
      '$origin/uploads/front.jpg',
    );
    expect(
      ApiConstants.resolveUploadUrl('https://cdn.example.test/back.jpg'),
      'https://cdn.example.test/back.jpg',
    );
    expect(ApiConstants.resolveUploadUrl(''), isNull);
    expect(ApiConstants.resolveUploadUrl(null), isNull);
  });

  testWidgets('renders all three localized image sections', (tester) async {
    final details = AdminIdentityDetails.fromJson({
      'userId': '52c7b677-d6ae-42c8-b1b2-674102799b14',
      'firstName': 'Yousef',
      'lastName': 'Ali',
      'email': 'yousef@example.test',
      'status': 'Pending',
      'submittedAt': '2026-10-23T15:42:40.617609Z',
      'documents': {
        'selfieViewUrl': '/uploads/selfie.jpg',
        'nationalIdFrontViewUrl': '/uploads/front.jpg',
        'nationalIdBackViewUrl': '/uploads/back.jpg',
      },
    });
    final requestedPaths = <String>[];

    await tester.pumpWidget(
      _app(details.documents, (path) async {
        requestedPaths.add(path);
        return _imageBytes;
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Selfie'), findsOneWidget);
    expect(find.text('National ID — front'), findsOneWidget);
    expect(find.text('National ID — back'), findsOneWidget);
    expect(requestedPaths, [
      '/uploads/selfie.jpg',
      '/uploads/front.jpg',
      '/uploads/back.jpg',
    ]);
    final images = tester.widgetList<Image>(find.byType(Image)).toList();
    expect(images, hasLength(3));
    expect(images.every((image) => image.fit == BoxFit.contain), isTrue);

    await tester.tap(find.byType(Image).first);
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });

  testWidgets('shows a retryable error when document loading fails', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      _app(const AdminIdentityDocuments(selfieViewUrl: '/uploads/selfie.jpg'), (
        _,
      ) async {
        attempts++;
        if (attempts == 1) throw Exception('HTTP 404');
        return _imageBytes;
      }),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Could not load this image. Check your connection and retry.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('missing documents show a localized fallback instead of images', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const AdminIdentityDocuments(), (_) async => _imageBytes),
    );

    expect(find.text('This document was not provided.'), findsNWidgets(3));
    expect(find.byType(Image), findsNothing);
  });
}

final Uint8List _imageBytes = Uint8List.fromList(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
  ),
);

Widget _app(
  AdminIdentityDocuments documents,
  AdminDocumentImageLoader loadImage,
) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: AdminIdentityDocumentsSection(
        documents: documents,
        loadImage: loadImage,
      ),
    ),
  ),
);
