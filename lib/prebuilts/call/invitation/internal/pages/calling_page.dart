// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/service/zego_uikit.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/page_service.dart';
import 'package:zego_uikit/prebuilts/call/call_config.dart';
import 'package:zego_uikit/prebuilts/call/call.dart';
import 'package:zego_uikit/prebuilts/call/call_defines.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/call_invitation_service.dart';
import 'package:zego_uikit/prebuilts/call/invitation/defines.dart';
import 'calling_machine.dart';
import 'calling_view.dart';

class ZegoCallingPage extends StatefulWidget {
  final ZegoUIKitUser inviter;
  final ZegoUIKitUser invitee;

  final VoidCallback onInitState;
  final VoidCallback onDispose;

  const ZegoCallingPage({
    Key? key,
    required this.inviter,
    required this.invitee,
    required this.onInitState,
    required this.onDispose,
  }) : super(key: key);

  @override
  ZegoCallingPageState createState() => ZegoCallingPageState();
}

class ZegoCallingPageState extends State<ZegoCallingPage> {
  CallingState currentState = CallingState.kIdle;

  VoidCallback? callConfigHandUp;
  ZegoUIKitPrebuiltCallConfig? callConfig;

  final ZegoCallingMachine machine =
      ZegoInvitationPageService.instance.callingMachine;

  ZegoInvitationPageService get pageService =>
      ZegoInvitationPageService.instance;

  ZegoCallInvitationService get callInvitationService =>
      ZegoCallInvitationService.instance;

  @override
  void initState() {
    super.initState();

    widget.onInitState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      machine.onStateChanged = (CallingState state) {
        setState(() {
          currentState = state;
        });
      };

      if (null != machine.machine.current) {
        machine.onStateChanged!(machine.machine.current!.identifier);
      }
    });
  }

  @override
  void dispose() {
    widget.onDispose();

    machine.onStateChanged = null;

    callConfig = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localUserInfo = ZegoUIKit().getUser();

    late Widget view;
    switch (currentState) {
      case CallingState.kIdle:
        view = const SizedBox();
        break;
      case CallingState.kCallingWithVoice:
      case CallingState.kCallingWithVideo:
        callConfig = null;

        var localUserIsInviter = localUserInfo.id == widget.inviter.id;
        var callingView = localUserIsInviter
            ? ZegoInviterCallingView(
                inviter: widget.inviter,
                invitee: widget.invitee,
                invitationType: pageService.invitationData.type,
                avatarBuilder: callInvitationService
                    .configQuery(pageService.invitationData)
                    .avatarBuilder,
              )
            : ZegoCallingInviteeView(
                inviter: widget.inviter,
                invitee: widget.invitee,
                invitationType: pageService.invitationData.type,
                avatarBuilder: callInvitationService
                    .configQuery(pageService.invitationData)
                    .avatarBuilder,
              );
        view = ScreenUtilInit(
          designSize: const Size(360, 740),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return callingView;
          },
        );
        break;
      case CallingState.kOnlineAudioVideo:
        view = prebuiltCallPage();
        break;
    }

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: view,
        ));
  }

  void onCallHandUp() {
    callConfigHandUp?.call();
    pageService.onHangUp();
  }

  Widget prebuiltCallPage() {
    callConfig = callInvitationService.configQuery(pageService.invitationData);

    callConfigHandUp = callConfig?.onHangUp;
    callConfig?.onHangUp = onCallHandUp;

    callConfig?.turnOnCameraWhenJoining =
        (ZegoInvitationType.videoCall == pageService.invitationData.type);
    if (ZegoInvitationType.videoCall != pageService.invitationData.type) {
      var list =
          List<ZegoMenuBarButtonName>.from(callConfig?.menuBarButtons ?? []);
      list.remove(ZegoMenuBarButtonName.toggleCameraButton);
      list.remove(ZegoMenuBarButtonName.switchCameraFacingButton);
      callConfig?.menuBarButtons = list;
    }

    return ZegoUIKitPrebuiltCall(
      appID: callInvitationService.appID,
      appSign: callInvitationService.appSign,
      callID: pageService.invitationData.callID,
      userID: callInvitationService.userID,
      userName: callInvitationService.userName,
      tokenServerUrl: callInvitationService.tokenServerUrl,
      config: callConfig!,
    );
  }
}
