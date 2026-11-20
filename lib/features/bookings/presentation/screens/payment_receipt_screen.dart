import 'dart:io';

import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/presentation/cubit/guest_booking_cubit.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PaymentReceiptScreen extends StatefulWidget {
  const PaymentReceiptScreen({
    super.key,
    required this.booking,
  });

  final BookingDetails booking;

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selected;

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2400,
      );
      if (image == null) return;
      final length = await image.length();
      final lowerName = image.name.toLowerCase();
      if (!lowerName.endsWith('.jpg') &&
          !lowerName.endsWith('.jpeg') &&
          !lowerName.endsWith('.png')) {
        if (mounted) _showMessage(S.of(context).paymentReceiptFormatError);
        return;
      }
      if (length > 10 * 1024 * 1024) {
        if (mounted) _showMessage(S.of(context).paymentReceiptSizeError);
        return;
      }
      if (!mounted) return;
      setState(() => _selected = image);
    } catch (_) {
      if (mounted) {
        _showMessage(S.of(context).paymentReceiptImageError);
      }
    }
  }

  Future<void> _submit() async {
    final image = _selected;
    if (image == null) {
      _showMessage(S.of(context).paymentReceiptSelectFirst);
      return;
    }
    final success = await context.read<BookingDetailsCubit>().submitReceipt(
      bookingId: widget.booking.id,
      filePath: image.path,
      fileName: image.name,
    );
    if (!mounted) return;
    _showMessage(
      success
          ? S.of(context).paymentReceiptSubmitted
          : S.of(context).paymentReceiptUploadError,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final booking = widget.booking;
    final amount = booking.financialSnapshot.grossAmount;
    return Scaffold(
      appBar: AppBar(title: Text(strings.paymentInstructionsTitle)),
      body: SafeArea(
        child: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
          builder: (context, state) {
            final uploading = state is BookingDetailsLoaded && state.uploading;
            final progress =
                state is BookingDetailsLoaded ? state.uploadProgress : null;
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.paymentInstructionsTitle,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(strings.instapayInstructions),
                        SizedBox(height: 10.h),
                        if (amount != null)
                          Text(
                            '${strings.grossAmountLabel}: ${amount.toStringAsFixed(2)} ${strings.egp}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGlow,
                            ),
                          ),
                        Text(
                          '${strings.bookingReferenceLabel}: ${booking.id}',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          strings.instapayConfigurationMissing,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: 260.h,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: _selected == null
                        ? Text(strings.paymentReceiptSelectImage)
                        : Image.file(
                            File(_selected!.path),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                SizedBox(height: 12.h),
                OutlinedButton.icon(
                  onPressed: uploading ? null : _pickImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(
                    _selected == null
                        ? strings.paymentReceiptChoose
                        : strings.paymentReceiptReplace,
                  ),
                ),
                if (progress != null && uploading) ...[
                  SizedBox(height: 12.h),
                  LinearProgressIndicator(value: progress),
                ],
                SizedBox(height: 12.h),
                FilledButton.icon(
                  onPressed: uploading ? null : _submit,
                  icon: uploading
                      ? SizedBox.square(
                          dimension: 18.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.upload_rounded),
                  label: Text(
                    uploading
                        ? strings.paymentReceiptUploading
                        : strings.paymentReceiptSubmit,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
