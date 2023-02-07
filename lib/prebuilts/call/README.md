## Features

- In video call mode, the device status of the remote user is displayed in real time
- In audio call mode, the user's dynamic voice is displayed around the avatar
- Picture-in-picture view, large and small views can be clicked to switch, small views can be dragged,
- Support App rotation, view adaptive, view can be adjusted adaptively when the remote landscape is switched between vertical and horizontal screens
- Support adding custom buttons to the menuBar and configuring the display method

**Basic effect display:**

| Sound Wave Effect                                                                                    | View Drag                                                                                                        | View Switch                                                                                                |
| ---------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/_all_close.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_all_close.gif) | ![/Pics/ZegoUIKit/Flutter/layout_draggable.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_draggable.gif) | ![/Pics/ZegoUIKit/Flutter/layout_switch.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_switch.gif) |

**Horizontal and vertical screen adaptive effect:**

| Default vertical screen on both sides                                                              | Landscape on the far side                                                                          | Landscape on the local side                                                                        | Landscape on both sides                                                                            |
| -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/layout_hh.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_hh.png) | ![/Pics/ZegoUIKit/Flutter/layout_hv.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_hv.png) | ![/Pics/ZegoUIKit/Flutter/layout_vh.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_vh.png) | ![/Pics/ZegoUIKit/Flutter/layout_vv.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_vv.png) |

**Custom menuBar effect:**

| bottomSheet shows more                                                                                   | Adaptive screen width                                                                                        | Adaptive+bottomSheet                                                                                             |
| -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/menuBarLimit.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/menuBarLimit.gif) | ![/Pics/ZegoUIKit/Flutter/menuBarUnlimit.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/menuBarUnlimit.gif) | ![/Pics/ZegoUIKit/Flutter/menuBarMoreLimit.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/menuBarMoreLimit.gif) |

## How to integrate ZegoUIKit into your project

Now only supports using local package references to integrate ZegoUIKit. (Since it is currently in the beta testing stage, the pub package management has not been uploaded yet)

> In this document, we create a brand new flutter app project to introduce how to integrate

> `flutter create --template app your_project`

1. Unzip zego_uikit.zip and place it at the same level as your project's root directory

   ![1658891156282](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/1658891156282.png)
2. Edit your project's pubspec.yaml and add local project dependencies

   ```yaml
   zego_uikit:
      path: ../zego_uikit
   ```

   ![1658891572616](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/1658891572616.png)
