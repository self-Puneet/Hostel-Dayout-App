// presentation/widgets/reason_card.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';

class ReasonCard extends StatefulWidget {
  final String value;
  final String label;
  final String placeholder;
  final bool touched;
  final String? error;
  final ValueChanged<String> onChanged;
  final int maxLength;

  const ReasonCard({
    Key? key,
    required this.value,
    required this.label,
    required this.placeholder,
    required this.touched,
    required this.error,
    required this.onChanged,
    this.maxLength = 300,
  }) : super(key: key);

  @override
  State<ReasonCard> createState() => _ReasonCardState();
}

class _ReasonCardState extends State<ReasonCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Persist controller; initialize with incoming value.
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant ReasonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep controller in sync when external value changes.
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final value = widget.value;
    final label = widget.label;
    final touched = widget.touched;
    final error = widget.error;
    final maxLength = widget.maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 4),
          child: Text(label, style: textTheme.h5.w500),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              if (!touched && value == "")
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: TextField(
            controller: _controller,
            maxLines: 4,
            maxLength: maxLength,
            style: textTheme.h4.copyWith(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: "Write a brief reason for the request",
              hintStyle: textTheme.h5.copyWith(color: greyColor),
              counterText: "",
              counter: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 4),
                  child: Text(
                    "${value.length}/$maxLength",
                    style: textTheme.h6.copyWith(color: greyColor),
                  ),
                ),
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
        const SizedBox(height: 6),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Text(error, style: textTheme.h6.copyWith(color: Colors.red)),
          ),
      ],
    );
  }
}
