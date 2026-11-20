import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class PropertyFilterSheet extends StatefulWidget {
  const PropertyFilterSheet({
    super.key,
    required this.initialFilters,
    required this.availableCities,
  });

  final SearchPropertiesFilters initialFilters;
  final List<String> availableCities;

  @override
  State<PropertyFilterSheet> createState() => _PropertyFilterSheetState();
}

class _PropertyFilterSheetState extends State<PropertyFilterSheet> {
  late String _city;
  late int? _guests;
  late DateTime? _checkIn;
  late DateTime? _checkOut;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _city = widget.initialFilters.city ?? '';
    _guests = widget.initialFilters.guests;
    _checkIn = widget.initialFilters.checkIn;
    _checkOut = widget.initialFilters.checkOut;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.filters,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      tooltip: strings.cancel,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _sectionTitle(context, strings.cityLabel),
                SizedBox(height: 10.h),
                _cityField(context),
                SizedBox(height: 22.h),
                _sectionTitle(context, strings.datesLabel),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _dateField(
                        context,
                        label: strings.checkInDate,
                        value: _checkIn,
                        onPressed: _selectCheckIn,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _dateField(
                        context,
                        label: strings.checkOutDate,
                        value: _checkOut,
                        onPressed: _selectCheckOut,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                _sectionTitle(context, strings.guestsLabel),
                SizedBox(height: 10.h),
                _guestSelector(context),
                if (_validationMessage != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    _validationMessage!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(
                          context,
                          const SearchPropertiesFilters(),
                        ),
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: Text(strings.resetFilters),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _apply,
                        icon: const Icon(Icons.tune_rounded),
                        label: Text(strings.applyFilters),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.darkGlow,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String label) => Text(
    label,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _cityField(BuildContext context) {
    final theme = Theme.of(context);
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: _city),
      optionsBuilder: (value) {
        final query = value.text.trim().toLowerCase();
        if (query.isEmpty) return const Iterable<String>.empty();
        return widget.availableCities.where(
          (city) => city.toLowerCase().contains(query),
        );
      },
      onSelected: (city) => setState(() {
        _city = city;
        _validationMessage = null;
      }),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
          TextField(
            controller: controller,
            focusNode: focusNode,
            textDirection: Directionality.of(context),
            onChanged: (value) => setState(() {
              _city = value.trim();
              _validationMessage = null;
            }),
            decoration: InputDecoration(
              hintText: S.of(context).cityFieldHint,
              prefixIcon: const Icon(Icons.location_city_outlined),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(14.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 220.h),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: options
                  .map(
                    (city) => ListTile(
                      title: Text(city),
                      onTap: () => onSelected(city),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateField(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        alignment: AlignmentDirectional.centerStart,
        foregroundColor: theme.colorScheme.onSurface,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 17.sp,
                color: AppColors.darkGlow,
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  value == null
                      ? S.of(context).selectDate
                      : intl.DateFormat.yMMMd(locale).format(value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _guestSelector(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            _guests == null ? strings.anyGuests : strings.guestCount(_guests!),
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
          ),
        ),
        IconButton(
          tooltip: strings.decreaseGuests,
          onPressed: _guests == null
              ? null
              : () => setState(() {
                  _guests = _guests == 1 ? null : _guests! - 1;
                }),
          style: IconButton.styleFrom(
            foregroundColor: AppColors.darkGlow,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          icon: const Icon(Icons.remove_rounded),
        ),
        SizedBox(width: 10.w),
        Text(
          _guests?.toString() ?? strings.anyGuests,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 10.w),
        IconButton(
          tooltip: strings.increaseGuests,
          onPressed: () => setState(() {
            _guests = (_guests ?? 0) + 1;
          }),
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.darkGlow,
          ),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }

  Future<void> _selectCheckIn() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _checkIn ?? _checkOut ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null) return;
    setState(() {
      _checkIn = selected;
      if (_checkOut != null && !_checkOut!.isAfter(selected)) {
        _checkOut = null;
      }
      _validationMessage = null;
    });
  }

  Future<void> _selectCheckOut() async {
    final firstDate = _checkIn == null
        ? DateTime(2000)
        : DateTime(_checkIn!.year, _checkIn!.month, _checkIn!.day + 1);
    final selected = await showDatePicker(
      context: context,
      initialDate: _checkOut != null && !_checkOut!.isBefore(firstDate)
          ? _checkOut!
          : firstDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (selected == null) return;
    setState(() {
      _checkOut = selected;
      _validationMessage = null;
    });
  }

  void _apply() {
    final strings = S.of(context);
    if ((_checkIn == null) != (_checkOut == null)) {
      setState(() => _validationMessage = strings.selectBothDates);
      return;
    }
    if (_checkIn != null && !_checkOut!.isAfter(_checkIn!)) {
      setState(() => _validationMessage = strings.invalidDateRange);
      return;
    }
    Navigator.pop(
      context,
      SearchPropertiesFilters(
        city: _city,
        guests: _guests,
        checkIn: _checkIn,
        checkOut: _checkOut,
      ),
    );
  }
}
