// Dart imports:
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/service/zego_uikit.dart';
import 'components/components.dart';
import 'live_bottom_bar.dart';
import 'live_config.dart';
import 'live_defines.dart';
import 'live_top_bar.dart';

class ZegoUIKitPrebuiltLive extends StatefulWidget {
  const ZegoUIKitPrebuiltLive({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.liveID,
    required this.userID,
    required this.userName,
    required this.Image,
    required this.config,
    this.tokenServerUrl = '',
  }) : super(key: key);

  /// you need to fill in the appID you obtained from console.zegocloud.com
  final int appID;

  /// You can customize the liveID arbitrarily,
  /// just need to know: users who use the same liveID can talk with each other.
  final String liveID;

  /// for Android/iOS
  /// you need to fill in the appID you obtained from console.zegocloud.com
  final String appSign;

  /// tokenServerUrl is only for web.
  /// If you have to support Web and Android, iOS, then you can use it like this
  /// ```
  ///   ZegoUIKitPrebuiltLiveConfig(
  ///     appID: appID,
  ///     userID: userID,
  ///     userName: userName,
  ///     appSign: kIsWeb ? '' : appSign,
  ///     tokenServerUrl: kIsWeb ? tokenServerUrl：'',
  ///   );
  /// ```
  final String tokenServerUrl;

  /// local user info
  final String userID;
  final String userName;
  final String Image;

  final ZegoUIKitPrebuiltLiveConfig config;

  @override
  State<ZegoUIKitPrebuiltLive> createState() => _ZegoUIKitPrebuiltLiveState();
}

