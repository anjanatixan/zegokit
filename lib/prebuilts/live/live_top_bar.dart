// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/prebuilts/live/components/components.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:

class ZegoUIKitPrebuiltLiveTopBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveConfig config;

  const ZegoUIKitPrebuiltLiveTopBar({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<ZegoUIKitPrebuiltLiveTopBar> createState() =>
      _ZegoUIKitPrebuiltLiveTopBarState();
}

class _ZegoUIKitPrebuiltLiveTopBarState
    extends State<ZegoUIKitPrebuiltLiveTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      height: 80.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          avatar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              users(),
              SizedBox(width: 33.r),
              closeButton(),
              SizedBox(width: 34.r),
            ],
          )
        ],
      ),
    );
  }

  Widget closeButton() {
    return ZegoQuitButton(
      buttonSize: Size(52.w, 52.h),
      iconSize: Size(24.w, 24.h),
      icon: ButtonIcon(
        icon: const Icon(Icons.close, color: Colors.white),
        backgroundColor: zegoLiveButtonBackgroundColor,
      ),
      onQuitConfirming: (context) async {
        return await widget.config.onEndLiveConfirming!(context);
      },
      afterClicked: () {
        if (widget.config.onEndLive != null) {
          widget.config.onEndLive!.call();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget users() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 100.w,
        maxHeight: 20.h,
        minHeight: 20.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: zegoLiveButtonBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(28.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30.w,
              height: 30.h,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6.w),
            SizedBox(
              height: 56.h,
              child: Center(
                child: StreamBuilder<Object>(
                    stream: ZegoUIKit().createUserListStream(),
                    builder: (context, snapshot) {
                      int count = 1;
                      if (snapshot.hasData) {
                        count += (snapshot.data as List<ZegoUIKitUser>).length;
                      }
                      return Text(
                        count.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget avatar() {
    return Row(
      children: [
        SizedBox(width: 32.w),
        SizedBox(
          height: 68.r,
          child: Container(
            child: Row(
              children: [
                SizedBox(width: 6.r),
                ZegoAvatar(
                  user: ZegoUIKit().getUser(),
                  avatarSize: Size(56.r, 56.r),
                  showSoundLevel: false,
                  avatarBuilder: widget.config.avatarBuilder,
                ),
                SizedBox(width: 12.r),
                Text(
                  ZegoUIKit().getUser().name,
                  style: TextStyle(
                    fontSize: 24.r,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 24.r),
              ],
            ),
            decoration: BoxDecoration(
              color: zegoLiveButtonBackgroundColor,
              borderRadius: BorderRadius.circular(68.r),
            ),
          ),
        ),
      ],
    );
  }
}
