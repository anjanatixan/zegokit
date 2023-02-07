// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit/service/defines/defines.dart';
import 'package:zego_uikit/service/internal/core/zego_uikit_core.dart';
import 'package:zego_uikit/service/internal/utils/utils.dart';
import 'zego_uikit_core_zim_defines.dart';
import 'zego_uikit_core_zim_stream.dart';

class ZegoUIKitCoreZimPlugin with ZegoUIKitCoreZimStream {
  ZegoUIKitCoreZimPlugin();

  bool isCreated = false;
  int appID = 0;
  String appSecret = '';
  ZIMUserInfo? loginUser;

  Completer? connectionStateWaiter;
  var connectionState = ZIMConnectionState.disconnected;

  Map<String, String> _userCallIDs = {}; //  <user id, zim call id>

  String get _localUserID => ZegoUIKitCore.shared.coreData.localUser.id;

  Future<void> create({required int appID, String appSecret = ''}) async {
    if (isCreated) {
      debugPrint("[zim] has created.");
      return;
    }

    this.appID = appID;
    this.appSecret = appSecret;

    isCreated = true;
    ZIMAppConfig config = ZIMAppConfig();
    config.appID = appID;
    config.appSign = appSecret;
    ZIM.create(config);
    initEventHandler();
    //   return await ZIM.getInstance().create(appID).then((value) {
    //     debugPrint('[zim] create success');

    //     initEventHandler();
    //   }).onError((error, stackTrace) {
    //     debugPrint('[zim] create error, $error');
    //   });
    // }
  }

  Future<void> destroy() async {
    if (!isCreated) {
      debugPrint("[zim] is not created.");
      return;
    }

    uninitEventHandler();

    await ZIM.getInstance()!.destroy();

    clear();

    debugPrint("[zim] destroy.");
  }

  Future<void> login(String id, String name) async {
    if (!isCreated) {
      debugPrint("[zim] is not created.");
      return;
    }

    if (loginUser != null) {
      debugPrint("[zim] has login.");
      return;
    }

    //  wait state be disconnect if relogin
    if (null != connectionStateWaiter && !connectionStateWaiter!.isCompleted) {
      connectionStateWaiter?.complete();
    }
    await waitConnectionState(ZIMConnectionState.disconnected);

    debugPrint("[zim] login request, user id:$id, user name:$name");
    loginUser = ZIMUserInfo();
    loginUser?.userID = id;
    loginUser?.userName = name;
    await generateZegoToken(appID, loginUser!.userID, appSecret).then((token) {
      debugPrint('[zim] login generate token: $token');
      ZIM.getInstance()!.login(loginUser!, token).then((value) {
        debugPrint('[zim] login success');
      }).onError((error, stackTrace) {
        debugPrint('[zim] login error, $error');
      });
    });

    debugPrint("[zim] login.");
  }

  Future<void> logout() async {
    loginUser = null;

    await ZIM.getInstance()!.logout();

    clear();

    debugPrint("[zim] logout.");
  }

  String queryCallID(String userID) {
    return _userCallIDs[userID] ?? "";
  }

