// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// button used to open/close microphone
class ZegoToggleMicrophoneButton extends StatefulWidget {
  const ZegoToggleMicrophoneButton({
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

  /// whether to open microphone by default
  final bool defaultOn;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<ZegoToggleMicrophoneButton> createState() =>
      _ZegoToggleMicrophoneButtonState();
}

class _ZegoToggleMicrophoneButtonState
    extends State<ZegoToggleMicrophoneButton> {
  @override
  void initState() {
    /// synchronizing the default status
    ZegoUIKit().turnMicrophoneOn(widget.defaultOn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size containerSize = widget.buttonSize ?? Size(100.w, 100.h);
    Size sizeBoxSize = widget.iconSize ?? Size(100.w, 100.h);

    /// listen local microphone state changes
    return ValueListenableBuilder<bool>(
      valueListenable:
          ZegoUIKit().getMicrophoneStateNotifier(ZegoUIKit().getUser().id),
      builder: (context, isMicrophoneOn, _) {
        /// update if microphone state changed
        return Container();
        // return GestureDetector(
        //   onTap: onPressed,
        //   child: Container(
        //     width: containerSize.width,
        //     height: containerSize.height,
        //     decoration: BoxDecoration(
        //       color: isMicrophoneOn
        //           ? widget.checkedIcon?.backgroundColor ??
        //               controlBarButtonCheckedBackgroundColor
        //           : widget.normalIcon?.backgroundColor ??
        //               controlBarButtonBackgroundColor,
        //       borderRadius: BorderRadius.all(Radius.circular(
        //           math.min(containerSize.width, containerSize.height) / 2)),
        //     ),
        //     child: SizedBox.fromSize(
        //       size: sizeBoxSize,
        //       child: isMicrophoneOn
        //           ? widget.normalIcon?.icon ??
        //               UIKitImage.asset(
        //                   StyleIconUrls.iconS1ControlBarMicrophoneNormal)
        //           : widget.checkedIcon?.icon ??
        //               UIKitImage.asset(
        //                   StyleIconUrls.iconS1ControlBarMicrophoneOff),
        //     ),
        //   ),
        // );
      },
    );
  }

  void onPressed() {
    /// get current microphone state
    var valueNotifier =
        ZegoUIKit().getMicrophoneStateNotifier(ZegoUIKit().getUser().id);

    var targetState = !valueNotifier.value;

    /// reverse current state
    ZegoUIKit().turnMicrophoneOn(targetState);

    if (widget.afterClicked != null) {
      widget.afterClicked!(targetState);
    }
  }
}
