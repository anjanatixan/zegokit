// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/audio_video/audio_video_view.dart';
import 'package:zego_uikit/service/zego_uikit.dart';
import 'layout.dart';

/// layout config of picture in picture
class ZegoLayoutPictureInPictureConfig extends ZegoLayout {
  /// whether to hide the local View when the local camera is closed
  final bool showMyViewWithVideoOnly;

  /// small video view is draggable if set true
  final bool isSmallViewDraggable;

  ///  Whether you can switch view's position by clicking on the small view
  final bool switchLargeOrSmallViewByClick;

  /// default position of small video view
  final ZegoViewPosition smallViewPosition;

  /// self AudioVideoView use small or big view
  /// usually set it to true in live scene, set it to false in call scene
  final bool selfUseSmallAudioVideoView;

  const ZegoLayoutPictureInPictureConfig({
    this.showMyViewWithVideoOnly = false,
    this.isSmallViewDraggable = true,
    this.switchLargeOrSmallViewByClick = true,
    this.smallViewPosition = ZegoViewPosition.topRight,
    this.selfUseSmallAudioVideoView = true,
  }) : super.internal();
}

/// picture in picture layout
class ZegoLayoutPictureInPicture extends StatefulWidget {
  const ZegoLayoutPictureInPicture({
    Key? key,
    required this.localUser,
    required this.remoteUser,
    required this.layoutConfig,
    this.foregroundBuilder,
    this.backgroundBuilder,
  }) : super(key: key);

  final ZegoUIKitUser localUser;
  final ZegoUIKitUser? remoteUser;
  final ZegoLayoutPictureInPictureConfig layoutConfig;

  final AudioVideoViewForegroundBuilder? foregroundBuilder;
  final AudioVideoViewBackgroundBuilder? backgroundBuilder;

  @override
  State<ZegoLayoutPictureInPicture> createState() =>
      _ZegoLayoutPictureInPictureState();
}

