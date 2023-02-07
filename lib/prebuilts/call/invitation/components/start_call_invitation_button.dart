// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/prebuilts/call/invitation/defines.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/pages/styles.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/defines.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/page_service.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

class ZegoStartCallCallInvitation extends StatefulWidget {
  final ButtonIcon? icon;
  final String? text;
  final Size? iconSize;
  final Size? buttonSize;

  final List<ZegoUIKitUser> invitees;
  final bool isVideoCall;
  final int timeoutSeconds;

  ///  You can do what you want after clicked.
  final void Function(bool)? onPressed;

  const ZegoStartCallCallInvitation({
    Key? key,
    required this.isVideoCall,
    required this.invitees,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.text,
    this.timeoutSeconds = 60,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoStartCallCallInvitation> createState() =>
      _ZegoStartCallCallInvitationState();
}

class _ZegoStartCallCallInvitationState
    extends State<ZegoStartCallCallInvitation> {
  String? callID;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callID = 'call_${ZegoUIKit().getUser().id}';

    return ZegoStartInvitationButton(
      invitationType: ZegoInvitationTypeExtension(widget.isVideoCall
              ? ZegoInvitationType.videoCall
              : ZegoInvitationType.voiceCall)
          .value,
      invitees: widget.invitees.map((user) {
        return user.id;
      }).toList(),
      data: InvitationInternalData(callID!, widget.invitees).toJson(),
      icon: ButtonIcon(
        icon: widget.isVideoCall
            ? UIKitImage.asset(InvitationStyleIconUrls.inviteVideo)
            : UIKitImage.asset(InvitationStyleIconUrls.inviteVoice),
      ),
      iconSize: widget.iconSize,
      buttonSize: widget.buttonSize,
      text: widget.text,
      timeoutSeconds: widget.timeoutSeconds,
      onPressed: onPressed,
    );
  }

  void onPressed(bool result) {
    ZegoInvitationPageService.instance.onLocalSendInvitation(
      result,
      callID!,
      widget.invitees,
      widget.isVideoCall
          ? ZegoInvitationType.videoCall
          : ZegoInvitationType.voiceCall,
    );

    if (widget.onPressed != null) {
      widget.onPressed!(result);
    }
  }
}
