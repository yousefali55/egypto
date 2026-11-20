import 'dart:typed_data';

import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/features/admin/data/models/admin_identity_details.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';

typedef AdminDocumentImageLoader = Future<Uint8List> Function(String path);

String? resolveAdminDocumentUrl(String? path) =>
    ApiConstants.resolveUploadUrl(path);

class AdminDocumentImage extends StatefulWidget {
  const AdminDocumentImage({
    super.key,
    required this.label,
    required this.path,
    required this.loadImage,
  });

  final String label;
  final String? path;
  final AdminDocumentImageLoader loadImage;

  @override
  State<AdminDocumentImage> createState() => _AdminDocumentImageState();
}

class _AdminDocumentImageState extends State<AdminDocumentImage> {
  Future<Uint8List>? _imageFuture;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  @override
  void didUpdateWidget(covariant AdminDocumentImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) _startLoading();
  }

  void _startLoading() {
    final path = widget.path;
    _imageFuture = path == null || ApiConstants.resolveUploadUrl(path) == null
        ? null
        : Future<Uint8List>.sync(() => widget.loadImage(path));
  }

  void _retry() {
    setState(_startLoading);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    final url = ApiConstants.resolveUploadUrl(widget.path);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
          child: Text(widget.label, style: theme.textTheme.titleSmall),
        ),
        if (url == null)
          _DocumentMessage(message: strings.adminDocumentMissing)
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 280,
              width: double.infinity,
              color: theme.colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: FutureBuilder<Uint8List>(
                future: _imageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return _DocumentMessage(
                      message: strings.adminImageLoadError,
                      retryLabel: strings.retry,
                      onRetry: _retry,
                    );
                  }

                  return GestureDetector(
                    onTap: () =>
                        _showPreview(context, snapshot.data!, widget.label),
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          _DocumentMessage(
                            message: strings.adminImageLoadError,
                            retryLabel: strings.retry,
                            onRetry: _retry,
                          ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  void _showPreview(BuildContext context, Uint8List bytes, String label) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(label),
            leading: IconButton(
              onPressed: () => Navigator.pop(dialogContext),
              tooltip: S.of(dialogContext).back,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => _DocumentMessage(
                  message: S.of(context).adminImageLoadError,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentMessage extends StatelessWidget {
  const _DocumentMessage({
    required this.message,
    this.retryLabel,
    this.onRetry,
  });

  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (retryLabel != null && onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryLabel!),
            ),
          ],
        ],
      ),
    ),
  );
}

class AdminIdentityDocumentsSection extends StatelessWidget {
  const AdminIdentityDocumentsSection({
    super.key,
    required this.documents,
    required this.loadImage,
  });

  final AdminIdentityDocuments documents;
  final AdminDocumentImageLoader loadImage;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = maxWidth >= 900 ? (maxWidth - 24) / 3 : maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: itemWidth,
              child: AdminDocumentImage(
                label: strings.identitySelfie,
                path: documents.selfieViewUrl,
                loadImage: loadImage,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: AdminDocumentImage(
                label: strings.identityIdFront,
                path: documents.nationalIdFrontViewUrl,
                loadImage: loadImage,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: AdminDocumentImage(
                label: strings.identityIdBack,
                path: documents.nationalIdBackViewUrl,
                loadImage: loadImage,
              ),
            ),
          ],
        );
      },
    );
  }
}
