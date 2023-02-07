// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// monitor the microphone status changes,
/// when the status changes, the corresponding icon is automatically switched
class ZegoMicrophoneStateIcon extends StatefulWidget {
  final ZegoUIKitUser? targetUser;

  const ZegoMicrophoneStateIcon({Key? key, this.targetUser}) : super(key: key);

  @override
  State<ZegoMicrophoneStateIcon> createState() =>
      _ZegoMicrophoneStateIconState();
}

class _ZegoMicrophoneStateIconState extends State<ZegoMicrophoneStateIcon> {
  /// subscription of sound level value's stream
  StreamSubscription<double>? soundLevelStreamSubscription;
  String imageUrl = StyleIconUrls.iconVideoViewMicrophoneOff;
  late ValueNotifier<bool> stateNotifier;

  @override
  void initState() {
    super.initState();

    /// listen subscription
    soundLevelStreamSubscription = ZegoUIKit()
        .createSoundLevelStream(widget.targetUser?.id ?? "")
        .listen(onSoundLevelChanged);

    stateNotifier =
        ZegoUIKit().getMicrophoneStateNotifier(widget.targetUser?.id ?? "");
    stateNotifier.addListener(onMicrophoneStateChanged);
  }

  @override
  void dispose() {
    /// cancel subscription
    soundLevelStreamSubscription?.cancel();
    stateNotifier.removeListener(onMicrophoneStateChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIKitImage.asset(imageUrl);
  }

  void onMicrophoneStateChanged() {
    setState(() {
      imageUrl = stateNotifier.value
          ? StyleIconUrls.iconVideoViewMicrophoneOn
          : StyleIconUrls.iconVideoViewMicrophoneOff;
    });
  }

  /// update ripple count when the sound level value is updated.
  void onSoundLevelChanged(double value) {
    // var soundLevelValue = soundLevelConvertToRippleCount(value);

    var targetImageUrl = value > 1
        ? StyleIconUrls.iconVideoViewMicrophoneSpeaking
        : StyleIconUrls.iconVideoViewMicrophoneOn;
    if (!stateNotifier.value) {
      targetImageUrl = StyleIconUrls.iconVideoViewMicrophoneOff;
    }

    if (imageUrl != targetImageUrl) {
      setState(() {
        imageUrl = targetImageUrl;
      });
    }
  }

  /// convert sound level value to ripple count,
  /// the larger sound level, the more ripples.
  int soundLevelConvertToRippleCount(double soundLevel) {
    /// in order to show the wave effect even if the sound wave is small

    /** make (0~100) sound level value to (0,10) ripple count
     * 1~3 => 1
     * 4~6 => 2
     * 7~9 => 3
     * 10~20 => 4
     * 21~30 => 5
     * 31~40 => 6
     * 41~50 => 7
     * 51~65 => 8
     * 66~80 => 9
     * 81~100 => 10
     */
    var currentValue = 0;
    if (soundLevel < 0.01) {
      currentValue = 0;
    } else if (soundLevel < 3) {
      currentValue = 1;
    } else if (soundLevel < 6) {
      currentValue = 2;
    } else if (soundLevel < 9) {
      currentValue = 3;
    } else if (soundLevel < 20) {
      currentValue = 4;
    } else if (soundLevel < 30) {
      currentValue = 5;
    } else if (soundLevel < 40) {
      currentValue = 6;
    } else if (soundLevel < 50) {
      currentValue = 7;
    } else if (soundLevel < 65) {
      currentValue = 8;
    } else if (soundLevel < 80) {
      currentValue = 9;
    } else if (soundLevel < 100) {
      currentValue = 10;
    }

    return currentValue;
  }
}
