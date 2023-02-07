// Dart imports:
import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zego_express_engine/src/zego_express_error_code.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

// Project imports:
import 'package:zego_uikit/service/defines/defines.dart';
import 'package:zego_uikit/service/defines/zego_uikit_room.dart';
import 'package:zego_uikit/service/internal/core/zim/zego_uikit_core_zim.dart';

// Project imports:
part 'zego_uikit_core_defines.dart';

part 'zego_uikit_core_utils.dart';

part 'zego_uikit_core_event.dart';

part 'zego_uikit_core_data.dart';

part 'zego_uikit_core_chat.dart';

class ZegoUIKitCore with ZegoUIKitCoreEvent {
  final ZegoUIKitCoreData coreData = ZegoUIKitCoreData();
  final ZegoUIKitCoreChat coreChat = ZegoUIKitCoreChat();
  static final ZegoUIKitCore shared = ZegoUIKitCore._internal();

  bool isInit = false;
  bool isNeedDisableWakelock = false;

  ZegoUIKitCoreZimPlugin? zimPlugin;

  ZegoUIKitCore._internal();

  Future<String> getZegoUIKitVersion() async {
    String expressVersion = await ZegoExpressEngine.getVersion();
    const String kZegoUIKitVersion = '0.1.3';
    String zegoUIKitVersion = '$kZegoUIKitVersion($expressVersion)';
    log('🌞 ZegoUIKit Version: $zegoUIKitVersion');
    return zegoUIKitVersion;
  }

