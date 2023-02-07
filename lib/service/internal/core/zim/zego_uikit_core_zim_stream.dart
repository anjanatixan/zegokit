// Dart imports:
import 'dart:async';

// Project imports:
import 'package:zego_uikit/service/defines/defines.dart';

mixin ZegoUIKitCoreZimStream {
  var streamCtrlInvitationReceived =
      StreamController<StreamDataInvitationReceived>.broadcast();

  var streamCtrlInvitationTimeout =
      StreamController<StreamDataInvitationTimeout>.broadcast();

  var streamCtrlInvitationResponseTimeout =
      StreamController<StreamDataInvitationResponseTimeout>.broadcast();

  var streamCtrlInvitationAccepted =
      StreamController<StreamDataInvitationAccepted>.broadcast();

  var streamCtrlInvitationRefused =
      StreamController<StreamDataInvitationRefused>.broadcast();

  var streamCtrlInvitationCanceled =
      StreamController<StreamDataInvitationCanceled>.broadcast();
}

class StreamDataInvitationReceived {
  final ZegoUIKitUser inviter;
  final int type; // call type
  final String data; // extended field

  StreamDataInvitationReceived(this.inviter, this.type, this.data);
}

class StreamDataInvitationTimeout {
  final ZegoUIKitUser inviter;
  final String data; // extended field

  StreamDataInvitationTimeout(this.inviter, this.data);
}

class StreamDataInvitationResponseTimeout {
  final List<ZegoUIKitUser> invitees;
  final String data; // extended field

  StreamDataInvitationResponseTimeout(this.invitees, this.data);
}

class StreamDataInvitationAccepted {
  final ZegoUIKitUser invitee;
  final String data; // extended field

  StreamDataInvitationAccepted(this.invitee, this.data);
}

class StreamDataInvitationRefused {
  final ZegoUIKitUser invitee;
  final String data; // extended field

  StreamDataInvitationRefused(this.invitee, this.data);
}

class StreamDataInvitationCanceled {
  final ZegoUIKitUser inviter;
  final String data; // extended field

  StreamDataInvitationCanceled(this.inviter, this.data);
}
