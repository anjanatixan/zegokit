// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// button used to open/close camera
class ZegoToggleCameraButton extends StatefulWidget {
  const ZegoToggleCameraButton({
    Key? key,
    this.normalIcon,
    this.checkedIcon,
    this.afterClicked,
    this.defaultOn = true,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  final ButtonIcon? normalIcon;
  final ButtonIcon? checkedIcon;

  ///  You can do what you want after clicked.
  final ButtonClickBoolCallback? afterClicked;

  /// whether to open camera by default
  final bool defaultOn;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<ZegoToggleCameraButton> createState() => _ZegoToggleCameraButtonState();
}

class _ZegoToggleCameraButtonState extends State<ZegoToggleCameraButton> {
  @override
  void initState() {
    super.initState();

    /// synchronizing the default status
    ZegoUIKit().turnCameraOn(widget.defaultOn);
  }

  @override
  Widget build(BuildContext context) {
    Size containerSize = widget.buttonSize ?? Size(96.r, 96.r);
    Size sizeBoxSize = widget.iconSize ?? Size(56.r, 56.r);

    /// listen local camera state changes
    return ValueListenableBuilder<bool>(
      valueListenable:
          ZegoUIKit().getCameraStateNotifier(ZegoUIKit().getUser().id),
      builder: (context, isCameraOn, _) {
        /// update if camera state changed
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: containerSize.width,
            height: containerSize.height,
            decoration: BoxDecoration(
              color: isCameraOn
                  ? widget.checkedIcon?.backgroundColor ??
                      controlBarButtonCheckedBackgroundColor
                  : widget.normalIcon?.backgroundColor ??
                      controlBarButtonBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(
                  math.min(containerSize.width, containerSize.height) / 2)),
            ),
            child: SizedBox.fromSize(
              size: sizeBoxSize,
              child: isCameraOn
                  ? widget.normalIcon?.icon ??
                      UIKitImage.asset(
                          StyleIconUrls.iconS1ControlBarCameraNormal)
                  : widget.checkedIcon?.icon ??
                      UIKitImage.asset(StyleIconUrls.iconS1ControlBarCameraOff),
            ),
          ),
        );
      },
    );
  }

  void onPressed() {
    /// get current camera state
    var valueNotifier =
        ZegoUIKit().getCameraStateNotifier(ZegoUIKit().getUser().id);

    var targetState = !valueNotifier.value;

    /// reverse current state
    ZegoUIKit().turnCameraOn(targetState);

    if (widget.afterClicked != null) {
      widget.afterClicked!(targetState);
    }
  }
}
