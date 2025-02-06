import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton(
      {super.key,
      required this.buttonWidth,
      required this.buttonHeight,
      required this.buttonColor,
      required this.buttonBorderRadius,
      required this.imageScale,
      required this.assetImageLocation,
      required this.onTap});

  final double buttonWidth;
  final double buttonHeight;
  final Color buttonColor;
  final double buttonBorderRadius;
  final double imageScale;
  final String assetImageLocation;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
      color: buttonColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        onTap: onTap,
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            image: DecorationImage(
              alignment: Alignment.center,
              scale: imageScale,
              image: AssetImage(
                assetImageLocation,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
