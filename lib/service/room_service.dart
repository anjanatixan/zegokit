part of 'zego_uikit.dart';

mixin ZegoUIKitRoomService {
  Future<ZegoRoomLoginResult> joinRoom(String roomID,
      {String token = ''}) async {
    return await ZegoUIKitCore.shared.joinRoom(roomID, token: token);
  }

  Future<ZegoRoomLogoutResult> leaveRoom() async {
    return await ZegoUIKitCore.shared.leaveRoom();
  }

  // todo add room extra info
  ZegoUIKitRoom getRoom() {
    return ZegoUIKitCore.shared.coreData.room.toUIKitRoom();
  }

  // equal to native's onRoomStateChanged
  Stream<ZegoUIKitRoomState> createRoomStateStream() {
    return ZegoUIKitCore.shared.coreData.room.state.stream;
  }
}
