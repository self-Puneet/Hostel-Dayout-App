import 'dart:async';
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
  final IconData? icon;

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
  State<CustomLabelPasswordField> createState() =>
      _CustomLabelPasswordFieldState();
}

class _CustomLabelPasswordFieldState extends State<CustomLabelPasswordField> {
  late bool _obscureText;

  // Overlay for transient error bubble
  final GlobalKey _exclaimKey = GlobalKey();
  OverlayEntry? _errorEntry;
  Timer? _hideTimer;
  bool _prevHasVisibleError = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  void didUpdateWidget(covariant CustomLabelPasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasVisibleError =
        widget.touched && (widget.error != null) && widget.error!.isNotEmpty;
    if (hasVisibleError && !_prevHasVisibleError) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showErrorBubble());
    } else if (!hasVisibleError && _prevHasVisibleError) {
      _hideErrorBubble();
    }
    _prevHasVisibleError = hasVisibleError;
  }

  void _toggleObscure() => setState(() => _obscureText = !_obscureText);

  void _showErrorBubble() {
    if (!mounted) return;
    _hideErrorBubble();

    final overlay = Overlay.of(context);
    // if (overlay == null) return;
    final exCtx = _exclaimKey.currentContext;
    if (exCtx == null) return;

    final exBox = exCtx.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (exBox == null || overlayBox == null) return;

    final mq = MediaQuery.of(context);
    final safeLeft = 8.0,
        safeRight = 8.0,
        safeTop = mq.padding.top + 8.0,
        safeBottom = mq.padding.bottom + 8.0;

    final anchor = exBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final anchorRect = Rect.fromLTWH(
      anchor.dx,
      anchor.dy,
      exBox.size.width,
      exBox.size.height,
    );

    // Measure bubble
    const maxBubbleWidth = 260.0;
    final bubblePadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    );
    final style = Theme.of(context).textTheme.h7.copyWith(color: Colors.white);
    final tp = TextPainter(
      text: TextSpan(text: widget.error ?? '', style: style),
      textDirection: TextDirection.ltr,
      maxLines: 3,
    )..layout(maxWidth: maxBubbleWidth);
    final bubbleWidth = (tp.size.width + bubblePadding.horizontal).clamp(
      0.0,
      maxBubbleWidth,
    );
    final bubbleHeight = tp.size.height + bubblePadding.vertical;

    final screenW = mq.size.width;
    final screenH = mq.size.height;

    // Prefer above; flip below if not enough room
    final preferAbove = anchorRect.top - 8 - bubbleHeight > safeTop;
    double top = preferAbove
        ? anchorRect.top - bubbleHeight - 8
        : anchorRect.bottom + 8;
    // Clamp vertically
    top = top.clamp(safeTop, screenH - safeBottom - bubbleHeight);

    // Align bubble’s right edge to the icon’s right edge, then clamp horizontally
    double left = anchorRect.right - bubbleWidth;
    left = left.clamp(safeLeft, screenW - safeRight - bubbleWidth);

    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: left,
        top: top,
        child: Material(
          type: MaterialType.transparency,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.85 * 225).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxBubbleWidth),
              child: Padding(
                padding: bubblePadding,
                child: Text(
                  widget.error ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: style,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    _errorEntry = entry;

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), _hideErrorBubble);
  }

  void _hideErrorBubble() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _errorEntry?.remove();
    _errorEntry = null;
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _errorEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // final hasVisibleError =
    //     widget.touched && (widget.error != null) && widget.error!.isNotEmpty;

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

              // No built-in error row at all
              errorText: null,
              helperText: null,
              errorStyle: const TextStyle(height: 0),

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

              prefixIcon: widget.icon != null
                  ? Icon(widget.icon, color: Colors.black)
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 30,
              ),

              // Trailing area: fixed width, right-aligned; exclamation at far right
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.touched && (widget.error?.isNotEmpty ?? false))
                    InkWell(
                      key: _exclaimKey, // anchor for the overlay
                      onTap: _showErrorBubble,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4, top: 2, bottom: 2),
                        child: Icon(
                          Icons.error_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  if (widget.touched && (widget.error?.isNotEmpty ?? false))
                    const SizedBox(width: 6), // explicit, minimal spacing
                  if (widget.obscure)
                    InkWell(
                      onTap: _toggleObscure,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          top: 2,
                          bottom: 2,
                        ),
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
              // isDense: true,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),

              // isCollapsed: true,
            ),
          ),
        ),

        // Removed: no reserved error line below the field
      ],
    );
  }
}
