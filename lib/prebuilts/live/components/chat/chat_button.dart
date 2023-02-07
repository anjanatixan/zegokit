// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/zego_uikit.dart';
import '../base_button.dart';
import 'chat_message_input.dart';

class ZegoLiveChatMessageListButton extends StatefulWidget {
  const ZegoLiveChatMessageListButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ZegoLiveChatMessageListButton> createState() =>
      _ZegoLiveChatMessageListButtonState();
}

class _ZegoLiveChatMessageListButtonState
    extends State<ZegoLiveChatMessageListButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoLiveBaseButton(
      onPressed: () {
        Navigator.of(context).push(ZegoLiveMessageInputOverlay());
      },
      icon: ButtonIcon(
        icon: UIKitImage.asset(StyleIconUrls.iconChat),
      ),
    );
  }
}
