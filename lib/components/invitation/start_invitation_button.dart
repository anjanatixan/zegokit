// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

class ZegoStartInvitationButton extends StatefulWidget {
  final int invitationType;
  final List<String> invitees;
  final String data;
  final int timeoutSeconds;

  final String? text;
  final ButtonIcon? icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? iconTextSpacing;

  ///  You can do what you want after clicked.
  final void Function(bool)? onPressed;

  const ZegoStartInvitationButton({
    Key? key,
    required this.invitationType,
    required this.invitees,
    required this.data,
    this.timeoutSeconds = 60,
    this.text,
    this.icon,
    this.iconSize,
    this.iconTextSpacing,
    this.buttonSize,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoStartInvitationButton> createState() =>
      _ZegoStartInvitationButtonState();
}

class _ZegoStartInvitationButtonState extends State<ZegoStartInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: onPressed,
      text: widget.text,
      icon: widget.icon,
      iconTextSpacing: widget.iconTextSpacing,
      iconSize: widget.iconSize,
      buttonSize: widget.buttonSize,
    );
  }

  void onPressed() async {
    var result = await ZegoUIKit().sendInvitation(
      ZegoUIKit().getUser().name,
      widget.invitees,
      widget.timeoutSeconds,
      widget.invitationType,
      widget.data,
    );

    if (widget.onPressed != null) {
      widget.onPressed!(result);
    }
  }
}
