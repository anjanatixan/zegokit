// Dart imports:
import 'dart:async';
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
import 'call_config.dart';
import 'call_menu_bar.dart';
import 'components/components.dart';

class ZegoUIKitPrebuiltCall extends StatefulWidget {
  const ZegoUIKitPrebuiltCall({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.callID,
    required this.userID,
    required this.userName,
    this.tokenServerUrl = '',
    required this.config,
  }) : super(key: key);

  /// you need to fill in the appID you obtained from console.zegocloud.com
  final int appID;

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  /// for Android/iOS
  /// you need to fill in the appID you obtained from console.zegocloud.com
  final String appSign;

  /// tokenServerUrl is only for web.
  /// If you have to support Web and Android, iOS, then you can use it like this
  /// ```
  ///   ZegoUIKitPrebuiltCallConfig(
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

  final ZegoUIKitPrebuiltCallConfig config;

  @override
  State<ZegoUIKitPrebuiltCall> createState() => _ZegoUIKitPrebuiltCallState();
}

class _ZegoUIKitPrebuiltCallState extends State<ZegoUIKitPrebuiltCall>
    with SingleTickerProviderStateMixin {
  var layoutModeNotifier =
      ValueNotifier<ZegoLayoutMode>(ZegoLayoutMode.pictureInPicture);

  var menuBarVisibilityNotifier = ValueNotifier<bool>(true);
  var menuBarRestartHideTimerNotifier = ValueNotifier<int>(0);

  StreamSubscription<List<ZegoUIKitUser>>? userListStreamSubscription;

  @override
  void initState() {
    super.initState();

    correctConfigValue();

    ZegoUIKit().getZegoUIKitVersion().then((version) {
      log("ZegoUIKit version: $version");
    });

    ZegoUIKitPrebuiltCallConfig config = widget.config;
    if (!kIsWeb) {
      assert(widget.appSign.isNotEmpty);
      ZegoUIKit()
        ..login(widget.userID, widget.userName)
        ..init(
          appID: widget.appID,
          appSign: widget.appSign,
        ).then((value) {
          ZegoUIKit()
            ..turnCameraOn(config.turnOnCameraWhenJoining)
            ..turnMicrophoneOn(config.turnOnMicrophoneWhenJoining)
            ..setAudioOutputToSpeaker(config.useSpeakerWhenJoining)
            ..joinRoom(widget.callID);
        });
    } else {
      assert(widget.tokenServerUrl.isNotEmpty);
      ZegoUIKit()
        ..login(widget.userID, widget.userName)
        ..init(
          appID: widget.appID,
          tokenServerUrl: widget.tokenServerUrl,
        ).then((value) {
          ZegoUIKit()
            ..turnCameraOn(config.turnOnCameraWhenJoining)
            ..turnMicrophoneOn(config.turnOnMicrophoneWhenJoining)
            ..setAudioOutputToSpeaker(config.useSpeakerWhenJoining);

          getToken(widget.userID).then((token) {
            assert(token.isNotEmpty);
            ZegoUIKit().joinRoom(widget.callID, token: token);
          });
        });
    }

    userListStreamSubscription =
        ZegoUIKit().createUserListStream().listen(onUserListUpdated);
  }

  @override
  void dispose() async {
    super.dispose();

    userListStreamSubscription?.cancel();

    await ZegoUIKit().leaveRoom();
    // await ZegoUIKit().uninit();
  }

  @override
  Widget build(BuildContext context) {
    widget.config.onHangUpConfirming ??= onQuitConfirming;
    return ScreenUtilInit(
      designSize: const Size(360, 740),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              return await widget.config.onHangUpConfirming!(context) ?? false;
            },
            child: clickListener(
              child: Stack(
                children: [
                  audioVideoContainer(),
                  menuBar(),
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

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    if (users.isEmpty) {
      //  remote users is empty
      if (widget.config.onHangUp != null) {
        widget.config.onHangUp!.call();
      } else {
        //  return to client page if user is empty
        Navigator.of(context).pop();
      }
    }
  }

  Widget clickListener({required Widget child}) {
    return GestureDetector(
      onTap: () {
        /// listen only click event in empty space
        if (widget.config.hideMenuBarByClick) {
          setState(() {
            menuBarVisibilityNotifier.value = !menuBarVisibilityNotifier.value;
          });
        }
      },
      child: Listener(
        ///  listen for all click events in current view, include the click
        ///  receivers(such as button...), but only listen
        onPointerDown: (e) {
          menuBarRestartHideTimerNotifier.value =
              DateTime.now().millisecondsSinceEpoch;
        },
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

  Widget menuBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: ZegoUIKitPrebuiltCallMenuBar(
        buttonSize: Size(50.w, 50.h),
        config: widget.config,
        visibilityNotifier: menuBarVisibilityNotifier,
        restartHideTimerNotifier: menuBarRestartHideTimerNotifier,
      ),
    );
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
    if (widget.config.hangUpConfirmDialogInfo == null) {
      return true;
    }

    return await showAlertDialog(
      context,
      widget.config.hangUpConfirmDialogInfo!.title,
      widget.config.hangUpConfirmDialogInfo!.message,
      [
        ElevatedButton(
          child: Text(
            widget.config.hangUpConfirmDialogInfo!.cancelButtonName,
            style: TextStyle(fontSize: 26.r, color: const Color(0xff0055FF)),
          ),
          onPressed: () {
            //  pop this dialog
            Navigator.of(context).pop(false);
          },
          // style: ElevatedButton.styleFrom(primary: Colors.white),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ElevatedButton(
          child: Text(
            widget.config.hangUpConfirmDialogInfo!.confirmButtonName,
            style: TextStyle(fontSize: 18.sp, color: Colors.white),
          ),
          onPressed: () {
            //  pop this dialog
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
        ZegoAudioVideoForeground(
          size: size,
          user: user,
          showMicrophoneStateOnView: widget.config.showMicrophoneStateOnView,
          showCameraStateOnView: widget.config.showCameraStateOnView,
          showUserNameOnView: widget.config.showUserNameOnView,
        ),
      ],
    );
  }

  Widget audioVideoViewBackground(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    var screenSize = MediaQuery.of(context).size;
    var isSmallView = (screenSize.width - size.width).abs() > 1;
    return Stack(
      children: [
        Container(
            color: isSmallView
                ? const Color(0xff333437)
                : const Color(0xff4A4B4D)),
        widget.config.backgroundBuilder?.call(context, size, user, extraInfo) ??
            Container(color: Colors.transparent),
        ZegoAudioVideoBackground(
          size: size,
          user: user,
          showAvatar: widget.config.showAvatarInAudioMode,
          showSoundLevel: widget.config.showSoundWavesInAudioMode,
          avatarBuilder: widget.config.avatarBuilder,
        ),
      ],
    );
  }
}
