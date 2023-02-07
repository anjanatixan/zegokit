// Flutter imports:
import 'dart:async';

import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/prebuilts/call/components/components.dart';
import 'package:zego_uikit/prebuilts/call/invitation/defines.dart';
import 'package:zego_uikit/service/internal/core/zim/zego_uikit_core_zim_stream.dart';
import 'package:zego_uikit/service/zego_uikit.dart';
import 'pages/calling_machine.dart';
import 'pages/invitation_notify.dart';
import 'call_invitation_service.dart';
import 'defines.dart';
import 'notification_ring.dart';

class ZegoInvitationPageService {
  factory ZegoInvitationPageService() => instance;
  static final ZegoInvitationPageService instance =
      ZegoInvitationPageService._internal();

  ZegoInvitationPageService._internal();

  var ring = ZegoNotificationRing();

  BuildContext get context => ZegoCallInvitationService.instance.contextQuery();

  void init() {
    ZegoUIKit().getInvitationReceivedStream().listen(onInvitationReceived);
    ZegoUIKit().getInvitationAcceptedStream().listen(onInvitationAccepted);
    ZegoUIKit().getInvitationTimeoutStream().listen(onInvitationTimeout);
    ZegoUIKit()
        .getInvitationResponseTimeoutStream()
        .listen(onInvitationResponseTimeout);
    ZegoUIKit().getInvitationRefusedStream().listen(onInvitationRefused);
    ZegoUIKit().getInvitationCanceledStream().listen(onInvitationCanceled);

    callingMachine = ZegoCallingMachine();
    callingMachine.init();

    //  ZegoUIKitCoreUser.localDefault() will set camera true at the first time
    //  reset to false, otherwise start preview will fail
    ZegoUIKit.instance.turnCameraOn(false);
  }

  late ZegoCallingMachine callingMachine;

  ZegoCallInvitationData invitationData = ZegoCallInvitationData.empty();

  bool invitationTopSheetVisibility = false;

  void onLocalSendInvitation(
    bool result,
    String callID,
    List<ZegoUIKitUser> invitees,
    ZegoInvitationType invitationType,
  ) {
    invitationData.callID = callID;
    invitationData.inviter = ZegoUIKit().getUser();
    invitationData.invitees = invitees;
    invitationData.type = invitationType;

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    if (result) {
      ZegoUIKit.instance.turnCameraOn(true);

      if (ZegoInvitationType.voiceCall == invitationData.type) {
        callingMachine.stateCallingWithVoice.enter();
      } else {
        callingMachine.stateCallingWithVideo.enter();
      }
    } else {
      restoreToIdle();
    }
  }

  void onLocalAcceptInvitation() {
    debugPrint("local accept invitation");

    ring.stopRing();

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    callingMachine.stateOnlineAudioVideo.enter();
  }

  void onLocalRefuseInvitation() {
    debugPrint("local refuse invitation");
    restoreToIdle();
  }

  void onLocalCancelInvitation() {
    debugPrint("local cancel invitation");

    restoreToIdle();
  }

  void onInvitationReceived(StreamDataInvitationReceived data) {
    if (CallingState.kIdle != callingMachine.getPageState()) {
      debugPrint("auto refuse this call, because call state is not idle, "
          "current state is ${callingMachine.getPageState()}");

      ZegoUIKit().refuseInvitation(data.inviter.id, '');

      return;
    }

    ring.startRing();

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    var invitationInternalData = InvitationInternalData.fromJson(data.data);
    invitationData.callID = invitationInternalData.callID;
    invitationData.invitees = invitationInternalData.invitees;

    invitationData.inviter = ZegoUIKitUser(
      id: data.inviter.id,
      name: data.inviter.name,
    );

    invitationData.type =
        ZegoInvitationTypeExtension.mapValue[data.type] as ZegoInvitationType;

    showInvitationTopSheet();
  }

  void onInvitationAccepted(StreamDataInvitationAccepted data) {
    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    callingMachine.stateOnlineAudioVideo.enter();
  }

  void onInvitationTimeout(StreamDataInvitationTimeout data) {
    restoreToIdle();
  }

  void onInvitationResponseTimeout(StreamDataInvitationResponseTimeout data) {
    restoreToIdle();
  }

  void onInvitationRefused(StreamDataInvitationRefused data) {
    restoreToIdle();
  }

  void onInvitationCanceled(StreamDataInvitationCanceled data) {
    restoreToIdle();
  }

  void onHangUp() {
    restoreToIdle();
  }

  void restoreToIdle() {
    debugPrint("invitation page service to be idle");

    ring.stopRing();

    ZegoUIKit.instance.turnCameraOn(false);

    hideInvitationTopSheet();

    if (CallingState.kIdle !=
        (callingMachine.machine.current?.identifier ?? CallingState.kIdle)) {
      debugPrint(
          'restore to idle, current state:${callingMachine.machine.current?.identifier}');

      Navigator.of(context).pop();

      callingMachine.stateIdle.enter();
    }

    invitationData = ZegoCallInvitationData.empty();
  }

  void onInvitationTopSheetEmptyClicked() {
    hideInvitationTopSheet();

    if (ZegoInvitationType.voiceCall == invitationData.type) {
      callingMachine.stateCallingWithVoice.enter();
    } else {
      callingMachine.stateCallingWithVideo.enter();
    }
  }

  void showInvitationTopSheet() {
    if (invitationTopSheetVisibility) {
      return;
    }

    invitationTopSheetVisibility = true;

    showTopModalSheet(
      context,
      GestureDetector(
        onTap: () {
          onInvitationTopSheetEmptyClicked();
        },
        child: ZegoCallInvitationDialog(
          invitationData: invitationData,
          avatarBuilder: ZegoCallInvitationService.instance
              .configQuery(invitationData)
              .avatarBuilder,
        ),
      ),
      barrierDismissible: false,
    );
  }

  void hideInvitationTopSheet() {
    if (invitationTopSheetVisibility) {
      Navigator.of(context).pop();

      invitationTopSheetVisibility = false;
    }
  }
}