class _ZegoLayoutPictureInPictureState
    extends State<ZegoLayoutPictureInPicture> {
  var userSwitchedNotifier = ValueNotifier<bool>(false);
  late ZegoViewPosition currentPosition;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.layoutConfig.smallViewPosition;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: userSwitchedNotifier,
      builder: (context, isUserSwitched, _) {
        var largeViewUser = isUserSwitched
            ? (widget.layoutConfig.selfUseSmallAudioVideoView
                ? widget.localUser
                : widget.remoteUser)
            : (widget.layoutConfig.selfUseSmallAudioVideoView
                ? widget.remoteUser
                : widget.localUser);
        var smallViewUser = isUserSwitched
            ? (widget.layoutConfig.selfUseSmallAudioVideoView
                ? widget.remoteUser
                : widget.localUser)
            : (widget.layoutConfig.selfUseSmallAudioVideoView
                ? widget.localUser
                : widget.remoteUser);

        return Stack(
          children: [
            getUserView(largeViewUser),
            if (smallViewUser != null ||
                widget.layoutConfig.selfUseSmallAudioVideoView)
              getUserView(smallViewUser, wrapper: wrapper),
          ],
        );
      },
    );
  }

  Widget getUserView(ZegoUIKitUser? user,
      {Widget Function(ZegoUIKitUser? user, Widget child)? wrapper}) {
    Widget audioVideoView = ZegoAudioVideoView(
      key: ValueKey(user?.id),
      user: user,
      backgroundBuilder: widget.backgroundBuilder,
      foregroundBuilder: widget.foregroundBuilder,
    );

    bool needCheckUserViewHideLogic = (user != null) &&
        (widget.layoutConfig.showMyViewWithVideoOnly) &&
        (user.id == widget.localUser.id);

    if (needCheckUserViewHideLogic) {
      return ValueListenableBuilder<bool>(
        valueListenable:
            ZegoUIKit().getCameraStateNotifier(widget.localUser.id),
        builder: (context, localUserCameraEnabled, _) {
          if (localUserCameraEnabled) {
            return wrapper?.call(user, audioVideoView) ?? audioVideoView;
          } else {
            return const SizedBox();
          }
        },
      );
    } else {
      return wrapper?.call(user, audioVideoView) ?? audioVideoView;
    }
  }

  Widget wrapper(ZegoUIKitUser? user, Widget child) {
    return calculatePosition(
      child: makeDraggable(
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (widget.layoutConfig.switchLargeOrSmallViewByClick) {
                userSwitchedNotifier.value = !userSwitchedNotifier.value;
              }
            });
          },
          child: AbsorbPointer(
            child: circleBorder(
              child: calculateSize(
                user: user,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// calculates smallView's size based on current screen
  Widget calculateSize({required ZegoUIKitUser? user, required Widget child}) {
    var portraitBaseSize = Size(338.0.h, 190.0.w); //  vertical
    var landscapeBaseSize = Size(190.0.w, 338.0.h); //  vertical

    if (user == null) {
      Size defaultSize = Size(
          landscapeBaseSize.height * (9.0 / 16.0), landscapeBaseSize.height);

      return SizedBox.fromSize(size: defaultSize, child: child);
    } else {
      return ValueListenableBuilder<Size>(
        valueListenable: ZegoUIKit().getVideoSizeNotifier(user.id),
        builder: (context, Size size, _) {
          late double userWidth, userHeight;
          if (size.width > size.height) {
            userWidth = portraitBaseSize.width;
            userHeight = portraitBaseSize.width * (9.0 / 16.0);
          } else {
            userWidth = landscapeBaseSize.height * (9.0 / 16.0);
            userHeight = landscapeBaseSize.height;
          }

          return SizedBox(width: 0.w, height: 0.h, child: child);
        },
      );
    }
  }

  Widget circleBorder({required Widget child}) {
    BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: const Color(0xffA4A4A4), width: 1),
      borderRadius: BorderRadius.all(Radius.circular(18.0.w)), //  todo
    );

    return Container(
      decoration: decoration,
      child: PhysicalModel(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18.0.w)),
        clipBehavior: Clip.antiAlias,
        elevation: 6.0,
        shadowColor: Colors.grey,
        child: child,
      ),
    );
  }

  /// position container, calculates the coordinates based on current position
  Widget calculatePosition({required Widget child}) {
    const double paddingSpace = 20;

    double? left, top, right, bottom;
    switch (currentPosition) {
      case ZegoViewPosition.topLeft:
        left = paddingSpace;
        top = paddingSpace + 30;
        break;
      case ZegoViewPosition.topRight:
        right = paddingSpace;
        top = paddingSpace + 30;
        break;
      case ZegoViewPosition.bottomLeft:
        left = paddingSpace;
        bottom = paddingSpace + 10;
        break;
      case ZegoViewPosition.bottomRight:
        right = paddingSpace;
        bottom = paddingSpace + 10;
        break;
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: child,
    );
  }

  Widget makeDraggable({required Widget child}) {
    if (!widget.layoutConfig.isSmallViewDraggable) {
      /// not support
      return child;
    }

    return Draggable(
      feedback: child,
      childWhenDragging: Container(),
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        /// drag finished, update current position
        var size = MediaQuery.of(context).size;
        late ZegoViewPosition targetPosition;
        var centerPos = Offset(size.width / 2, size.height / 2);
        if (offset.dx < centerPos.dx && offset.dy < centerPos.dy) {
          targetPosition = ZegoViewPosition.topLeft;
        } else if (offset.dx >= centerPos.dx && offset.dy < centerPos.dy) {
          targetPosition = ZegoViewPosition.topRight;
        } else if (offset.dx < centerPos.dx && offset.dy >= centerPos.dy) {
          targetPosition = ZegoViewPosition.bottomLeft;
        } else {
          targetPosition = ZegoViewPosition.bottomRight;
        }

        if (targetPosition != currentPosition) {
          setState(() {
            currentPosition = targetPosition;
          });
        }
      },
      child: child,
    );
  }
}
