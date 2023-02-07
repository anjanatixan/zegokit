export 'internal/internal.dart';
export 'defines/defines.dart';
export 'package:zego_express_engine/zego_express_engine.dart';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'defines/defines.dart';
import 'defines/zego_uikit_room.dart';
import 'internal/core/zim/zego_uikit_core_zim_defines.dart';
import 'internal/core/zim/zego_uikit_core_zim_stream.dart';
import 'internal/internal.dart';

part 'room_service.dart';
part 'chat_service.dart';
part 'user_service.dart';

part 'audio_video_service.dart';
part 'invitation_service.dart';

class ZegoUIKit
    with
        ZegoUIKitAudioVideoService,
        ZegoUIKitRoomService,
        ZegoUIKitUserService,
        ZegoUIKitInvitationService,
        ZegoUIKitChatService {
  ZegoUIKit._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }
  factory ZegoUIKit() => instance;
  static final ZegoUIKit instance = ZegoUIKit._internal();

  Future<String> getZegoUIKitVersion() async {
    return await ZegoUIKitCore.shared.getZegoUIKitVersion();
  }

  Future<void> init(
      {required int appID,
      String appSign = '',
      ZegoScenario scenario = ZegoScenario.Communication,
      String tokenServerUrl = ''}) async {
    return await ZegoUIKitCore.shared.init(
        appID: appID,
        appSign: appSign,
        scenario: scenario,
        tokenServerUrl: tokenServerUrl);
  }

  Future<void> uninit() async {
    return await ZegoUIKitCore.shared.uninit();
  }
}
