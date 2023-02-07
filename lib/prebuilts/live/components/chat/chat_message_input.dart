// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/zego_uikit.dart';
import '../components.dart';

class ZegoLiveMessageInputOverlay extends ModalRoute<String> {
  ZegoLiveMessageInputOverlay() : super();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => const Color(0x01000000);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const ZegoLiveChatMessageInput();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}

class ZegoLiveChatMessageInput extends StatefulWidget {
  const ZegoLiveChatMessageInput({
    Key? key,
  }) : super(key: key);

  @override
  State<ZegoLiveChatMessageInput> createState() =>
      _ZegoLiveChatMessageInputState();
}

class _ZegoLiveChatMessageInputState extends State<ZegoLiveChatMessageInput> {
  final TextEditingController _controller = TextEditingController();
  ValueNotifier<bool> isEmptyNotifier = ValueNotifier(true);

  void send() {
    String message = _controller.text;
    ZegoUIKit().sendBarrageMessage(message);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 90.r,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: zegoLiveChatMessageSendBgColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: null,
                      autofocus: true,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(400)
                      ],
                      controller: _controller,
                      onChanged: (String inputMessage) {
                        bool valueIsEmpty = inputMessage.isEmpty;
                        if (valueIsEmpty != isEmptyNotifier.value) {
                          isEmptyNotifier.value = valueIsEmpty;
                        }
                      },
                      textInputAction: TextInputAction.send,
                      onSubmitted: (message) => send(),
                      cursorColor: zegoLiveChatMessageSendcursorColor,
                      cursorHeight: 30.r,
                      cursorWidth: 3.r,
                      style: zegoLiveChatMessageSendInputStyle,
                      onTap: () {},
                      decoration: InputDecoration(
                        hintText: 'Say something...',
                        hintStyle: zegoLiveChatMessageSendHintStyle,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(30.r, 25.r, 20.r, 25.r),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // send button
                  ValueListenableBuilder<bool>(
                    valueListenable: isEmptyNotifier,
                    builder: (context, bool isEmpty, Widget? child) {
                      return ZegoLiveBaseButton(
                        onPressed: () {
                          if (!isEmpty) send();
                        },
                        icon: ButtonIcon(
                          icon: isEmpty
                              ? UIKitImage.asset(StyleIconUrls.iconSendDisable)
                              : UIKitImage.asset(StyleIconUrls.iconSend),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 20.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
