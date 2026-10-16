import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleDropdown extends StatefulWidget {
  const RoleDropdown({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        hint: Text(
          S.of(context).chooseYourRole,
          style: GoogleFonts.cairo(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.colorScheme.primary,
        ),
        style: GoogleFonts.cairo(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 2, color: theme.colorScheme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 16.0,
          ),
        ),
        items: [
          DropdownMenuItem(value: 'Guest', child: Text(S.of(context).guest)),
          DropdownMenuItem(value: 'Host', child: Text(S.of(context).host)),
        ],
        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });

          widget.onChanged(value);
        },
      ),
    );
  }
}
