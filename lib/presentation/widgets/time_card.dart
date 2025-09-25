/// Reusable TimeCard widget: tapable, shows selected time or placeholder.
/// Updated to display 12-hour format with AM/PM using MaterialLocalizations.

import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  final TimeOfDay? value;
  final String label;
  final String placeholder;
  final bool touched;
  final String? error;
  final VoidCallback onTap;

  const TimeCard({
    Key? key,
    required this.value,
    required this.label,
    required this.placeholder,
    required this.touched,
    required this.error,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final display = value == null
        ? placeholder
        : localizations.formatTimeOfDay(
            value!,
            alwaysUse24HourFormat: false, // force 12-hour with AM/PM
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (value != null)
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                if (!touched && value == null)
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 2),
                  ),
              ],
              border: Border.all(
                color: error != null ? Colors.red : Colors.grey.shade300,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(display, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  error!,
                  style: const TextStyle(fontSize: 13, color: Colors.red),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
