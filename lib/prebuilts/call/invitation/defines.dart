// Project imports:
import 'package:zego_uikit/service/defines/defines.dart';

class ZegoCallInvitationData {
  String callID = '';
  ZegoInvitationType type = ZegoInvitationType.voiceCall;
  List<ZegoUIKitUser> invitees = [];
  ZegoUIKitUser? inviter;

  ZegoCallInvitationData.empty();
}

enum ZegoInvitationType {
  voiceCall,
  videoCall,
}

extension ZegoInvitationTypeExtension on ZegoInvitationType {
  static const valueMap = {
    ZegoInvitationType.voiceCall: 0,
    ZegoInvitationType.videoCall: 1,
  };

  int get value => valueMap[this] ?? -1;

  static const Map<int, ZegoInvitationType> mapValue = {
    0: ZegoInvitationType.voiceCall,
    1: ZegoInvitationType.videoCall,
  };
}