  Future<bool> invite(List<String> invitees, ZIMCallInviteConfig config) async {
    return ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult result) async {
      _userCallIDs[_localUserID] = result.callID;
      if (result.info.errorInvitees.isNotEmpty) {
        for (var invitee in result.info.errorInvitees) {
          debugPrint(
              '[zim] invite error, invitee state: ${invitee.state.toString()}');
        }
      } else {
        debugPrint('[zim] invite done, call id:${result.callID}');
      }
      return result.info.errorInvitees.isEmpty;
    });
  }

  Future<bool> cancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    return await ZIM
        .getInstance()!
        .callCancel(invitees, callID, config)
        .then((ZIMCallCancelSentResult result) {
      _userCallIDs.remove(_localUserID);

      if (result.errorInvitees.isNotEmpty) {
        for (var element in result.errorInvitees) {
          debugPrint(
              '[zim] cancel invitation error, call id:${result.callID}, invitee id:${element.toString()}');
        }
      } else {
        debugPrint('[zim] cancel invitation done, call id:${result.callID}');
      }

      return result.errorInvitees.isNotEmpty;
    });
  }

  Future<void> accept(String callID, ZIMCallAcceptConfig config) async {
    return await ZIM
        .getInstance()!
        .callAccept(callID, config)
        .then((ZIMCallAcceptanceSentResult result) {
      debugPrint('[zim] accept invitation done, call id:${result.callID}');
    });
  }

  Future<void> reject(String callID, ZIMCallRejectConfig config) async {
    String inviteUserID = getInviteUserIDByCallID(callID);
    _userCallIDs.remove(inviteUserID);

    return await ZIM
        .getInstance()!
        .callReject(callID, config)
        .then((ZIMCallRejectionSentResult result) {
      debugPrint('[zim] reject invitation done, call id:${result.callID}');
    });
  }

  String getInviteUserIDByCallID(String callID) {
    String inviteUserID = "";
    _userCallIDs.forEach((userID, userCallID) {
      if (callID == userCallID) {
        inviteUserID = userID;
      }
    });
    return inviteUserID;
  }

  void initEventHandler() {
    debugPrint("[zim] register event handle.");

    ZIMEventHandler.onCallInvitationReceived = onCallInvitationReceived;
    ZIMEventHandler.onCallInvitationCancelled = onCallInvitationCancelled;
    ZIMEventHandler.onCallInvitationAccepted = onCallInvitationAccepted;
    ZIMEventHandler.onCallInvitationRejected = onCallInvitationRejected;
    ZIMEventHandler.onCallInvitationTimeout = onCallInvitationTimeout;
    ZIMEventHandler.onCallInviteesAnsweredTimeout =
        onCallInviteesAnsweredTimeout;

    ZIMEventHandler.onTokenWillExpire = onTokenWillExpire;

    ZIMEventHandler.onError = onError;
    ZIMEventHandler.onConnectionStateChanged = onConnectionStateChanged;
  }

  void uninitEventHandler() {
    debugPrint("[zim] unregister event handle.");

    ZIMEventHandler.onCallInvitationReceived = null;
    ZIMEventHandler.onCallInvitationCancelled = null;
    ZIMEventHandler.onCallInvitationAccepted = null;
    ZIMEventHandler.onCallInvitationRejected = null;
    ZIMEventHandler.onCallInvitationTimeout = null;
    ZIMEventHandler.onCallInviteesAnsweredTimeout = null;
  }

  void clear() {
    _userCallIDs = {};
  }

  void onCallInvitationReceived(
      ZIM data, ZIMCallInvitationReceivedInfo info, String callID) {
    debugPrint(
        '[zim] onCallInvitationReceived, timeout:${info.timeout}, inviter:${info.inviter}, extended data:${info.extendedData}, callID:$callID');
    _userCallIDs[info.inviter] = callID;

    var invitationExtendedData =
        InvitationExtendedData.fromJson(info.extendedData);
    var event = StreamDataInvitationReceived(
      ZegoUIKitUser(id: info.inviter, name: invitationExtendedData.inviterName),
      invitationExtendedData.type,
      invitationExtendedData.data,
    );
    streamCtrlInvitationReceived.add(event);
  }

  void onCallInvitationCancelled(
      ZIM data, ZIMCallInvitationCancelledInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationCancelled, inviter:${info.inviter}, extended data:${info.extendedData}, call id: $callID');

    var event = StreamDataInvitationCanceled(
      ZegoUIKitUser(id: info.inviter, name: ''),
      info.extendedData,
    );
    streamCtrlInvitationCanceled.add(event);
  }

  void onCallInvitationAccepted(
      ZIM data, ZIMCallInvitationAcceptedInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationAccepted, invitee:${info.invitee}, extended data:${info.extendedData}, $callID');

    var event = StreamDataInvitationAccepted(
      ZegoUIKitUser(id: info.invitee, name: ''),
      info.extendedData,
    );
    streamCtrlInvitationAccepted.add(event);
  }

  void onCallInvitationRejected(
      ZIM data, ZIMCallInvitationRejectedInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationRejected, invitee:${info.invitee}, extended data:${info.extendedData}, $callID');

    var event = StreamDataInvitationRefused(
      ZegoUIKitUser(id: info.invitee, name: ''),
      info.extendedData,
    );
    streamCtrlInvitationRefused.add(event);
  }

  void onCallInvitationTimeout(ZIM data, String callID) {
    debugPrint('[zim] onCallInvitationTimeout $callID');

    String inviteUserID = getInviteUserIDByCallID(callID);

    var event = StreamDataInvitationTimeout(
      ZegoUIKitUser(id: inviteUserID, name: ''),
      '',
    );
    streamCtrlInvitationTimeout.add(event);
  }

  void onCallInviteesAnsweredTimeout(
      ZIM data, List<String> invitees, String callID) {
    debugPrint(
        '[zim] onCallInviteesAnsweredTimeout, invitees:$invitees, call id:$callID');

    var event = StreamDataInvitationResponseTimeout(
      invitees
          .map((inviteeID) => ZegoUIKitUser(id: inviteeID, name: ''))
          .toList(),
      '',
    );
    streamCtrlInvitationResponseTimeout.add(event);
  }

  void onTokenWillExpire(ZIM data, int second) {
    if (second < 5) {
      debugPrint(
          '[zim] token will expire, seconds:$second, ready to generate token ...');

      if (null == loginUser) {
        debugPrint('[zim] token will expire, but user is null');
        return;
      }

      generateZegoToken(appID, loginUser!.userID, appSecret)
          .then((token) async {
        debugPrint(
            '[zim] generate token now, token:$token, ready to renew token');
        await ZIM
            .getInstance()!
            .renewToken(token)
            .then((ZIMTokenRenewedResult result) {
          debugPrint('[zim] renew token done');
        });
      });
    }
  }

  void onError(ZIM data, ZIMError errorInfo) {
    debugPrint(
        "[zim] zim error, code:${errorInfo.code}, message:${errorInfo.message}");
  }

  void onConnectionStateChanged(ZIM data, ZIMConnectionState state,
      ZIMConnectionEvent event, Map extendedData) {
    debugPrint(
        "[zim] connection state changed, state:$state, event:$event, extended data:$extendedData");

    connectionState = state;
  }

  Future<void> waitConnectionState(ZIMConnectionState state,
      {Duration duration = const Duration(milliseconds: 100)}) async {
    debugPrint(
        "[zim] waitConnectionState, target state:$state, current state: $connectionState, duration:$duration");

    connectionStateWaiter = Completer();
    if (state != connectionState) {
      debugPrint(
          "[zim] waitConnectionState wait, target state:$state, current state: $connectionState");
      await Future.delayed(duration);
      return waitConnectionState(state, duration: duration);
    } else {
      debugPrint("[zim] waitConnectionState complete");
      connectionStateWaiter?.complete();
    }

    return connectionStateWaiter?.future;
  }
}