class _ZegoUIKitPrebuiltLiveState extends State<ZegoUIKitPrebuiltLive>
    with SingleTickerProviderStateMixin {
  var layoutModeNotifier =
      ValueNotifier<ZegoLayoutMode>(ZegoLayoutMode.pictureInPicture);

  @override
  void initState() {
    super.initState();

    correctConfigValue();

    ZegoUIKit().getZegoUIKitVersion().then((version) {
      log("ZegoUIKit version: $version");
    });

    ZegoUIKitPrebuiltLiveConfig config = widget.config;
    if (!kIsWeb) {
      assert(widget.appSign.isNotEmpty);
      ZegoUIKit()
        ..login(widget.userID, widget.userName)
        ..init(appID: widget.appID, appSign: widget.appSign)
            .then((value) async {
          // await ZegoUIKit().startEffectsEnv();

          ZegoUIKit()
            ..updateVideoViewMode(config.useVideoViewAspectFill)
            ..turnCameraOn(config.isHost)
            ..turnMicrophoneOn(config.isHost)
            // ..enableBeauty(true)
            ..joinRoom(widget.liveID);
        });
    } else {
      assert(widget.tokenServerUrl.isNotEmpty);
      ZegoUIKit()
        ..login(widget.userID, widget.userName)
        ..init(appID: widget.appID, tokenServerUrl: widget.tokenServerUrl)
            .then((value) async {
          // await ZegoUIKit().startEffectsEnv();

          ZegoUIKit()
            ..updateVideoViewMode(config.useVideoViewAspectFill)
            // ..enableBeauty(true)
            ..turnCameraOn(config.isHost)
            ..turnMicrophoneOn(config.isHost)
            ..setAudioOutputToSpeaker(!config.isHost);

          getToken(widget.userID).then((token) {
            assert(token.isNotEmpty);
            ZegoUIKit().joinRoom(widget.liveID, token: token);
          });
        });
    }
  }

  @override
  void dispose() async {
    super.dispose();

    await ZegoUIKit().leaveRoom();
    // await ZegoUIKit().stopEffectsEnv();
    // await ZegoUIKit().uninit();
  }

  @override
  Widget build(BuildContext context) {
    widget.config.onEndLiveConfirming ??= onQuitConfirming;
    return ScreenUtilInit(
      designSize: const Size(360, 740),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              return await widget.config.onEndLiveConfirming!(context) ?? false;
            },
            child: clickListener(
              child: Stack(
                children: [
                  audioVideoContainer(),
                  topBar(),
                  bottomBar(),
                  messageList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void correctConfigValue() {
    if (widget.config.menuBarButtonsMaxCount > 5) {
      widget.config.menuBarButtonsMaxCount = 5;
      debugPrint('menu bar buttons limited count\'s value  is exceeding the '
          'maximum limit');
    }
  }

  Widget clickListener({required Widget child}) {
    return GestureDetector(
      onTap: () {
        /// listen only click event in empty space
      },
      child: Listener(
        ///  listen for all click events in current view, include the click
        ///  receivers(such as button...), but only listen
        onPointerDown: (e) {},
        child: AbsorbPointer(
          absorbing: false,
          child: child,
        ),
      ),
    );
  }

  Widget audioVideoContainer() {
    return ValueListenableBuilder<ZegoLayoutMode>(
        valueListenable: layoutModeNotifier,
        builder: (context, zegoLayoutMode, _) {
          return ZegoAudioVideoContainer(
            layout: widget.config.layout!,
            backgroundBuilder: audioVideoViewBackground,
            foregroundBuilder: audioVideoViewForeground,
          );
        });
  }

  /// Get your token from tokenServer
  Future<String> getToken(String userID) async {
    final response = await http
        .get(Uri.parse('${widget.tokenServerUrl}/access_token?uid=$userID'));
    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['token'];
    } else {
      return "";
    }
  }

  Future<bool> onQuitConfirming(BuildContext context) async {
    if (widget.config.endLiveConfirmInfo == null) {
      return true;
    }

    return await showAlertDialog(
      context,
      widget.config.endLiveConfirmInfo!.title,
      widget.config.endLiveConfirmInfo!.message,
      [
        ElevatedButton(
          child: Text(
            widget.config.endLiveConfirmInfo!.cancelButtonName,
            style: TextStyle(fontSize: 26.r, color: const Color(0xff0055FF)),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          // style: ElevatedButton.styleFrom(primary: Colors.white),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ElevatedButton(
          child: Text(
            widget.config.endLiveConfirmInfo!.confirmButtonName,
            style: TextStyle(fontSize: 26.r, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xff0055FF)),
          ),
        ),
      ],
    );
  }

  Widget audioVideoViewForeground(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    return Stack(
      children: [
        widget.config.foregroundBuilder?.call(context, size, user, extraInfo) ??
            Container(color: Colors.transparent),
      ],
    );
  }

  Widget audioVideoViewBackground(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    var screenSize = MediaQuery.of(context).size;
    var isSmallView = (screenSize.width - 500).abs() > 1;
    return Stack(
      children: [
        Container(
            color: isSmallView
                ? const Color(0xff333437)
                : const Color(0xff4A4B4D)),
        widget.config.backgroundBuilder?.call(context, size, user, extraInfo) ??
            Container(color: Colors.transparent),
        ZegoAvatar(
          avatarSize: isSmallView ? Size(50.w, 50.h) : Size(258.r, 258.r),
          user: user,
          showAvatar: widget.config.showAvatarInAudioMode,
          showSoundLevel: widget.config.showSoundWavesInAudioMode,
          avatarBuilder: widget.config.avatarBuilder,
          soundLevelSize: size,
        ),
      ],
    );
  }

  Widget topBar() => Positioned(
        left: 0,
        right: 0,
        top: 64.r,
        child: ZegoUIKitPrebuiltLiveTopBar(config: widget.config),
      );

  Widget bottomBar() => Positioned(
        left: 0,
        right: 0,
        bottom: 32.r,
        child: ZegoUIKitPrebuiltLiveBottomBar(
          buttonSize: zegoLiveButtonSize,
          config: widget.config,
        ),
      );

  Widget messageList() => Positioned(
        left: 32.r,
        bottom: 124.r,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size(540.r, 400.r)),
          child: const ZegoLiveChatMessageList(),
        ),
      );
}
