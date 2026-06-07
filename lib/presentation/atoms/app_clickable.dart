import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for HapticFeedback

class AppClickable extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback? onHold;
  final VoidCallback? onRelease;
  final BorderRadius? borderRadius;
  final bool showSplash;
  final bool disabled;

  const AppClickable({
    super.key,
    required this.child,
    required this.onPressed,
    this.onHold,
    this.onRelease,
    this.borderRadius,
    this.showSplash = true,
    this.disabled = false,
  });

  @override
  State<AppClickable> createState() => _AppClickableState();
}

class _AppClickableState extends State<AppClickable>
    with SingleTickerProviderStateMixin {
  double? _scale;
  late final AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
          lowerBound: 0.0,
          upperBound: 0.05,
        )..addListener(() {
          setState(() {});
        });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    if (widget.disabled) {
      return widget.child;
    }

    return Transform.scale(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        borderRadius: widget.borderRadius,
        child: InkWell(
          hoverColor: widget.showSplash ? null : Colors.transparent,
          highlightColor: widget.showSplash ? null : Colors.transparent,
          splashColor: widget.showSplash ? null : Colors.transparent,
          borderRadius: widget.borderRadius,
          onTapDown: (details) {
            // 1. Haptic on Press Down (Simulates mechanical resistance)
            HapticFeedback.selectionClick();

            widget.onHold?.call();
            _tapDown(details);
          },
          onTapUp: (details) async {
            // 2. Haptic on Release (Simulates spring back)
            HapticFeedback.selectionClick();

            widget.onRelease?.call();
            widget.onPressed();

            // Original logic preserved to ensure animation completes
            _tapDown(null);
            await Future.delayed(const Duration(milliseconds: 100));
            _tapUp(details);
          },
          onTapCancel: _tapUp,
          child: widget.child,
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails? details) {
    if (!mounted) {
      return;
    }

    _controller.duration = const Duration(milliseconds: 200);
    _controller.forward();
  }

  void _tapUp([TapUpDetails? details]) {
    if (!mounted) {
      return;
    }

    _controller.duration = const Duration(milliseconds: 100);
    _controller.reverse();
  }
}
