// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// switch cameras
class ZegoSwitchCameraFacingButton extends StatefulWidget {
  const ZegoSwitchCameraFacingButton({
    Key? key,
    this.afterClicked,
    this.icon,
    this.defaultUseFrontFacingCamera = true,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  final ButtonIcon? icon;

  ///  You can do what you want after clicked.
  final VoidCallback? afterClicked;

  /// whether to use the front-facing camera by default
  final bool defaultUseFrontFacingCamera;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<ZegoSwitchCameraFacingButton> createState() =>
      _ZegoSwitchCameraFacingButtonState();
}

class _ZegoSwitchCameraFacingButtonState
    extends State<ZegoSwitchCameraFacingButton> {
  @override
  void initState() {
    super.initState();

    /// synchronizing the default status
    ZegoUIKit().useFrontFacingCamera(widget.defaultUseFrontFacingCamera);
  }

  @override
  Widget build(BuildContext context) {
    Size containerSize = widget.buttonSize ?? Size(96.r, 96.r);
    Size sizeBoxSize = widget.iconSize ?? Size(56.r, 56.r);

    return ValueListenableBuilder<bool>(
      valueListenable: ZegoUIKit()
          .getUseFrontFacingCameraStateNotifier(ZegoUIKit().getUser().id),
      builder: (context, isFrontFacing, _) {
        return GestureDetector(
          onTap: () {
            ZegoUIKit().useFrontFacingCamera(!isFrontFacing);

            if (widget.afterClicked != null) {
              widget.afterClicked!();
            }
          },
          child: Container(
            width: containerSize.width,
            height: containerSize.height,
            decoration: BoxDecoration(
              color: widget.icon?.backgroundColor ??
                  controlBarButtonCheckedBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(
                  math.min(containerSize.width, containerSize.height) / 2)),
            ),
            child: SizedBox.fromSize(
              size: sizeBoxSize,
              child: widget.icon?.icon ??
                  UIKitImage.asset(StyleIconUrls.iconS1ControlBarFlipCamera),
            ),
          ),
        );
      },
    );
  }
}