3. Execute `flutter pub get` in your project root directory
4. Declare a CallPage class, to integrate ZegoUIKitPrebuiltCall of ZegoUIKit

   > you need to fill in the appID and appSign you obtained from [zegocloud console](https://console.zegocloud.com).
   > You can customize the callID arbitrarily, just need to know: users who use the same callID can talk with each other (Currently ZegoUIKit only supports 1v1 call, and will support group call soon)
   >

   ```dart
   class CallPage extends StatelessWidget {
     const CallPage({Key? key, required this.callID}) : super(key: key);   

     /// You can customize the callID arbitrarily,
     /// just need to know: users who use the same callID can talk with each other
     final String callID;   

     @override
     Widget build(BuildContext context) {
       return ZegoUIKitPrebuiltCall(
         config: ZegoUIKitPrebuiltCallConfig(
           appID: YourSecret.appID, // input your appID
           appSign: YourSecret.appSign, // input your appSign
           userID: userID, // note that the userID needs to be globally unique,
           userName: userID, // user's name, we use userID as default name
           callID: callID, // You can customize the callID arbitrarily
         ),
       );
     }
   }
   ```
5. You can use any navigation method of flutter to navigate to the CallPage.

   > Here we demonstrate clicking the button to navigate to callPage by `Navigator.push` method.
   >

   ```dart
   floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.call),
      onPressed: () => Navigator.push(
         context,
         MaterialPageRoute(builder: (context) {
           return const CallPage(callID: 'test_call_id');
         }),
      ),
   ),
   ```
6. The complete and simplest integration code is as follows:

   ```dart
   import 'package:flutter/material.dart';
   import 'dart:math';

   import 'package:zego_uikit/zego_uikit.dart';

   void main() {
     runApp(const MyApp());
   }

   class MyApp extends StatelessWidget {
     const MyApp({Key? key}) : super(key: key);

     @override
     Widget build(BuildContext context) {
       return const MaterialApp(title: 'Flutter Demo', home: HomePage());
     }
   }

   // Demo HomePage code:
   class HomePage extends StatelessWidget {
     const HomePage({Key? key}) : super(key: key);

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: const Text("your project")),
         body: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: const [
               Text('Please test with two devices'),
               Text('Press Call Button To Try ZegoUikit'),
             ],
           ),
         ),
         // click floatingActionButton to navigate to CallPage
         floatingActionButton: FloatingActionButton(
           child: const Icon(Icons.call),
           onPressed: () => Navigator.push(
             context,
             MaterialPageRoute(builder: (context) {
               return const CallPage(callID: 'test_call_id');
             }),
           ),
         ),
       );
     }
   }

   /// you need to fill in the appID and appSign you obtained
   /// from https://console.zegocloud.com
   class YourSecret {
     static const int appID = ;
     static const String appSign = ;
   }

   /// Note that the userID needs to be globally unique,
   /// this demo use a random userID for test.
   String userID = Random().nextInt(10000).toString();

   // intergate code :
   class CallPage extends StatelessWidget {
     const CallPage({Key? key, required this.callID}) : super(key: key);

     /// You can customize the callID arbitrarily,
     /// just need to know: users who use the same callID can talk with each other.
     final String callID;

     @override
     Widget build(BuildContext context) {
       return ZegoUIKitPrebuiltCall(
         config: ZegoUIKitPrebuiltCallConfig(
           appID: YourSecret.appID, // input your appID
           appSign: YourSecret.appSign, // input your appSign
           userID: userID, // note that the userID needs to be globally unique,
           userName: userID, // user's name, we use userID as default name
           callID: callID, // You can customize the callID arbitrarily
         ),
       );
     }
   }
   ```

## project setting

### Android

1. If your project was created with a version of flutter that is not the latest stable, you may need to manually modify compileSdkVersion in `your_project/android/app/build.gradle` to 33

   ![compileSdkVersion](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/compile_sdk_version.png)
2. Need to add app permissions, Open the file `your_project/app/src/main/AndroidManifest.xml`, add the following code:

   ```xml
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.BLUETOOTH" />
   <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <uses-permission android:name="android.permission.WAKE_LOCK" />
   ```

   ![permission_android](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/permission_android.png)

### iOS

Need add app permissions, open ·your_project/ios/Runner/Info.plist·, add the following code inside the "dict" tag:

```plist
<key>NSCameraUsageDescription</key>
<string>We require camera access to connect to a call</string>
<key>NSMicrophoneUsageDescription</key>
<string>We require microphone access to connect to a call</string>
```

![permission_ios](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/permission_ios.png)

### Feature tips

1. Support clicking on the unresponsive area to hide the menuBar
2. Support dragging small view position
3. Support clicking on the small view to exchange it with the large view
4. Support display sound waves in audio call mode
5. Perfectly adapt the phone rotation, both remote and local

For more features, see Advanced Customize config

# test tips

1. you need use real device to test, ios simulator doesn't support camera.
2. Please note that the two devices should not be very close to each other when testing, if your two devices are close to each other, there may be a problem with capturing each other's voices, causing echo oscillations. see https://en.wikipedia.org/wiki/Audio_feedback
3. We perfectly adapt the phone rotation, both remote and localperfectly adapt the phone rotation of remote and local device,You can click on the small screen, which will switch the remote and local screen positions, so that the remote video is rendered on the small screen. Then you can rotate both phones arbitrarily to test the adaptive video view
4. If you don't want your app to be rotated during a call, you can use flutter's systemChrome API to set it up (this is not managed by our sdk)

## Advanced Customize config

As you can see from QuickStart, when you create `ZegoUIKitPrebuiltCall`, you need to pass a `ZegoUIKitPrebuiltCallConfig`. In addition to the required parameters, this config has many parameters for Customize. We will introduce these parameters in detail later. Let you have a full understanding of this product.

### Use your user's real avatar

User avatars are generally stored in your server, ZegoUIkitPrebuiltCall does not know each user's avatar, so by default, ZegoUIkitPrebuiltCall will use the first letter of the user name to draw the default user avatar, as shown in the following figure,

| When the user is not speaking                                               | When the user is speaking                                            |
| --------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| ![](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_default_avatar_nowave.jpg) | ![](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_default_avatar.jpg) |

If you need to display the real avatar of your user, you can use the avatarBuilder to set the user avatar builder method (set user avatar widget builder), the usage is as follows:

```dart

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: userID, // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        hideMenuBarAutomatically: false,

        // Set Avatar Builder
        avatarBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
          return user != null
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://your_server/app/avatar/${user.id}.png',
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}

```

### Distinguish between video calls and audio calls

ZegoUIkitPrebuiltCall defaults to video call mode, and users can click the camera button to turn off the camera and turn it into audio call mode.

The effect is as follows

| Both sides turn on the camera                                                                         | The local end closes the camera                                                                           | The other side closes the camera                                                                            | Both sides close the camera                                                                           |
| ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/_normal_30.png](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_normal_30.png) | ![/Pics/ZegoUIKit/Flutter/_local_close.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_local_close.gif) | ![/Pics/ZegoUIKit/Flutter/_remote_close.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_remote_close.gif) | ![/Pics/ZegoUIKit/Flutter/_all_close.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_all_close.gif) |