  Future<void> init({
    required int appID,
    String appSign = '',
    ZegoScenario scenario = ZegoScenario.Communication,
    String? tokenServerUrl,
  }) async {
    if (isInit) {
      debugPrint("core had init, ignore");
      return;
    }

    isInit = true;

    ZegoEngineProfile profile =
        ZegoEngineProfile(appID, scenario, appSign: appSign);
    if (kIsWeb) {
      profile.appSign = null;
      profile.enablePlatformView = true;
    }
    initEventHandle();

    await ZegoExpressEngine.createEngineWithProfile(profile);

    if (!kIsWeb) {
      ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(advancedConfig: {
        'notify_remote_device_unknown_status': 'true',
        'notify_remote_device_init_status': 'true',
      }));

      var initAudioRoute = await ZegoExpressEngine.instance.getAudioRouteType();
      coreData.localUser.audioRoute.value = initAudioRoute;
      coreData.localUser.lastAudioRoute = initAudioRoute;
    }
  }

  Future<void> uninit() async {
    if (!isInit) {
      debugPrint("core is not init, ignore");
      return;
    }

    isInit = false;

    uninitEventHandle();
    clear();

    await ZegoExpressEngine.destroyEngine();
  }

  void clear() {
    coreData.clear();
    coreChat.clear();
  }

  Future<void> loadZim({required int appID, String appSecret = ''}) async {
    if (zimPlugin != null) {
      return;
    }

    zimPlugin = ZegoUIKitCoreZimPlugin();
    zimPlugin?.create(appID: appID, appSecret: appSecret);
  }

  Future<void> unloadZim() async {
    return await zimPlugin?.destroy();
  }

  @override
  void uninitEventHandle() {}

  Future<void> login(String id, String name) async {
    await zimPlugin?.login(id, name);
    coreData.login(id, name);
  }

  Future<void> logout() async {
    await zimPlugin?.logout();

    coreData.logout();
  }

  Future<ZegoRoomLoginResult> joinRoom(String roomID,
      {String token = ''}) async {
    if (!kIsWeb) {
      await requestPermission();
    }

    if (kIsWeb) {
      assert(token.isNotEmpty);
    }

    clear();
    coreData.setRoom(roomID);

    Future<bool> originWakelockEnabledF = Wakelock.enabled;

    ZegoRoomLoginResult joinRoomResult =
        await ZegoExpressEngine.instance.loginRoom(
      roomID,
      coreData.localUser.toZegoUser(),
      config: ZegoRoomConfig(0, true, token),
    );

    if (joinRoomResult.errorCode == 0) {
      coreData.startPublishOrNot();
      bool originWakelockEnabled = await originWakelockEnabledF;
      if (originWakelockEnabled) {
        isNeedDisableWakelock = false;
      } else {
        isNeedDisableWakelock = true;
        Wakelock.enable();
      }
      if (!kIsWeb) ZegoExpressEngine.instance.startSoundLevelMonitor();
    } else if (joinRoomResult.errorCode == ZegoErrorCode.RoomCountExceed) {
      await leaveRoom();
      return await joinRoom(roomID, token: token);
    } else {
      log("joinRoom failed: ${joinRoomResult.errorCode}, ${joinRoomResult.extendedData.toString()}");
    }
    return joinRoomResult;
  }

  Future<ZegoRoomLogoutResult> leaveRoom() async {
    if (isNeedDisableWakelock) {
      Wakelock.disable();
    }

    clear();

    if (!kIsWeb) {
      await ZegoExpressEngine.instance.stopSoundLevelMonitor();
    }

    ZegoRoomLogoutResult leaveResult =
        await ZegoExpressEngine.instance.logoutRoom();
    if (leaveResult.errorCode != 0) {
      log("leaveRoom failed: ${leaveResult.errorCode}, ${leaveResult.extendedData.toString()}");
    }
    return leaveResult;
  }

  void useFrontFacingCamera(bool isFrontFacing) {
    if (kIsWeb) {
      return;
    }
    if (isFrontFacing == coreData.localUser.isFrontFacing.value) {
      return;
    }

    ZegoExpressEngine.instance.useFrontCamera(isFrontFacing);
    coreData.localUser.isFrontFacing.value = isFrontFacing;
  }

  void setAudioOutputToSpeaker(bool useSpeaker) {
    if (kIsWeb) {
      return;
    }
    if (useSpeaker ==
        (coreData.localUser.audioRoute.value == ZegoAudioRoute.Speaker)) {
      return;
    }

    ZegoExpressEngine.instance.setAudioRouteToSpeaker(useSpeaker);

    // todo use sdk callback to update audioRoute
    if (useSpeaker) {
      coreData.localUser.lastAudioRoute = coreData.localUser.audioRoute.value;
      coreData.localUser.audioRoute.value = ZegoAudioRoute.Speaker;
    } else {
      coreData.localUser.audioRoute.value = coreData.localUser.lastAudioRoute;
    }
  }

  void turnCameraOn(bool isOn) {
    if (isOn == coreData.localUser.camera.value) {
      return;
    }

    if (isOn) {
      coreData.startPreview();
    } else {
      coreData.stopPreview();
    }

    if (kIsWeb) {
      ZegoExpressEngine.instance.mutePublishStreamVideo(!isOn);
    } else {
      ZegoExpressEngine.instance.enableCamera(isOn);
    }

    coreData.localUser.camera.value = isOn;

    coreData.startPublishOrNot();
  }

  void turnMicrophoneOn(bool isOn) {
    if (isOn == coreData.localUser.microphone.value) {
      return;
    }
    if (kIsWeb) {
      ZegoExpressEngine.instance.mutePublishStreamAudio(!isOn);
    } else {
      ZegoExpressEngine.instance.muteMicrophone(!isOn);
    }

    coreData.localUser.microphone.value = isOn;
    coreData.startPublishOrNot();
  }

  void updateTextureRendererOrientation(Orientation orientation) {
    switch (orientation) {
      case Orientation.portrait:
        ZegoExpressEngine.instance
            .setAppOrientation(DeviceOrientation.portraitUp);
        break;
      case Orientation.landscape:
        ZegoExpressEngine.instance
            .setAppOrientation(DeviceOrientation.landscapeLeft);
        break;
    }
  }

  void updateTextureRendererSize(String? id, int w, int h) {
    if (kIsWeb) {
      return;
    }

    int textureID = -1;
    int oldWidth = w;
    int oldHeight = h;
    if (id == null || id == ZegoUIKitCore.shared.coreData.localUser.id) {
      textureID = ZegoUIKitCore.shared.coreData.localUser.viewID;
      if (textureID == -1) return;
      oldWidth = ZegoUIKitCore.shared.coreData.localUser.textureWidth;
      oldHeight = ZegoUIKitCore.shared.coreData.localUser.textureHeight;
      if (oldWidth == w && oldHeight == h) return;
      ZegoUIKitCore.shared.coreData.localUser.textureWidth = w;
      ZegoUIKitCore.shared.coreData.localUser.textureHeight = h;
    } else {
      textureID = ZegoUIKitCore.shared.coreData.remoteUser[id]?.viewID ?? -1;
      if (textureID == -1) return;
      oldWidth = ZegoUIKitCore.shared.coreData.remoteUser[id]!.textureWidth;
      oldHeight = ZegoUIKitCore.shared.coreData.remoteUser[id]!.textureHeight;
      if (oldWidth == w && oldHeight == h) return;
      ZegoUIKitCore.shared.coreData.remoteUser[id]!.textureWidth = w;
      ZegoUIKitCore.shared.coreData.remoteUser[id]!.textureHeight = h;
    }

    ZegoExpressEngine.instance.updateTextureRendererSize(textureID, w, h);
  }

  void setVideoConfig(ZegoUIKitVideoConfig config) {
    if (coreData.videoConfig.needUpdateVideoConfig(config)) {
      ZegoVideoConfig zegoVideoConfig = config.toZegoVideoConfig();
      ZegoExpressEngine.instance.setVideoConfig(zegoVideoConfig);
      coreData.localUser.viewSize.value = Size(
          zegoVideoConfig.captureWidth.toDouble(),
          zegoVideoConfig.captureHeight.toDouble());
    }
    if (coreData.videoConfig.needUpdateOrientation(config)) {
      ZegoExpressEngine.instance.setAppOrientation(config.orientation);
    }

    coreData.videoConfig = config;
  }

  void updateAppOrientation(DeviceOrientation orientation) {
    if (coreData.videoConfig.orientation == orientation) {
      return;
    } else {
      setVideoConfig(coreData.videoConfig.copyWith(orientation: orientation));
    }
  }

  void updateVideoViewMode(bool useVideoViewAspectFill) {
    if (coreData.videoConfig.useVideoViewAspectFill == useVideoViewAspectFill) {
      return;
    } else {
      coreData.videoConfig.useVideoViewAspectFill = useVideoViewAspectFill;
      // todo need re preview, and re playStream
    }
  }

// Future<void> enableBeauty(bool isOn) async {
//   ZegoExpressEngine.instance.enableEffectsBeauty(isOn);
//
//   // todo adjust it via ui
//   var beautyParam = ZegoEffectsBeautyParam.defaultParam();
//   beautyParam.whitenIntensity = 100;
//   beautyParam.rosyIntensity = 70;
//   beautyParam.smoothIntensity = 70;
//   beautyParam.sharpenIntensity = 70;
//   ZegoExpressEngine.instance.setEffectsBeautyParam(beautyParam);
// }

// Future<void> startEffectsEnv() async {
//   await ZegoExpressEngine.instance.startEffectsEnv();
// }
//
// Future<void> stopEffectsEnv() async {
//   await ZegoExpressEngine.instance.stopEffectsEnv();
// }
}
