import 'package:flutter/material.dart';

/// Right-aligned dropdown inside a rounded container with border.
class Dropdown<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuItem<T>> items;
  final Widget? hint;
  final double borderRadius;
  final EdgeInsets padding;
  final BoxBorder? border;
  final double? height;

  const Dropdown({
    Key? key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
    this.border,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        // border: effectiveBorder,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          // Left side: optional hint or label — takes available space
          Align(
            alignment: Alignment.centerLeft,
            child: hint ?? const SizedBox.shrink(),
          ),

          // Right-aligned dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black,
              ),
              value: value,
              items: items,
              onChanged: onChanged,
              isDense: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              hint: hint != null ? Center(child: hint) : null,
            ),
          ),
        ],
      ),
    );
  }
}