If you are in a voice-only call scenario and don't need the camera button, you can

1. Configure menuBarButtons to modify the button list at the bottom
2. Configure turnOnCameraWhenJoining to turn off the camera when you start a call
3. Configure showCameraStateOnView to close the camera state display in the view

After configuration, the effect is as follows

![/Pics/ZegoUIKit/Flutter/_audio_mode.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_audio_mode.gif)

code show as below

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: userID, // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily

        // add these configs
        turnOnCameraWhenJoining: false,
        showCameraStateOnView: false,
        menuBarButtons: [
          ZegoMenuBarButtonName.toggleMicrophoneButton,
          ZegoMenuBarButtonName.hangUpButton,
          ZegoMenuBarButtonName.switchAudioOutputButton,
        ],
      ),
    );
  }
}  
```

### Configure the device state when starting a call

When ZegoUIkitPrebuiltCall starts a call, it will turn on the camera, microphone, and use the speaker as the audio output device by default.

If you need to change this default behavior, such as turning off the camera when starting a call, or not using the speaker, (if you don't use the speaker, the system default audio output device, such as earpiece, earphone, etc., will be used), you can configure the following

1. turnOnCameraWhenJoining: Whether to turn on the camera when starting a call, true on, false off, default on.
2. turnOnMicrophoneWhenJoining: Whether to turn on the microphone when starting a call, true on, false off, the default is on.
3. useSpeakerWhenJoining: Whether to use the speaker when starting a call, true to use the speaker, false to use the system default audio output device, such as earpiece, earphone, etc., the speaker is used by default.

### Hide built-in components you don't need

ZegoUIkitPrebuiltCall will display UserNameLabel, MicrophoneStateIcon and CameraStateIcon on the view by default. If you do not need these components, you can use the following three configurations to hide them

| Configuration                                                                                                                                                                                                                                                                                                        | Effect                                                                                                                          |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| 1. showMicrophoneStateOnView: Whether to display the microphone state on the view, the default display`<br><br>`2. showCameraStateOnView: whether to display the camera state on the view, the default display`<br><br>`3. showUserNameOnView: whether to display the user name on the view, the default display | ![/Pics/ZegoUIKit/Flutter/_normal_switch_30_label.png](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_normal_switch_30_label.png) |

**Hide sound waves and avatars**

As seen earlier, when the user turns off the camera, ZegoUIkitPrebuiltCall will display the user's avatar and voice,

If you are not satisfied with the style of user avatar and voice, you can hide them using these two configurations,

| Configuration                                                                                                                                                                                                 | Effect                                                                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 1. showAvatarInAudioMode: In audio mode, whether to display the user avatar, the default display`<br>`2. showSoundWavesInAudioMode: In audio mode, whether to display user sound waves, the default display | ![/Pics/ZegoUIKit/Flutter/_remote_close_switch_30_label.png](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/_remote_close_switch_30_label.png) |

### Configure buttons in menuBar

ZegoUIkitPrebuiltCall allows you to remove built-in buttons in the menuBar, and also allows you to add your custom buttons to the menuBar.

1. menuBarButtons: Which built-in buttons are placed in the menuBar, all of them are displayed by default. If you need to hide some buttons, you can configure them through this parameter. See "Distinguish between video calls and audio calls", and link todo to the corresponding section.
2. menuBarExtendButtons: If you need to add your custom button to the menuBar, you can use this configuration to add it, see the code example and rendering at the end of this summary.
3. menuBarButtonsMaxCount: Limit the maximum number of buttons displayed in the menuBar, the default is 5. If the actual number of buttons is greater than this limit, the last button will become more buttons. After clicking, the bottomSheet will pop up to display the remaining buttons, see the renderings. If the number of buttons does not reach the limit, all buttons are displayed below.

According to the different relationship between the actual number of buttons, the screen width, and the configured limit number, there are usually the following three situations, and you can configure different modes as needed.

| case1                                                                                                     | case2                                                                                                             | case3                                                                                                         |
| --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/menuBarLimit.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/menuBarLimit.gif) | ![/Pics/ZegoUIKit/Flutter/menuBarMoreLimit.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/menuBarMoreLimit.gif) | ![/Pics/ZegoUIKit/Flutter/menuBarUnlimit.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/menuBarUnlimit.gif) |

The reference code for case2 is as follows:

> Modify menuBarButtonsMaxCount to 5, it will be case1
> Modify menuBarButtonsMaxCount to any large enough value, such as 100, it will be case3

```dart

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    List<IconData> myIcons = [
      Icons.phone,
      Icons.cookie,
      Icons.speaker,
      Icons.air,
      Icons.blender,
      Icons.file_copy,
      Icons.place,
      Icons.phone_android,
      Icons.phone_iphone,
    ];

    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: "Jerry", // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        hideMenuBarAutomatically: false,
        menuBarButtonsMaxCount: myIcons.length,
        menuBarExtendButtons: [
          for (int i = 0; i < myIcons.length; i++)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(60, 60),
                shape: const CircleBorder(),
                primary: controlBarButtonCheckedBackgroundColor,
              ),
              onPressed: () {},
              child: Icon(myIcons[i]),
            ),
        ],
        menuBarButtons: [
          ZegoMenuBarButtonName.toggleCameraButton,
          ZegoMenuBarButtonName.toggleMicrophoneButton,
          ZegoMenuBarButtonName.switchAudioOutputButton,
          ZegoMenuBarButtonName.hangUpButton,
          ZegoMenuBarButtonName.switchCameraFacingButton,
        ],
      ),
    );
  }
}

