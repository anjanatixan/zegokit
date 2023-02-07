// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

class ZegoCancelInvitationButton extends StatefulWidget {
  final List<String> invitee;

  final String? text;
  final ButtonIcon? icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? iconTextSpacing;

  ///  You can do what you want after clicked.
  final VoidCallback? onPressed;

  const ZegoCancelInvitationButton({
    Key? key,
    required this.invitee,
    this.text,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.iconTextSpacing,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoCancelInvitationButton> createState() =>
      _ZegoCancelInvitationButtonState();
}

class _ZegoCancelInvitationButtonState
    extends State<ZegoCancelInvitationButton> {
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

  void onPressed() {
    ZegoUIKit().cancelInvitation(widget.invitee, '');

    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
}
