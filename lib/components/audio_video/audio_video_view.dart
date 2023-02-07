// Dart imports:
import 'dart:core';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:native_device_orientation/native_device_orientation.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';
import 'package:zego_uikit/service/zego_uikit.dart';

/// type of audio video view foreground builder
typedef AudioVideoViewForegroundBuilder = Widget Function(
    BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo);

/// type of audio video view background builder
typedef AudioVideoViewBackgroundBuilder = Widget Function(
    BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo);

/// display user audio and video information,
/// and z order of widget(from bottom to top) is:
/// 1. background view
/// 2. video view
/// 3. foreground view
class ZegoAudioVideoView extends StatefulWidget {
  const ZegoAudioVideoView({
    Key? key,
    required this.user,
    this.backgroundBuilder,
    this.foregroundBuilder,
  }) : super(key: key);

  final ZegoUIKitUser? user;

  /// foreground builder, you can display something you want on top of the view,
  /// foreground will always show
  final AudioVideoViewForegroundBuilder? foregroundBuilder;

  /// background builder, you can display something when user close camera
  final AudioVideoViewBackgroundBuilder? backgroundBuilder;

  @override
  State<ZegoAudioVideoView> createState() => _ZegoAudioVideoViewState();
}

class _ZegoAudioVideoViewState extends State<ZegoAudioVideoView> {
  final userViewKey = GlobalKey<_ZegoAudioVideoViewState>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      background(),
      videoView(),
      foreground(),
    ]);
  }

  Widget videoView() {
    if (widget.user == null) {
      return Container(color: Colors.transparent);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: ZegoUIKit().getCameraStateNotifier(widget.user!.id),
      builder: (context, isCameraOn, _) {
        if (!isCameraOn) {
          /// hide video view when use close camera
          return Container(color: Colors.transparent);
        }

        return SizedBox.expand(
          key: userViewKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ValueListenableBuilder<Widget?>(
                valueListenable:
                    ZegoUIKit().getAudioVideoViewNotifier(widget.user!.id),
                builder: (context, userView, _) {
                  if (userView == null) {
                    /// hide video view when use not found
                    return Container(color: Colors.transparent);
                  }

                  return StreamBuilder(
                    stream: NativeDeviceOrientationCommunicator()
                        .onOrientationChanged(),
                    builder: (context,
                        AsyncSnapshot<NativeDeviceOrientation> asyncResult) {
                      if (asyncResult.hasData) {
                        /// Do not update ui when ui is building !!!
                        /// use postFrameCallback to update videoSize
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ///  notify sdk to update video render orientation
                          ZegoUIKit().updateAppOrientation(
                            deviceOrientationMap(asyncResult.data!),
                          );
                        });
                      }

                      ///  notify sdk to update texture render size
                      ZegoUIKit().updateTextureRendererSize(
                        widget.user!.id,
                        constraints.maxWidth.toInt(),
                        constraints.maxHeight.toInt(),
                      );
                      return userView;
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget background() {
    if (widget.backgroundBuilder != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return widget.backgroundBuilder!.call(
            context,
            Size(constraints.maxWidth, constraints.maxHeight),
            widget.user,
            {},
          );
        },
      );
    }

    return Container(color: Colors.transparent);
  }

  Widget foreground() {
    if (widget.foregroundBuilder != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return widget.foregroundBuilder!.call(
            context,
            Size(constraints.maxWidth, constraints.maxHeight),
            widget.user,
            {},
          );
        },
      );
    }

    return Container(color: Colors.transparent);
  }
}