```

### Hide the bottom control bar (menuBar)

You can control whether the menuBar can be automatically hidden or manually hidden by the following two configurations.

1. hideMenuBarByClick: Whether you can click the unresponsive area to hide the menuBar, it is enabled by default.
2. hideMenuBarAutomatically: Whether the menuBar is automatically hidden after 5 seconds of inactivity by the user, it is enabled by default.

### PIP layout configuration

Each layout has configuration items corresponding to the layout. You can select the specific layout and corresponding configuration through the layout parameter of ZegoUIkitPrebuiltCallConfig.

The picture-in-picture view is configured as follows:

1. showMyViewWithVideoOnly: Whether to hide your own view when your own camera is turned off, it is not hidden by default.
2. isSmallViewDraggable: Whether the small view in the picture-in-picture layout can be dragged to change the position, the default is draggable.
3. switchLargeOrSmallViewByClick: Whether to allow the user to click the small view to switch the user's size view

| Do not hide yourself when closing camera                                                                            | Hide yourself when closing camera                                                                                   | Drag                                                                                                              | Toggle                                                                                                      |
| ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/layout_show_self1.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_show_self1.gif) | ![/Pics/ZegoUIKit/Flutter/layout_show_self0.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_show_self0.gif) | ![/Pics/ZegoUIKit/Flutter/layout_draggable.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_draggable.gif) | ![/Pics/ZegoUIKit/Flutter/layout_switch.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/layout_switch.gif) |

The configuration method is as follows

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: "Jerry", // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        hideMenuBarAutomatically: false,
        layout: ZegoLayout.pictureInPicture(
          showMyViewWithVideoOnly: false,
          isSmallViewDraggable: true,
          switchLargeOrSmallViewByClick: true,
        ),
      ),
    );
  }
}

```

### Add logout confirmation for users

ZegoUIKitPrebuilt By default, when the user clicks to end the call, or clicks the Android system return key, the call will end directly.

If you need to pop up a confirmation prompt box for the user to confirm the second time before the user exits, you can use hangup-related configuration

1. hangUpConfirmDialogInfo : You can configure the hangUpConfirmDialogInfo parameter. After configuration, ZegoUIKitPrebuilt will pop up a confirmation prompt box with default style before launching, showing the hangUpConfirmDialogInfo you set.

Effect: ![/Pics/ZegoUIKit/Flutter/hangup_confirm.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/hangup_confirm.gif)

