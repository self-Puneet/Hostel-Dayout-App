import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';

class DateCard extends StatelessWidget {
  final DateTime? value;
  final String label;
  final String placeholder;
  final bool touched;
  final String? error;
  final VoidCallback onTap;

  const DateCard({
    Key? key,
    required this.value,
    required this.label,
    required this.placeholder,
    required this.touched,
    required this.error,
    required this.onTap,
  }) : super(key: key);

  String get dateStr {
    if (value == null) return placeholder;
    // Short Indian format: DD Mon
    return InputConverter.dateToMonthDay(value!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 4.0),
          child: Text(label, style: textTheme.h7.w500),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                if (!touched && value == null)
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 2),
                  ),
              ],
              // border: Border.all(
              //   color: error != null ? colorScheme.error : greyColor,
              //   width: 1.2,
              // ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: greyColor),
                const SizedBox(width: 10),
                Text(dateStr, style: textTheme.h5),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 3.0),
            child: Text(
              error!,
              style: textTheme.h7.w300.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
