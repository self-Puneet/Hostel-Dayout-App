import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (value != null)
        Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                if (!touched && value == null)
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2,
                    spreadRadius: 0.5,
                    offset: Offset(0, 2),
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
                Icon(Icons.calendar_month_rounded, color: Colors.grey[600]),
                SizedBox(width: 10),
                Text(dateStr, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: EdgeInsets.only(top: 4.0, left: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(error!, style: TextStyle(fontSize: 13, color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }
}
