// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// quit room/channel/group
class ZegoQuitButton extends StatelessWidget {
  final ButtonIcon? icon;

  ///  You can do what you want before clicked.
  ///  Return true, exit;
  ///  Return false, will not exit.
  final Future<bool?> Function(BuildContext context)? onQuitConfirming;

  ///  You can do what you want after clicked.
  final VoidCallback? afterClicked;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  const ZegoQuitButton({
    Key? key,
    this.onQuitConfirming,
    this.afterClicked,
    this.icon,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size containerSize = buttonSize ?? Size(100.w, 100.h);
    Size sizeBoxSize = iconSize ?? Size(100.w, 100.h);
    return GestureDetector(
      onTap: () async {
        ///  if there is a user-defined event before the click,
        ///  wait the synchronize execution result
        bool isConfirm = await onQuitConfirming?.call(context) ?? true;
        if (isConfirm) {
          quit();
        }
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: icon?.backgroundColor ?? Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(
              math.min(containerSize.width, containerSize.height) / 2)),
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child:
              icon?.icon ?? UIKitImage.asset(StyleIconUrls.iconS1ControlBarEnd),
        ),
      ),
    );
  }

  void quit() {
    ZegoUIKit().leaveRoom();

    if (afterClicked != null) {
      afterClicked!();
    }
  }
}
