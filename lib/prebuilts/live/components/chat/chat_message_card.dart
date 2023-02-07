// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/zego_uikit.dart';

class ZegoLiveChatMessageListMessageCard extends StatelessWidget {
  const ZegoLiveChatMessageListMessageCard({
    Key? key,
    required this.user,
    required this.message,
    this.prefix,
  }) : super(key: key);

  final String? prefix;
  final ZegoUIKitUser user;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: zegoLiveMessageBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(26.r)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.r, 10.r, 20.r, 10.r),
            child: RichText(
              // maxLines: 5,
              // overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  if (prefix != null) prefixWidget(),
                  TextSpan(
                    text: user.name,
                    style: TextStyle(
                      fontSize: 26.r,
                      color: zegoLiveMessageNameColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  WidgetSpan(child: SizedBox(width: 10.r)),
                  TextSpan(
                    text: message,
                    style: TextStyle(
                      fontSize: 26.r,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextSpan prefixWidget() {
    return TextSpan(children: [
      WidgetSpan(
        child: Transform.translate(
          offset: Offset(0, 0.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 34.r + prefix!.length * 12.r,
              minWidth: 34.r,
              minHeight: 36.r,
              maxHeight: 36.r,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: zegoLiveMessageHostColor,
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.r, 4.r, 12.r, 4.r),
                child: Center(
                  child: Text(
                    prefix!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      WidgetSpan(child: SizedBox(width: 10.r)),
    ]);
  }
}
