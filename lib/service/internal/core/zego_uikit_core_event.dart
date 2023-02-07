part of 'zego_uikit_core.dart';

mixin ZegoUIKitCoreEvent {
  void uninitEventHandle() {
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRemoteCameraStateUpdate = null;
    ZegoExpressEngine.onRemoteMicStateUpdate = null;
    ZegoExpressEngine.onRemoteSoundLevelUpdate = null;
    ZegoExpressEngine.onCapturedSoundLevelUpdate = null;
    ZegoExpressEngine.onAudioRouteChange = null;
    ZegoExpressEngine.onPlayerVideoSizeChanged = null;
    ZegoExpressEngine.onRoomStateChanged = null;
  }

  void initEventHandle() {
    ZegoExpressEngine.onRoomStreamUpdate = (String roomID,
        ZegoUpdateType updateType,
        List<ZegoStream> streamList,
        Map<String, dynamic> extendedData) {
      ZegoUIKitCore.shared.coreData
          .onRoomStreamUpdate(roomID, updateType, streamList, extendedData);
    };
    ZegoExpressEngine.onRoomUserUpdate =
        (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
      ZegoUIKitCore.shared.coreData
          .onRoomUserUpdate(roomID, updateType, userList);
    };
    ZegoExpressEngine.onRemoteCameraStateUpdate =
        (String streamID, ZegoRemoteDeviceState state) {
      ZegoUIKitCore.shared.coreData.onRemoteCameraStateUpdate(streamID, state);
    };
    ZegoExpressEngine.onRemoteMicStateUpdate =
        (String streamID, ZegoRemoteDeviceState state) {
      ZegoUIKitCore.shared.coreData.onRemoteMicStateUpdate(streamID, state);
    };

    ZegoExpressEngine.onRemoteSoundLevelUpdate =
        (Map<String, double> soundLevels) {
      ZegoUIKitCore.shared.coreData.onRemoteSoundLevelUpdate(soundLevels);
    };
    ZegoExpressEngine.onCapturedSoundLevelUpdate = (double level) {
      ZegoUIKitCore.shared.coreData.onCapturedSoundLevelUpdate(level);
    };

    ZegoExpressEngine.onAudioRouteChange = (ZegoAudioRoute audioRoute) {
      ZegoUIKitCore.shared.coreData.onAudioRouteChange(audioRoute);
    };

    ZegoExpressEngine.onPlayerVideoSizeChanged =
        (String streamID, int width, int height) {
      ZegoUIKitCore.shared.coreData
          .onPlayerVideoSizeChanged(streamID, width, height);
    };

    ZegoExpressEngine.onRoomStateChanged = (String roomID,
        ZegoRoomStateChangedReason reason,
        int errorCode,
        Map<String, dynamic> extendedData) {
      ZegoUIKitCore.shared.coreData
          .onRoomStateChanged(roomID, reason, errorCode, extendedData);
    };

    // coreChat
    ZegoExpressEngine.onIMRecvBarrageMessage =
        (String roomID, List<ZegoBarrageMessageInfo> messageList) {
      ZegoUIKitCore.shared.coreChat.onIMRecvBarrageMessage(roomID, messageList);
    };
  }
}
