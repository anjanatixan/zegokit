// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'components/chat/chat_button.dart';
import 'live_config.dart';
import 'live_defines.dart';

class ZegoUIKitPrebuiltLiveBottomBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveConfig config;
  final Size buttonSize;

  const ZegoUIKitPrebuiltLiveBottomBar({
    Key? key,
    required this.config,
    required this.buttonSize,
  }) : super(key: key);

  @override
  State<ZegoUIKitPrebuiltLiveBottomBar> createState() =>
      _ZegoUIKitPrebuiltLiveBottomBarState();
}

class _ZegoUIKitPrebuiltLiveBottomBarState
    extends State<ZegoUIKitPrebuiltLiveBottomBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      height: widget.buttonSize.height,
      child: Stack(
        children: [
          const ZegoLiveChatMessageListButton(),
          Container(
            margin: EdgeInsets.only(left: 100.0.r),
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...getDisplayButtons(),
                      zegoLiveButtonPadding,
                      zegoLiveButtonPadding,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDisplayButtons() {
    List<Widget> defaultButtons = [];
    if (widget.config.isHost) {
      defaultButtons = hostButtons();
    }
    if (!widget.config.isHost) {
      defaultButtons = audienceButtons();
    }
    List<Widget> buttonList = [
      ...defaultButtons,
      ...widget.config.menuBarExtendButtons
    ];

    List<Widget> displayButtonList = [];
    if (buttonList.length > widget.config.menuBarButtonsMaxCount) {
      /// the list count exceeds the limit, so divided into two parts,
      /// one part display in the Menu bar, the other part display in the menu with more buttons
      displayButtonList =
          buttonList.sublist(0, widget.config.menuBarButtonsMaxCount - 1);

      buttonList.removeRange(0, widget.config.menuBarButtonsMaxCount - 1);
      displayButtonList.add(
        buttonWrapper(
          child: ZegoMoreButton(menuButtonList: buttonList),
        ),
      );
    } else {
      displayButtonList = buttonList;
    }

    List<Widget> displayButtonsWithSpacing = [];
    for (var button in displayButtonList) {
      displayButtonsWithSpacing.add(button);
      displayButtonsWithSpacing.add(zegoLiveButtonPadding);
    }

    return displayButtonsWithSpacing;
  }

  Widget buttonWrapper({required Widget child}) {
    return SizedBox(
      width: widget.buttonSize.width,
      height: widget.buttonSize.height,
      child: child,
    );
  }

  List<Widget> hostButtons() {
    return [
      ZegoToggleMicrophoneButton(
        buttonSize: widget.buttonSize,
        defaultOn: widget.config.isHost,
      ),
      ZegoToggleCameraButton(
        buttonSize: widget.buttonSize,
        defaultOn: widget.config.isHost,
      ),
      ZegoSwitchCameraFacingButton(
        buttonSize: widget.buttonSize,
      ),
    ];
  }

  List<Widget> audienceButtons() {
    return [
      ZegoSwitchAudioOutputButton(
        buttonSize: widget.buttonSize,
        iconSize: zegoLiveButtonIconSize,
        defaultUseSpeaker: widget.config.isHost,
      ),
    ];
  }
}
