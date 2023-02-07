// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/prebuilts/call/invitation/defines.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/pages/styles.dart';
import 'package:zego_uikit/service/zego_uikit.dart';
import 'toolbar/calling_bottom_toolbar.dart';
import 'toolbar/calling_top_toolbar.dart';

typedef AvatarBuilder = Widget Function(
    BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo);

class ZegoInviterCallingView extends StatelessWidget {
  const ZegoInviterCallingView({
    Key? key,
    required this.inviter,
    required this.invitee,
    required this.invitationType,
    this.avatarBuilder,
  }) : super(key: key);

  final ZegoUIKitUser inviter;
  final ZegoUIKitUser invitee;
  final ZegoInvitationType invitationType;
  final AvatarBuilder? avatarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundView(),
        surface(context),
      ],
    );
  }

  Widget backgroundView() {
    if (ZegoInvitationType.videoCall == invitationType) {
      return ZegoAudioVideoView(user: inviter);
    }

    return backgroundImage();
  }

  Widget surface(BuildContext context) {
    var isVideo = ZegoInvitationType.videoCall == invitationType;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isVideo ? const ZegoInviterCallingVideoTopToolBar() : Container(),
        isVideo ? SizedBox(height: 140.h) : SizedBox(height: 120.h),
        SizedBox(
          width: 60.w,
          height: 60.h,
          child:
              avatarBuilder?.call(context, Size(100.w, 100.h), invitee, {}) ??
                  circleAvatar(invitee.name),
        ),
        SizedBox(height: 20.h),
        centralName(invitee.name),
        SizedBox(height: 10.h),
        callingText(),
        // const Expanded(child: SizedBox()),
        ZegoInviterCallingBottomToolBar(callee: invitee),
        SizedBox(height: 30.h),
      ],
    );
  }
}

class ZegoCallingInviteeView extends StatelessWidget {
  const ZegoCallingInviteeView({
    required this.inviter,
    required this.invitee,
    required this.invitationType,
    this.avatarBuilder,
    Key? key,
  }) : super(key: key);

  final ZegoUIKitUser inviter;
  final ZegoUIKitUser invitee;
  final ZegoInvitationType invitationType;
  final AvatarBuilder? avatarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage(),
        surface(context),
      ],
    );
  }

  Widget surface(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 180.h),
        SizedBox(
          width: 60.w,
          height: 60.h,
          child:
              avatarBuilder?.call(context, Size(100.w, 100.h), inviter, {}) ??
                  circleAvatar(inviter.name),
        ),
        SizedBox(height: 20.h),
        centralName(inviter.name),
        SizedBox(height: 47.h),
        callingText(),
        const Expanded(child: SizedBox()),
        ZegoInviteeCallingBottomToolBar(
          inviter: inviter,
          invitee: invitee,
          invitationType: invitationType,
        ),
        SizedBox(height: 50.h),
      ],
    );
  }
}

Widget backgroundImage() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: UIKitImage.asset(InvitationStyleIconUrls.inviteBackground).image,
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}

Widget centralName(String name) {
  return SizedBox(
    height: 30.h,
    child: Text(
      name,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22.0.sp,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget callingText() {
  return Text(
    "Calling…",
    style: TextStyle(
      color: Colors.white,
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ),
  );
}

Widget circleAvatar(String name) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xffDBDDE3),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        name.characters.first,
        style: TextStyle(
          fontSize: 15.sp,
          color: const Color(0xff222222),
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
