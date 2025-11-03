import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';

class CustomLabelPasswordField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool touched;
  final String? error;
  final TextInputAction action;
  final VoidCallback? onSubmitted;
  final bool obscure;
  final IconData? icon; // Icon for prefix

  const CustomLabelPasswordField({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.focusNode,
    required this.touched,
    this.error,
    this.action = TextInputAction.next,
    this.onSubmitted,
    this.obscure = false,
    this.icon,
  }) : super(key: key);

  @override
  _CustomLabelPasswordFieldState createState() =>
      _CustomLabelPasswordFieldState();
}

class _CustomLabelPasswordFieldState extends State<CustomLabelPasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: textTheme.h6.w500),
        const SizedBox(height: 6),
        TextSelectionTheme(
          data: const TextSelectionThemeData(
            selectionHandleColor: Colors.black,
          ),
          child: TextFormField(
            key: ValueKey(widget.label),
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _obscureText,
            obscuringCharacter: '•',
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: widget.action,
            onFieldSubmitted: (_) => widget.onSubmitted?.call(),
            cursorColor: Colors.black,
            style: textTheme.h5,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              errorText: widget.touched ? widget.error : null,
              prefixIcon: widget.icon != null
                  ? Icon(widget.icon, color: Colors.black)
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 30, // reduce size to limit padding push
                minHeight: 30,
              ),
              suffixIcon: widget.obscure
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: _toggleObscure,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
