part of 'zego_uikit.dart';

mixin ZegoUIKitChatService {
  Stream<List<ZegoUIKitMessage>> createChatMessageListStream() {
    return ZegoUIKitCore.shared.coreChat.streamControllerMessageList.stream;
  }

  void sendBarrageMessage(String message) {
    return ZegoUIKitCore.shared.coreChat.sendBarrageMessage(message);
  }
}
