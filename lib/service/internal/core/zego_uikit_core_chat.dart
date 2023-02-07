part of 'zego_uikit_core.dart';

class ZegoUIKitMessage {
  ZegoUIKitUser sender;
  String message;
  int timestamp; // Message send time, UNIX timestamp, in milliseconds.
  Future<ZegoIMSendBarrageMessageResult>? state;

  ZegoUIKitMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    this.state,
  });

  ZegoUIKitMessage.fromBarrageMessage(ZegoBarrageMessageInfo message)
      : this(
          sender: ZegoUIKitUser.fromZego(message.fromUser),
          message: message.message,
          timestamp: message.sendTime,
        );
}

class ZegoUIKitCoreChat {
  final List<ZegoUIKitMessage> _messageList = []; // uid:user

  StreamController<List<ZegoUIKitMessage>> streamControllerMessageList =
      StreamController<List<ZegoUIKitMessage>>.broadcast();

  void onIMRecvBarrageMessage(
      String roomID, List<ZegoBarrageMessageInfo> messageList) {
    for (ZegoBarrageMessageInfo message in messageList) {
      _messageList.add(ZegoUIKitMessage.fromBarrageMessage(message));
    }

    if (_messageList.length > 500) {
      _messageList.removeRange(0, _messageList.length - 500);
    }

    streamControllerMessageList.add(_messageList);
  }

  void clear() {
    _messageList.clear();
    streamControllerMessageList.add(_messageList);
  }

  void sendBarrageMessage(String message) {
    String roomID = ZegoUIKitCore.shared.coreData.room.id;

    _messageList.add(
      ZegoUIKitMessage(
        sender: ZegoUIKitCore.shared.coreData.localUser.toZegoUikitUser(),
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        state: ZegoExpressEngine.instance.sendBarrageMessage(roomID, message),
      ),
    );
    streamControllerMessageList.add(_messageList);
  }
}
