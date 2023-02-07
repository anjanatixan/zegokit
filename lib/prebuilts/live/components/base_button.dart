// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import '../live_defines.dart';

class ZegoLiveBaseButton extends StatelessWidget {
  final ButtonIcon? icon;

  ///  You can do what you want after clicked.
  final VoidCallback? onPressed;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  const ZegoLiveBaseButton({
    Key? key,
    this.onPressed,
    this.icon,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size containerSize = buttonSize ?? zegoLiveButtonSize;
    Size sizeBoxSize = iconSize ?? zegoLiveButtonIconSize;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: icon?.backgroundColor ?? zegoLiveButtonBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(
              math.min(containerSize.width, containerSize.height) / 2)),
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: icon?.icon ??
              UIKitImage.asset(StyleIconUrls.iconS2ControlBarMore),
        ),
      ),
    );
  }
}
