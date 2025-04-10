import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';

class LoadingIndicatorOverlay extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color? color;
  final Widget child;

  const LoadingIndicatorOverlay({
    super.key,
    required this.inAsyncCall,
    this.opacity = 0.5,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        child,
        if (inAsyncCall)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: inAsyncCall,
              child: Opacity(
                opacity: opacity,
                child: ModalBarrier(
                  dismissible: false,
                  color: color ?? (isDarkMode ? Colors.black : Colors.white),
                ),
              ),
            ),
          ),
        if (inAsyncCall)
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ColorsManager.getPrimaryColor(context),
              ),
            ),
          ),
      ],
    );
  }
}
