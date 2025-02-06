import 'package:flutter/material.dart';

class ButtonFilled extends StatelessWidget {
  const ButtonFilled({
    super.key,
    required this.child,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.buttonBackgroundColor,
    required this.buttonBorderRadius,
    required this.onTap,
  });

  final double buttonWidth;
  final double buttonHeight;
  final Color buttonBackgroundColor;
  final double buttonBorderRadius;
  final Widget child;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: buttonBackgroundColor,
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          child: Center(
            child: child
          ),
        ),
      ),
    );
  }
}
