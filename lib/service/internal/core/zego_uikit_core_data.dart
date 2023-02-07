part of 'zego_uikit_core.dart';

class ZegoUIKitCoreData {
  ZegoUIKitCoreUser localUser = ZegoUIKitCoreUser.localDefault();

  final Map<String, ZegoUIKitCoreUser> remoteUser = {}; // uid:user
  final Map<String, String> streamDic = {}; // stream_id:

  ZegoUIKitCoreRoom room = ZegoUIKitCoreRoom('');

  var streamControllerUserList =
      StreamController<Map<String, ZegoUIKitCoreUser>>.broadcast();

  ZegoUIKitVideoConfig videoConfig = ZegoUIKitVideoConfig();

  void clearStream() {
    remoteUser.forEach((_, user) {
      if (user.streamID.isNotEmpty) {
        stopPlayingStream(user.streamID);
      }
      if (user.viewID != -1) {
        ZegoExpressEngine.instance.destroyTextureRenderer(user.viewID);
        user.viewID = -1;
      }
    });
    if (localUser.streamID.isNotEmpty) {
      stopPublishingStream();
    }
    if (localUser.viewID != -1) {
      ZegoExpressEngine.instance.destroyTextureRenderer(localUser.viewID);
      localUser.viewID = -1;
    }
    localUser.view.value = null;
    localUser.textureWidth = -1;
    localUser.textureHeight = -1;
  }

  void clear() {
    clearStream();
    remoteUser.clear();
    streamDic.clear();
    room.clear();
  }

  ZegoUIKitCoreUser login(String id, String name) {
    localUser.id = id;
    localUser.name = name;
    return localUser;
  }

  void logout() {
    localUser.id = '';
    localUser.name = '';
  }

  void setRoom(String roomID) {
    room = ZegoUIKitCoreRoom(roomID);
  }

  Future<void> startPreview() async {
    Future<void> _startPreview() async {
      assert(localUser.viewID != -1);
      ZegoCanvas previewCanvas = ZegoCanvas(
        localUser.viewID,
        viewMode: videoConfig.useVideoViewAspectFill
            ? ZegoViewMode.AspectFill
            : ZegoViewMode.AspectFit,
      );
      if (kIsWeb) {
        ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
      } else {
        ZegoExpressEngine.instance
          ..enableCamera(localUser.camera.value)
          ..startPreview(canvas: previewCanvas);
      }
    }

    createLocalUserVideoView(_startPreview);
  }

  Future<void> stopPreview() async {
    // destroy Texture
    if (localUser.viewID != -1) {
      ZegoExpressEngine.instance.destroyTextureRenderer(localUser.viewID);
      localUser.viewID = -1;
    }

    ZegoExpressEngine.instance.stopPreview();
  }

  Future<void> startPublishingStream() async {
    if (localUser.streamID.isNotEmpty) {
      return;
    }
    localUser.generateStreamID(room.id, ZegoStreamType.main);

    Future<void> _startPublishStream() async {
      assert(localUser.viewID != -1);
      ZegoCanvas previewCanvas = ZegoCanvas(
        localUser.viewID,
        viewMode: videoConfig.useVideoViewAspectFill
            ? ZegoViewMode.AspectFill
            : ZegoViewMode.AspectFit,
      );
      if (kIsWeb) {
        ZegoExpressEngine.instance
          ..mutePublishStreamVideo(!localUser.camera.value)
          ..mutePublishStreamAudio(!!localUser.microphone.value)
          ..startPreview(canvas: previewCanvas)
          ..startPublishingStream(localUser.streamID);
      } else {
        ZegoExpressEngine.instance
          ..enableCamera(localUser.camera.value)
          ..muteMicrophone(!localUser.microphone.value)
          ..startPreview(canvas: previewCanvas)
          ..startPublishingStream(localUser.streamID);
      }
    }

    createLocalUserVideoView(_startPublishStream);
  }

  Future<void> stopPublishingStream() async {
    assert(localUser.streamID.isNotEmpty);
    localUser.streamID = "";

    // destroy Texture
    if (localUser.viewID != -1) {
      ZegoExpressEngine.instance.destroyTextureRenderer(localUser.viewID);
      localUser.viewID = -1;
    }

    ZegoExpressEngine.instance
      ..stopPreview()
      ..stopPublishingStream();
  }

  Future<void> startPublishOrNot() async {
    if (room.id.isEmpty) {
      return;
    }
    if (localUser.camera.value || localUser.microphone.value) {
      startPublishingStream();
    } else {
      if (localUser.streamID.isNotEmpty) {
        stopPublishingStream();
      }
    }
  }

  void createLocalUserVideoView(VoidCallback onViewCreated) {
    if (kIsWeb) {
      if (-1 == localUser.viewID) {
        localUser.view.value =
            ZegoExpressEngine.instance.createPlatformView((viewID) {
          localUser.viewID = viewID;
          onViewCreated();
        });
      } else {
        //  user view had created
        onViewCreated();
      }
    } else {
      if (-1 == localUser.viewID) {
        ZegoExpressEngine.instance
            .createTextureRenderer(360, 640)
            .then((textureId) {
          localUser.viewID = textureId;
          localUser.view.value =
              Texture(key: ValueKey(localUser.id), textureId: textureId);
          onViewCreated();
        });
      } else {
        //  user view had created
        onViewCreated();
      }
    }
  }

