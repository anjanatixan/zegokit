// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/components/components.dart';
import 'package:zego_uikit/prebuilts/live/components/components.dart';
import 'package:zego_uikit/prebuilts/live/live_defines.dart';

class ZegoUIKitPrebuiltLiveConfig {
  ZegoUIKitPrebuiltLiveConfig({
    this.isHost = false,
    this.useVideoViewAspectFill = true,
    this.showAvatarInAudioMode = true,
    this.showSoundWavesInAudioMode = true,
    this.showUserNameOnView = true,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.avatarBuilder,
    this.menuBarButtons = const [
      ZegoLiveMenuBarButtonName.toggleCameraButton,
      ZegoLiveMenuBarButtonName.toggleMicrophoneButton,
      ZegoLiveMenuBarButtonName.hangUpButton,
      ZegoLiveMenuBarButtonName.switchAudioOutputButton,
      ZegoLiveMenuBarButtonName.switchCameraFacingButton,
    ],
    this.menuBarButtonsMaxCount = 5,
    this.menuBarExtendButtons = const [],
    this.layout,
    this.endLiveConfirmInfo,
    this.onEndLiveConfirming,
    this.onEndLive,
  }) {
    layout ??= ZegoLayout.pictureInPicture(
      smallViewPosition: ZegoViewPosition.bottomRight,
      selfUseSmallAudioVideoView: !isHost,
      showMyViewWithVideoOnly: !isHost,
    );
  }

  /// is host or not, default is false
  bool isHost;

  /// video view mode
  /// if set to true, video view will proportional zoom fills the entire View and may be partially cut
  /// if set to false, video view proportional scaling up, there may be black borders
  bool useVideoViewAspectFill;

  /// hide avatar of audio video view if set false
  bool showAvatarInAudioMode;

  /// hide sound level of audio video view if set false
  bool showSoundWavesInAudioMode;

  /// hide user name of audio video view if set false
  bool showUserNameOnView;

  /// customize your foreground of audio video view, which is the top widget of stack
  /// <br><img src="https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_default_avatar_nowave.jpg" width="5%">
  /// you can return any widget, then we will put it on top of audio video view
  AudioVideoViewForegroundBuilder? foregroundBuilder;

  /// customize your background of audio video view, which is the bottom widget of stack
  AudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// customize your user's avatar, default we use userID's first character as avatar
  /// User avatars are generally stored in your server, ZegoUIkitPrebuiltLive does not know each user's avatar, so by default, ZegoUIkitPrebuiltLive will use the first letter of the user name to draw the default user avatar, as shown in the following figure,
  ///
  /// |When the user is not speaking|When the user is speaking|
  /// |--|--|
  /// |<img src="https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_default_avatar_nowave.jpg" width="10%">|<img src="https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_default_avatar.jpg" width="10%">|
  ///
  /// If you need to display the real avatar of your user, you can use the avatarBuilder to set the user avatar builder method (set user avatar widget builder), the usage is as follows:
  ///
  /// ```dart
  ///
  ///  // eg:
  ///  avatarBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
  ///    return user != null
  ///        ? Container(
  ///            decoration: BoxDecoration(
  ///              shape: BoxShape.circle,
  ///              image: DecorationImage(
  ///                image: NetworkImage(
  ///                  'https://your_server/app/avatar/${user.id}.png',
  ///                ),
  ///              ),
  ///            ),
  ///          )
  ///        : const SizedBox();
  ///  },
  ///
  /// ```
  ///
  AudioVideoViewAvatarBuilder? avatarBuilder;

  /// these buttons will displayed on the menu bar, order by the list
  List<ZegoLiveMenuBarButtonName> menuBarButtons;

  /// limited item count display on menu bar,
  /// if this count is exceeded, More button is displayed
  int menuBarButtonsMaxCount;

  /// these buttons will sequentially added to menu bar,
  /// and auto added extra buttons to the pop-up menu
  /// when the limit [menuBarButtonsMaxCount] is exceeded
  List<Widget> menuBarExtendButtons;

  /// layout config
  ZegoLayout? layout;

  /// alert dialog information of quit
  /// if confirm info is not null, APP will pop alert dialog when you hang up
  EndLiveConfirmInfo? endLiveConfirmInfo;

  /// It is often used to customize the process before exiting the live interface.
  /// The liveback will triggered when user click hang up button or use system's return,
  /// If you need to handle custom logic, you can set this liveback to handle (such as showAlertDialog to let user determine).
  /// if you return true in the liveback, prebuilt page will quit and return to your previous page, otherwise will ignore.
  Future<bool?> Function(BuildContext context)? onEndLiveConfirming;

  /// customize handling after end live
  VoidCallback? onEndLive;
}

class EndLiveConfirmInfo {
  String title;
  String message;
  String cancelButtonName;
  String confirmButtonName;

  EndLiveConfirmInfo({
    this.title = "End to confirm",
    this.message = "Do you want to end?",
    this.cancelButtonName = "Cancel",
    this.confirmButtonName = "Confirm",
  });
}
