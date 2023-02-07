// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

typedef AudioVideoViewAvatarBuilder = Widget Function(
    BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo);

class ZegoAudioVideoBackground extends StatelessWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final bool showAvatar;
  final bool showSoundLevel;
  final AudioVideoViewAvatarBuilder? avatarBuilder;

  const ZegoAudioVideoBackground({
    Key? key,
    required this.size,
    this.user,
    this.showAvatar = true,
    this.showSoundLevel = true,
    this.avatarBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showAvatar || user == null) {
      return Container(color: Colors.transparent);
    }

    var screenSize = MediaQuery.of(context).size;
    var isSmallView = (screenSize.width - size.width).abs() > 1;

    var centralAvatar = avatarBuilder?.call(
            context,
            Size(
              isSmallView ? 110.w : 180.w,
              isSmallView ? 110.w : 180.w,
            ),
            user,
            {}) ??
        const SizedBox();
    // circleName(context, size, user);

    return const Center(
      child: SizedBox(
          // width: isSmallView ? 50.w : 180.w,
          // height: isSmallView ? 50.w : 180.w,
          // child: showSoundLevel
          // ? ZegoRippleAvatar(
          //     minRadius: math.min(size.width, size.height) / 6,
          //     radiusIncrement: isSmallView ? 0.12 : 0.06,
          //     soundLevelStream:
          //         ZegoUIKit().createSoundLevelStream(user?.id ?? ""),
          //     child: centralAvatar,
          //   )
          // : centralAvatar,
          ),
    );
  }

  Widget circleName(BuildContext context, Size size, ZegoUIKitUser? user) {
    var screenSize = MediaQuery.of(context).size;
    var isSmallView = (screenSize.width - size.width).abs() > 1;

    var userName = user?.name ?? "";
    return Container(
      decoration:
          const BoxDecoration(color: Color(0xffDBDDE3), shape: BoxShape.circle),
      child: Center(
        child: Text(
          userName.isNotEmpty ? userName.characters.first : "",
          style: TextStyle(
            fontSize: isSmallView ? 15.0.w : 68.0.w,
            color: const Color(0xff222222),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
