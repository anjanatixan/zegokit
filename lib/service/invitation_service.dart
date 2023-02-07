part of 'zego_uikit.dart';

mixin ZegoUIKitInvitationService {
  ///  load zim sdk
  Future<void> loadZIM({required int appID, String appSecret = ''}) async {
    ZegoUIKitCore.shared.loadZim(appID: appID, appSecret: appSecret);
  }

  ///  unload zim sdk
  Future<void> unloadZim() async {
    return await ZegoUIKitCore.shared.unloadZim();
  }

  /// send invitation to one or more specified users
  /// [invitees] list of invitees.
  /// [timeout]timeout of the call invitation, the unit is seconds
  /// [type] call type
  /// [data] extended field, through which the inviter can carry information to the invitee.
  Future<bool> sendInvitation(
    String inviterName,
    List<String> invitees,
    int timeout,
    int type,
    String data,
  ) async {
    invitees.removeWhere((item) => ["", null].contains(item));
    if (invitees.isEmpty) {
      debugPrint('[Error] invitees is empty');
      return false;
    }

    var invitationExtendedData = InvitationExtendedData(
      inviterName,
      type,
      data,
    );

    var config = ZIMCallInviteConfig();
    config.timeout = timeout;
    config.extendedData = invitationExtendedData.toJson();

    debugPrint(
        'send invitation: invitees:$invitees, timeout:$timeout, type:$type, data:$data');

    return await ZegoUIKitCore.shared.zimPlugin?.invite(invitees, config) ??
        false;
  }

  /// cancel invitation to one or more specified users
  /// [inviteeID] invitee's id
  /// [data] extended field
  Future<bool> cancelInvitation(List<String> invitees, String data) async {
    invitees.removeWhere((item) => ["", null].contains(item));
    if (invitees.isEmpty) {
      debugPrint('[Error] invitees is empty');
      return false;
    }

    var config = ZIMCallCancelConfig();
    config.extendedData = data;

    var callID = ZegoUIKitCore.shared.zimPlugin
            ?.queryCallID(ZegoUIKitCore.shared.coreData.localUser.id) ??
        "";
    debugPrint(
        'cancel invitation: callID:$callID, invitees:$invitees, data:$data');

    return await ZegoUIKitCore.shared.zimPlugin
            ?.cancel(invitees, callID, config) ??
        false;
  }

  /// invitee reject the call invitation
  /// [inviterID] inviter id, who send invitation
  /// [data] extended field, you can include your reasons such as Declined
  void refuseInvitation(String inviterID, String data) async {
    var config = ZIMCallRejectConfig();
    config.extendedData = data;

    var callID = ZegoUIKitCore.shared.zimPlugin?.queryCallID(inviterID) ?? "";
    debugPrint(
        'refuse invitation: callID:$callID, inviter id:$inviterID, data:$data');

    if (callID.isEmpty) {
      debugPrint('[Error] call id is empty');
      return;
    }

    await ZegoUIKitCore.shared.zimPlugin?.reject(callID, config);
  }

  /// invitee accept the call invitation
  /// [inviterID] inviter id, who send invitation
  /// [data] extended field
  void acceptInvitation(String inviterID, String data) async {
    var config = ZIMCallAcceptConfig();
    config.extendedData = data;

    var callID = ZegoUIKitCore.shared.zimPlugin?.queryCallID(inviterID) ?? "";
    debugPrint(
        'accept invitation: callID:$callID, inviter id:$inviterID, data:$data');

    if (callID.isEmpty) {
      debugPrint('[Error] call id is empty');
      return;
    }

    await ZegoUIKitCore.shared.zimPlugin?.accept(callID, config);
  }

  /// stream callback, notify invitee when call invitation received
  Stream<StreamDataInvitationReceived> getInvitationReceivedStream() {
    return ZegoUIKitCore.shared.zimPlugin!.streamCtrlInvitationReceived.stream;
  }

  /// stream callback, notify invitee if invitation timeout
  Stream<StreamDataInvitationTimeout> getInvitationTimeoutStream() {
    return ZegoUIKitCore.shared.zimPlugin!.streamCtrlInvitationTimeout.stream;
  }

  /// stream callback, When the call invitation times out, the invitee does not respond, and the inviter will receive a callback.
  Stream<StreamDataInvitationResponseTimeout>
      getInvitationResponseTimeoutStream() {
    return ZegoUIKitCore
        .shared.zimPlugin!.streamCtrlInvitationResponseTimeout.stream;
  }

  /// stream callback, notify when call invitation accepted by invitee
  Stream<StreamDataInvitationAccepted> getInvitationAcceptedStream() {
    return ZegoUIKitCore.shared.zimPlugin!.streamCtrlInvitationAccepted.stream;
  }

  /// stream callback, notify when call invitation rejected by invitee
  Stream<StreamDataInvitationRefused> getInvitationRefusedStream() {
    return ZegoUIKitCore.shared.zimPlugin!.streamCtrlInvitationRefused.stream;
  }

  /// stream callback, notify when call invitation cancelled by inviter
  Stream<StreamDataInvitationCanceled> getInvitationCanceledStream() {
    return ZegoUIKitCore.shared.zimPlugin!.streamCtrlInvitationCanceled.stream;
  }
}
