part of 'zego_uikit_core.dart';

enum ZegoStreamType {
  main,
  media,
  screenSharing,
}

// user
class ZegoUIKitCoreUser {
  String id = '';
  String name = '';
  String streamID = '';

  ValueNotifier<bool> camera = ValueNotifier<bool>(false);
  ValueNotifier<bool> microphone = ValueNotifier<bool>(false);
  StreamController<double> soundLevel = StreamController<double>.broadcast();

  int viewID = -1;
  ValueNotifier<Widget?> view = ValueNotifier<Widget?>(null);
  ValueNotifier<Size> viewSize = ValueNotifier<Size>(const Size(360, 640));
  int textureWidth = -1;
  int textureHeight = -1;

  ValueNotifier<ZegoStreamQualityLevel> network =
      ValueNotifier<ZegoStreamQualityLevel>(ZegoStreamQualityLevel.Excellent);

  // only for local
  ValueNotifier<bool> isFrontFacing = ValueNotifier<bool>(true);
  ValueNotifier<ZegoAudioRoute> audioRoute =
      ValueNotifier<ZegoAudioRoute>(ZegoAudioRoute.Receiver);
  ZegoAudioRoute lastAudioRoute = ZegoAudioRoute.Receiver;

  ZegoUIKitCoreUser(this.id, this.name);

  ZegoUIKitCoreUser.localDefault() {
    camera.value = true;
    microphone.value = true;
  }

  ZegoUIKitCoreUser.fromZego(ZegoUser user) : this(user.userID, user.userName);

  generateStreamID(String roomID, ZegoStreamType type) {
    streamID = '${roomID}_${id}_${type.name}';
  }

  ZegoUIKitUser toZegoUikitUser() => ZegoUIKitUser(id: id, name: name);

  ZegoUser toZegoUser() => ZegoUser(id, name);
}

// room

class ZegoUIKitRoomState {
  ZegoRoomStateChangedReason reason;
  int errorCode;
  Map<String, dynamic> extendedData;

  ZegoUIKitRoomState(this.reason, this.errorCode, this.extendedData);
}

class ZegoUIKitCoreRoom {
  String id = '';
  StreamController<ZegoUIKitRoomState> state =
      StreamController<ZegoUIKitRoomState>.broadcast();

  ZegoUIKitCoreRoom(this.id);

  void clear() {
    id = '';
  }

  ZegoUIKitRoom toUIKitRoom() {
    return ZegoUIKitRoom(id: id);
  }
}

// video config
class ZegoUIKitVideoConfig {
  ZegoVideoConfigPreset resolution;
  DeviceOrientation orientation;
  bool useVideoViewAspectFill;

  ZegoUIKitVideoConfig({
    this.resolution = ZegoVideoConfigPreset.Preset360P,
    this.orientation = DeviceOrientation.portraitUp,
    this.useVideoViewAspectFill = false,
  });

  bool needUpdateOrientation(ZegoUIKitVideoConfig newConfig) {
    return orientation != newConfig.orientation;
  }

  bool needUpdateVideoConfig(ZegoUIKitVideoConfig newConfig) {
    return (resolution != newConfig.resolution) ||
        (orientation != newConfig.orientation);
  }

  ZegoVideoConfig toZegoVideoConfig() {
    ZegoVideoConfig config = ZegoVideoConfig.preset(resolution);
    if (orientation == DeviceOrientation.landscapeLeft ||
        orientation == DeviceOrientation.landscapeRight) {
      int tmp = config.captureHeight;
      config.captureHeight = config.captureWidth;
      config.captureWidth = tmp;
      tmp = config.encodeHeight;
      config.encodeHeight = config.encodeWidth;
      config.encodeWidth = tmp;
    }
    return config;
  }

  ZegoUIKitVideoConfig copyWith({
    ZegoVideoConfigPreset? resolution,
    DeviceOrientation? orientation,
    bool? useVideoViewAspectFill,
  }) =>
      ZegoUIKitVideoConfig(
        resolution: resolution ?? this.resolution,
        orientation: orientation ?? this.orientation,
        useVideoViewAspectFill:
            useVideoViewAspectFill ?? this.useVideoViewAspectFill,
      );
}

class ZegoUIKitAdvancedConfigKey {
  static const String videoViewMode = 'videoViewMode';
}
