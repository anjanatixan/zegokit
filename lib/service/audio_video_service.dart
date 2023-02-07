part of 'zego_uikit.dart';

mixin ZegoUIKitAudioVideoService {
  void setAudioOutputToSpeaker(bool isSpeaker) {
    ZegoUIKitCore.shared.setAudioOutputToSpeaker(isSpeaker);
  }

  void turnCameraOn(bool isOn, {String? userID}) {
    ZegoUIKitCore.shared.turnCameraOn(isOn);
  }

  void turnMicrophoneOn(bool enable, {String? userID}) {
    ZegoUIKitCore.shared.turnMicrophoneOn(enable);
  }

  void useFrontFacingCamera(bool isFrontFacing) {
    ZegoUIKitCore.shared.useFrontFacingCamera(isFrontFacing);
  }

  void setAudioConfig() {}

  void setVideoConfig() {}

  ValueNotifier<Widget?> getAudioVideoViewNotifier(String? userID) {
    if (userID == null ||
        userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.view;
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]?.view ??
          ValueNotifier<Widget>(Container());
    }
  }

  ValueNotifier<bool> getCameraStateNotifier(String userID) {
    if (userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.camera;
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]?.camera ??
          ValueNotifier<bool>(false);
    }
  }

  ValueNotifier<bool> getUseFrontFacingCameraStateNotifier(String userID) {
    if (userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.isFrontFacing;
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]?.isFrontFacing ??
          ValueNotifier<bool>(false);
    }
  }

  ValueNotifier<bool> getMicrophoneStateNotifier(String userID) {
    if (userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.microphone;
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]?.microphone ??
          ValueNotifier<bool>(false);
    }
  }

  ValueNotifier<ZegoAudioRoute> getAudioOutputDeviceNotifier(String userID) {
    if (userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.audioRoute;
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]?.audioRoute ??
          ValueNotifier<ZegoAudioRoute>(ZegoAudioRoute.Receiver);
    }
  }

  Stream<double> createSoundLevelStream(String userID) {
    if (userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.soundLevel.stream;
    } else {
      return ZegoUIKitCore
              .shared.coreData.remoteUser[userID]?.soundLevel.stream ??
          const Stream<double>.empty();
    }
  }

  Stream<List<ZegoUIKitUser>> createAudioVideoListStream() {
    return ZegoUIKitCore.shared.coreData.streamControllerUserList.stream.map(
      (event) => event.entries
          .where((element) => element.value.view.value != null)
          .map((entry) => entry.value.toZegoUikitUser())
          .toList(),
    );
  }

  ValueNotifier<Size> getVideoSizeNotifier(String userID) {
    if (userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.viewSize;
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]?.viewSize ??
          ValueNotifier<Size>(const Size(320, 640));
    }
  }

  void updateTextureRendererSize(String? userID, int width, int height) {
    ZegoUIKitCore.shared.updateTextureRendererSize(userID, width, height);
  }

  void updateTextureRendererOrientation(Orientation orientation) {
    ZegoUIKitCore.shared.updateTextureRendererOrientation(orientation);
  }

  void updateAppOrientation(DeviceOrientation orientation) {
    ZegoUIKitCore.shared.updateAppOrientation(orientation);
  }

  void updateVideoViewMode(bool useVideoViewAspectFill) {
    ZegoUIKitCore.shared.updateVideoViewMode(useVideoViewAspectFill);
  }

  // Future<void> enableBeauty(bool isOn) async {
  //   ZegoUIKitCore.shared.enableBeauty(isOn);
  // }

  // Future<void> startEffectsEnv() async {
  //   ZegoUIKitCore.shared.startEffectsEnv();
  // }
  //
  // Future<void> stopEffectsEnv() async {
  //   ZegoUIKitCore.shared.stopEffectsEnv();
  // }
}
