// Dart imports:

// Flutter imports:
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';

import 'package:zego_uikit/service/zego_uikit.dart';

class ZegoAudioVideoForeground extends StatelessWidget {
  final Size size;
  final ZegoUIKitUser? user;

  final bool showMicrophoneStateOnView;
  final bool showCameraStateOnView;
  final bool showUserNameOnView;

  const ZegoAudioVideoForeground({
    Key? key,
    this.user,
    required this.size,
    this.showMicrophoneStateOnView = true,
    this.showCameraStateOnView = true,
    this.showUserNameOnView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container(color: Colors.transparent);
    }

    return Container(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     // userName(context),
              //     // microphoneStateIcon(),
              //     // cameraStateIcon(),
              //   ],
              // ),
            ),
          )
        ],
      ),
    );
  }

  Widget userName(BuildContext context) {
    return showUserNameOnView
        ? Text(
            user?.name ?? "",
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xffffffff),
              decoration: TextDecoration.none,
            ),
          )
        : const SizedBox();
  }

  Widget microphoneStateIcon() {
    var isLocalUser = user?.id == ZegoUIKit().getUser().id;
    log("microphonestate" + isLocalUser.toString());

    if (isLocalUser) {
      return const SizedBox();
    }

    if (!showMicrophoneStateOnView) {
      return const SizedBox();
    }

    return ZegoMicrophoneStateIcon(targetUser: user);
  }

  Widget cameraStateIcon() {
    var isLocalUser = user?.id == ZegoUIKit().getUser().id;
    if (isLocalUser) {
      return const SizedBox();
    }

    if (!showCameraStateOnView) {
      return const SizedBox();
    }

    return ZegoCameraStateIcon(targetUser: user);
  }
}
