// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/prebuilts/call/components/audio_video/audio_video_view_foreground.dart';
import 'package:zego_uikit/prebuilts/call/invitation/defines.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/pages/styles.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/page_service.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

class ZegoInviterCallingBottomToolBar extends StatelessWidget {
  final ZegoUIKitUser callee;

  const ZegoInviterCallingBottomToolBar({
    Key? key,
    required this.callee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: Center(
        child: ZegoCancelInvitationButton(
          invitee: [callee.id],
          icon: ButtonIcon(
            icon: Image(
              image:
                  UIKitImage.asset(InvitationStyleIconUrls.toolbarBottomCancel)
                      .image,
              fit: BoxFit.fill,
            ),
          ),
          buttonSize: Size(60.w, 60.h),
          iconSize: Size(60.w, 60.h),
          onPressed: () {
            ZegoInvitationPageService.instance.onLocalCancelInvitation();
          },
        ),
      ),
    );
  }
}

class ZegoInviteeCallingBottomToolBar extends StatefulWidget {
  final ZegoInvitationType invitationType;
  final ZegoUIKitUser inviter;
  final ZegoUIKitUser invitee;

  const ZegoInviteeCallingBottomToolBar({
    Key? key,
    required this.inviter,
    required this.invitee,
    required this.invitationType,
  }) : super(key: key);

  @override
  State<ZegoInviteeCallingBottomToolBar> createState() {
    return ZegoInviteeCallingBottomToolBarState();
  }
}

class ZegoInviteeCallingBottomToolBarState
    extends State<ZegoInviteeCallingBottomToolBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZegoRefuseInvitationButton(
              inviterID: widget.inviter.id,
              text: "Decline",
              icon: ButtonIcon(
                icon: Image(
                  image: UIKitImage.asset(
                          InvitationStyleIconUrls.toolbarBottomDecline)
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
              buttonSize: Size(50.w, 50.h),
              iconSize: Size(50.w, 50.h),
              onPressed: () {
                ZegoInvitationPageService.instance.onLocalRefuseInvitation();
              },
            ),
            SizedBox(width: 100.w),
            ZegoAcceptInvitationButton(
              inviterID: widget.inviter.id,
              icon: ButtonIcon(
                icon: Image(
                  image: UIKitImage.asset(
                          imageURLByInvitationType(widget.invitationType))
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
              text: "Accept",
              buttonSize: Size(50.w, 50.h),
              iconSize: Size(50.w, 50.h),
              onPressed: () {
                ZegoInvitationPageService.instance.onLocalAcceptInvitation();
              },
            ),
          ],
        ),
      ),
    );
  }

  String imageURLByInvitationType(ZegoInvitationType invitationType) {
    switch (invitationType) {
      case ZegoInvitationType.voiceCall:
        return InvitationStyleIconUrls.toolbarBottomVoice;
      case ZegoInvitationType.videoCall:
        return InvitationStyleIconUrls.toolbarBottomVideo;
    }
  }
}
