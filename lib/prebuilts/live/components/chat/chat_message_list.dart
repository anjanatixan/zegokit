// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/service/zego_uikit.dart';
import 'chat_message_card.dart';

class ZegoLiveChatMessageList extends StatefulWidget {
  const ZegoLiveChatMessageList({
    Key? key,
  }) : super(key: key);

  @override
  State<ZegoLiveChatMessageList> createState() =>
      _ZegoLiveChatMessageListState();
}

class _ZegoLiveChatMessageListState extends State<ZegoLiveChatMessageList> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: ZegoUIKit().createChatMessageListStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ZegoUIKitMessage> messageList =
                snapshot.data as List<ZegoUIKitMessage>;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
            return ListView.builder(

              shrinkWrap: true,
              controller: _scrollController,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return ZegoLiveChatMessageListMessageCard(
                  // todo  how to show host?
                  prefix:
                      messageList[index].sender.id == ZegoUIKit().getUser().id
                          ? 'Me'
                          : null,
                  user: messageList[index].sender,
                  message: messageList[index].message,
                );
              },
            );
          }
          return const SizedBox();
        });
  }
}
