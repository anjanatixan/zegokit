// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// monitor the camera status changes,
/// when the status changes, the corresponding icon is automatically switched
class ZegoCameraStateIcon extends ZegoServiceValueIcon {
  final ZegoUIKitUser? targetUser;

  ZegoCameraStateIcon({Key? key, required this.targetUser})
      : super(
          key: key,
          notifier: ZegoUIKit().getCameraStateNotifier(targetUser?.id ?? ""),
          normalIcon: UIKitImage.asset(StyleIconUrls.iconVideoViewCameraOff),
          checkedIcon: UIKitImage.asset(StyleIconUrls.iconVideoViewCameraOn),
        );
}