You can configure it like this

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: "Jerry", // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        hangUpConfirmDialogInfo: HangUpConfirmInfo(
          title: "hangup confirm",
          message: "do you want to hangup?",
          cancelButtonName: "cancel",
          confirmButtonName: "confirm",
        ),
      ),
    );
  }
}
```

If you are not satisfied with the default style, or you need to pop up a more complex dialog, then you can use the `onHangUpConfirming` parameter. `onHangUpConfirming` is a Callback that you can use with `showDialog` of `Flutter`. Of course, you can also do any business logic in this Callback to decide whether you need to end the call. You can use like this:

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: "Jerry", // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        onHangUpConfirming: (BuildContext context) async {
          return await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                title: const Text("This is your custom dialog",
                    style: TextStyle(color: Colors.white70)),
                content: const Text(
                    "You can customize this dialog however you like",
                    style: TextStyle(color: Colors.white70)),
                actions: [
                  ElevatedButton(
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white70)),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    child: const Text("Exit"),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

```

Custom dialog effect:

![/Pics/ZegoUIKit/Flutter/hangup_custom.gif](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/hangup_custom.gif)

If you need to monitor the hangup event, such as you want to save the call record, ZegoUIKitPrebuiltCall provides you with an onHangUp callback, which will be triggered when the call ends. You can do your business logic in onHangUp, such as saving call records, etc.

### custom background

If you need to customize the user's view background, you can use `backgroundBuilder` to configure, this callback is similar to other Flutter Builders, you need to return a Widget, we will place the Widget you return on the view background .

> When the user video is turned on, the user's video screen will be displayed, so this configuration is only valid when the user turns off the video.

For example: place the user image with the Gaussian blur effect on the background, you can achieve this:

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        config: ZegoUIKitPrebuiltCallConfig(
      appID: YourSecret.appID, // input your appID
      appSign: YourSecret.appSign, // input your appSign
      userID: userID, // note that the userID needs to be globally unique,
      userName: "Jerry", // user's name, we use userID as default name
      callID: callID, // You can customize the callID arbitrarily
      backgroundBuilder: (BuildContext context, Size size,
          ZegoUIKitUser? user, Map extraInfo) {
        return user != null
            ? ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Image(
                  image: NetworkImage(
                    'https://your_server/app/user_image/${user.id}.png',
                  ),
                ),
              )
            : const SizedBox();
      },
    ));
  }
}
```

Effect:

There are bugs in todo's operation, and it needs to be repaired before showing the renderings.

### custom foreground

If you need to add some custom components to the view, such as adding an avatar when displaying a video screen, adding a user level icon, etc., you can use `foregroundBuilder` to configure it. This callback is similar to other Flutter Builders and needs to be You return a Widget, and we will place the Widget you returned on top of the view.

For example: in video mode, add a user avatar to the lower left corner of the video screen, you can achieve this:

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: "Jerry", // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
          return user != null
              ? Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://your_server/app/avatar/${user.id}.png',
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
```

Effect:

| Open the camera                                                  | Close the camera                                                 |
| ---------------------------------------------------------------- | ---------------------------------------------------------------- |
| ![](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/foreground1.jpg) | ![](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/foreground2.jpg) |

It can be seen that the foreground will be displayed at the top whether the camera is turned on or off. In our case, we obviously don't need to display our additional avatar when the camera is turned off.

So we need to build different views according to the user's camera state. `ZegoUIKit` provides you with a `ValueNotifier` out of the box, which includes a `CameraStateNotifier` that can be used to monitor the user's camera state.

So we can use Flutter's ValueListenableBuilder to modify this example like this:

```dart
class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);

  /// You can customize the callID arbitrarily,
  /// just need to know: users who use the same callID can talk with each other.
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      config: ZegoUIKitPrebuiltCallConfig(
        appID: YourSecret.appID, // input your appID
        appSign: YourSecret.appSign, // input your appSign
        userID: userID, // note that the userID needs to be globally unique,
        userName: "Jerry", // user's name, we use userID as default name
        callID: callID, // You can customize the callID arbitrarily
        foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
          return user != null
              ? ValueListenableBuilder<bool>(
                  valueListenable: ZegoUIKit().getCameraStateNotifier(user.id),
                  builder: (context, isCameraOn, child) {
                    return isCameraOn ? child! : const SizedBox();
                  },
                  child: Positioned(
                    bottom: 5,
                    left: 5,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://your_server/app/avatar/${user.id}.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
```

After modification:

| Open the camera                                                  | Close the camera                                                 |
| ---------------------------------------------------------------- | ---------------------------------------------------------------- |
| ![](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/foreground1.jpg) | ![](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/foreground3.jpg) |
