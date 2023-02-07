// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/pages/styles.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

class ZegoCallingTopToolBarButton extends StatelessWidget {
  final String iconURL;
  final VoidCallback onTap;

  const ZegoCallingTopToolBarButton(
      {required this.iconURL, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44.w,
        child: UIKitImage.asset(iconURL),
      ),
    );
  }
}

class ZegoInviterCallingVideoTopToolBar extends StatelessWidget {
  const ZegoInviterCallingVideoTopToolBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        //test
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
        ),
        padding: EdgeInsets.only(left: 36.r, right: 36.r),
        height: 88.h,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Expanded(child: SizedBox()),
            ValueListenableBuilder<bool>(
              valueListenable: ZegoUIKit().getUseFrontFacingCameraStateNotifier(
                  ZegoUIKit().getUser().id),
              builder: (context, isFrontFacing, _) {
                return ZegoCallingTopToolBarButton(
                  iconURL: InvitationStyleIconUrls.toolbarTopSwitchCamera,
                  onTap: () {
                    ZegoUIKit().useFrontFacingCamera(!isFrontFacing);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
