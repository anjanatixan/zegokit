// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// prefab button on menu bar
enum ZegoLiveMenuBarButtonName {
  toggleMicrophoneButton,
  switchAudioOutputButton,
  toggleCameraButton,
  switchCameraFacingButton,
  hangUpButton,
}

// size
get zegoLiveButtonSize => Size(72.r, 72.r);
get zegoLiveButtonIconSize => Size(40.r, 40.r);
get zegoLiveButtonPadding => SizedBox.fromSize(size: Size.fromRadius(8.r));

// colors
get zegoLiveButtonBackgroundColor => const Color(0xff1e2740).withOpacity(0.4);
get zegoLiveMessageBackgroundColor => const Color(0xff2a2a2a).withOpacity(0.5);
get zegoLiveMessageNameColor => const Color(0xff8be7ff);
get zegoLiveMessageHostColor => const Color(0xff9f76ff);
get zegoLiveChatMessageSendBgColor => const Color(0xff000000).withOpacity(0.25);
get zegoLiveChatMessageSendcursorColor => const Color(0xffA653ff);

// text
get zegoLiveChatMessageSendHintStyle => TextStyle(
      color: const Color(0xFFFFFFFF).withOpacity(0.2),
      fontSize: 28.r,
      fontWeight: FontWeight.w400,
    );

get zegoLiveChatMessageSendInputStyle => TextStyle(
      color: Colors.white,
      fontSize: 28.r,
      fontWeight: FontWeight.w400,
    );