  ZegoUIKitCoreUser removeUser(String uid) {
    ZegoUIKitCoreUser user = remoteUser.remove(uid)!;
    if (user.streamID.isNotEmpty) {
      stopPlayingStream(user.streamID);
    }
    return user;
  }

  Future<void> startPlayingStream(ZegoStream stream) async {
    streamDic[stream.streamID] = stream.user.userID;
    if (remoteUser[stream.user.userID] == null) {
      remoteUser[stream.user.userID] = ZegoUIKitCoreUser.fromZego(stream.user);
    }
    remoteUser[stream.user.userID]!.streamID = stream.streamID;

    if (kIsWeb) {
      remoteUser[stream.user.userID]!.view.value =
          ZegoExpressEngine.instance.createPlatformView((viewID) {
        remoteUser[stream.user.userID]!.viewID = viewID;
        ZegoCanvas canvas = ZegoCanvas(
          viewID,
          viewMode: videoConfig.useVideoViewAspectFill
              ? ZegoViewMode.AspectFill
              : ZegoViewMode.AspectFit,
        );
        ZegoExpressEngine.instance
            .startPlayingStream(stream.streamID, canvas: canvas);
      });
    } else {
      await ZegoExpressEngine.instance
          .createTextureRenderer(360, 640)
          .then((textureId) {
        remoteUser[stream.user.userID]!.view.value =
            Texture(key: ValueKey(stream.user.userID), textureId: textureId);
        remoteUser[stream.user.userID]!.viewID = textureId;
        ZegoCanvas canvas = ZegoCanvas(
          textureId,
          viewMode: videoConfig.useVideoViewAspectFill
              ? ZegoViewMode.AspectFill
              : ZegoViewMode.AspectFit,
        );
        ZegoExpressEngine.instance
            .startPlayingStream(stream.streamID, canvas: canvas);
      });
    }
  }

  void stopPlayingStream(String streamID) {
    assert(streamID.isNotEmpty);
    // stop playing stream
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    ZegoUIKitCoreUser user = remoteUser[streamDic[streamID]!]!;
    assert(user.streamID == streamID);
    user.streamID = "";
    user.camera.value = false;
    user.microphone.value = false;
    user.soundLevel.add(0);

    // destroy Texture
    if (user.viewID != -1) {
      ZegoExpressEngine.instance.destroyTextureRenderer(user.viewID);
      user.viewID = -1;
    }

    // clear streamID
    streamDic.remove(user.streamID);
  }

  Future<void> onRoomStreamUpdate(String roomID, ZegoUpdateType updateType,
      List<ZegoStream> streamList, Map<String, dynamic> extendedData) async {
    if (updateType == ZegoUpdateType.Add) {
      for (final stream in streamList) {
        await startPlayingStream(stream);
      }
    } else {
      for (final stream in streamList) {
        stopPlayingStream(stream.streamID);
      }
    }
    streamControllerUserList.add(remoteUser);
  }

  void onRoomUserUpdate(
      String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
    if (updateType == ZegoUpdateType.Add) {
      for (final user in userList) {
        if (remoteUser.containsKey(user.userID)) {
          continue;
        }
        remoteUser[user.userID] = ZegoUIKitCoreUser.fromZego(user);
      }
    } else {
      for (final user in userList) {
        removeUser(user.userID);
      }
    }

    streamControllerUserList.add(remoteUser);
  }

  void onRemoteCameraStateUpdate(String streamID, ZegoRemoteDeviceState state) {
    ZegoUIKitCoreUser user = remoteUser[streamDic[streamID]!]!;
    switch (state) {
      case ZegoRemoteDeviceState.Open:
        user.camera.value = true;
        break;
      case ZegoRemoteDeviceState.Disable:
        user.camera.value = false;
        break;
      case ZegoRemoteDeviceState.Mute:
        user.camera.value = false;
        break;
      default:
        user.camera.value = false;
    }
  }

  void onRemoteMicStateUpdate(String streamID, ZegoRemoteDeviceState state) {
    ZegoUIKitCoreUser user = remoteUser[streamDic[streamID]!]!;
    switch (state) {
      case ZegoRemoteDeviceState.Open:
        user.microphone.value = true;
        break;
      default:
        user.microphone.value = false;
        user.soundLevel.add(0);
    }
  }

  void onRemoteSoundLevelUpdate(Map<String, double> soundLevels) {
    soundLevels.forEach((key, value) {
      ZegoUIKitCoreUser user = remoteUser[streamDic[key]!]!;
      user.soundLevel.add(value);
    });
  }

  void onCapturedSoundLevelUpdate(double level) {
    localUser.soundLevel.add(level);
  }

  void onAudioRouteChange(ZegoAudioRoute audioRoute) {
    localUser.audioRoute.value = audioRoute;
  }

  void onPlayerVideoSizeChanged(String streamID, int width, int height) {
    ZegoUIKitCoreUser user = remoteUser[streamDic[streamID]!]!;
    log(" onPlayerVideoSizeChanged streamID: $streamID width: $width height: $height");
    Size size = Size(width.toDouble(), height.toDouble());
    if (user.viewSize.value != size) {
      user.viewSize.value = size;
    }
  }

  void onRoomStateChanged(String roomID, ZegoRoomStateChangedReason reason,
      int errorCode, Map<String, dynamic> extendedData) {
    log(" onRoomStateChanged roomID: $roomID, reason: $reason, errorCode: $errorCode, extendedData: $extendedData");
  }
}
