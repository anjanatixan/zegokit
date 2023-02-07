// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/components/audio_video/audio_video_view.dart';
import 'package:zego_uikit/service/zego_uikit.dart';
import 'layout.dart';
import 'layout_picture_in_picture.dart';

/// container of audio video view,
/// it will layout views by layout mode and config
class ZegoAudioVideoContainer extends StatefulWidget {
  const ZegoAudioVideoContainer({
    Key? key,
    required this.layout,
    this.foregroundBuilder,
    this.backgroundBuilder,
  }) : super(key: key);

  final ZegoLayout layout;

  /// foreground builder of audio video view
  final AudioVideoViewForegroundBuilder? foregroundBuilder;

  /// background builder of audio video view
  final AudioVideoViewBackgroundBuilder? backgroundBuilder;

  @override
  State<ZegoAudioVideoContainer> createState() =>
      _ZegoAudioVideoContainerState();
}

class _ZegoAudioVideoContainerState extends State<ZegoAudioVideoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ZegoUIKitUser>>(
      stream: ZegoUIKit().createAudioVideoListStream(),
      builder: (context, snapshot) {
        List<ZegoUIKitUser> userList = snapshot.data ?? [];

        if (widget.layout is ZegoLayoutPictureInPictureConfig) {
          return pictureInPictureLayout(userList);
        } else {
          assert(false, "Unimplemented layout");
          return Container();
        }
      },
    );
  }

  /// picture in picture
  Widget pictureInPictureLayout(List<ZegoUIKitUser> userList) {
    /// the last user entered is used as the remote user
    var remoteUser = userList.isEmpty ? null : userList.last;

    return ZegoLayoutPictureInPicture(
      layoutConfig: widget.layout as ZegoLayoutPictureInPictureConfig,
      backgroundBuilder: widget.backgroundBuilder,
      foregroundBuilder: widget.foregroundBuilder,
      localUser: ZegoUIKit().getUser(),
      remoteUser: remoteUser,
    );
  }
}
