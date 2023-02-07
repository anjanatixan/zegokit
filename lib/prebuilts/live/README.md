## Features

- In host mode, hoster share him video and voice in real time, and can chat with others
- In watch mode,  watcher can see the hoster video and hear the hoster voice, and can chat with others
- Picture-in-picture view, large and small views can be clicked to switch, small views can be dragged,
- Support App rotation, view adaptive, view can be adjusted adaptively when the remote landscape is switched between vertical and horizontal screens

**Basic effect display:**

| Sound Wave Effect                                                                                           | View Drag                                                                                                             | View Switch                                                                                                     |
| ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/_all_close.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/sound_effect.gif) | ![/Pics/ZegoUIKit/Flutter/layout_draggable.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_draggable.gif) | ![/Pics/ZegoUIKit/Flutter/layout_switch.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_switch.gif) |

**Horizontal and vertical screen adaptive effect:**

| Default vertical screen on both sides                                                                    | Landscape on the far side                                                                                | Landscape on the local side                                                                              | Landscape on both sides                                                                                  |
| -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/layout_hh.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_vv.jpeg) | ![/Pics/ZegoUIKit/Flutter/layout_hv.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_vh.jpeg) | ![/Pics/ZegoUIKit/Flutter/layout_vh.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_hv.jpeg) | ![/Pics/ZegoUIKit/Flutter/layout_vv.png](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_hh.jpeg) |

**chat effect:**

| chat effect                                                                                |
| ----------------------------------------------------------------------------------------------------- |
| ![/Pics/ZegoUIKit/Flutter/menuBarLimit.gif](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/chat.gif) |

## How to integrate ZegoUIKit into your project

Now only supports using local package references to integrate ZegoUIKit. (Since it is currently in the beta testing stage, the pub package management has not been uploaded yet)

> In this document, we create a brand new flutter app project to introduce how to integrate

> `flutter create --template app your_project`

1. Unzip zego_uikit.zip and place it at the same level as your project's root directory

   ![1658891156282](../../../doc/inner/image/prebuilt/1658891156282.png)
2. Edit your project's pubspec.yaml and add local project dependencies

   ```yaml
   zego_uikit:
      path: ../zego_uikit
   ```

   ![1658891572616](../../../doc/inner/image/prebuilt/1658891572616.png)
3. Execute `flutter pub get` in your project root directory
4. Declare a LivePage class, to integrate ZegoUIKitPrebuiltLive of ZegoUIKit

   > you need to fill in the appID and appSign you obtained from [zegocloud console](https://console.zegocloud.com).
   > You can customize the liveID arbitrarily, just need to know: users who use the same liveID can talk with each other
   >

   ```dart
   class LivePage extends StatelessWidget {
     /// You can customize the liveID arbitrarily,
     /// just need to know: users who use the same liveID can talk with each other.
     final String liveID;
     final bool isHost;

     const LivePage({
       Key? key,
       required this.liveID,
       this.isHost = false,
     }) : super(key: key);

     @override
     Widget build(BuildContext context) {
       return SafeArea(
         child: ZegoUIKitPrebuiltLive(
           // input your appID
           appID: YourSecret.appID,
           // input your appSign
           appSign: YourSecret.appSign,
           // note that the userID needs to be globally unique,
           userID: userID,
           // user's name, we use userID as default name
           userName: 'user_$userID',
           // You can customize the liveID arbitrarily
           liveID: liveID,
           config: ZegoUIKitPrebuiltLiveConfig(
             // true if you are the host, false if you are a audience
             isHost: isHost,
           ),
         ),
       );
     }
   }

   ```
5. You can use any navigation method of flutter to navigate to the LivePage.

   > Here we demonstrate clicking the button to navigate to Live page by `Navigator.push` method.
   >

   ```dart
   floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.videocam),
      onPressed: () => Navigator.push(
         context,
         MaterialPageRoute(builder: (context) {
           return const LivePage(liveID: 'test_live_id', isHost: true);
         }),
      ),
   ),
   ```
6. The complete and simplest integration code is as follows:

   ```dart
   // Dart imports:
   import 'dart:math';

   // Flutter imports:
   import 'package:flutter/material.dart';

   // Package imports:
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
       var buttonStyle = ElevatedButton.styleFrom(
         fixedSize: const Size(60, 60),
         shape: const CircleBorder(),
         primary: const Color(0xff2C2F3E).withOpacity(0.6),
       );

       return Scaffold(
         appBar: AppBar(title: const Text("your project")),
         body: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text('Please test with two or more devices'),
               const SizedBox(height: 60),
               // click floatingActionButton to navigate to LivePage
               ElevatedButton(
                 style: buttonStyle,
                 child: const Icon(Icons.videocam),
                 onPressed: () => jumpToLivePage(context, liveID: 'test_live_id', isHost: true),
               ),
               const Text('Click me to start a Live'),
               const SizedBox(height: 60),
               // click floatingActionButton to navigate to LivePage
               ElevatedButton(
                 style: buttonStyle,
                 child: const Icon(Icons.live_tv),
                 onPressed: () => jumpToLivePage(context, liveID: 'test_live_id', isHost: false),
               ),
               const Text('Click me to watch a Live'),
             ],
           ),
         ),
       );
     }

     jumpToLivePage(BuildContext context,
         {required String liveID, required bool isHost}) {
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) {
             return LivePage(liveID: liveID, isHost: isHost);
           },
         ),
       );
     }
   }

   /// you need to fill in the appID and appSign you obtained
   /// from https://console.zegocloud.com
   class YourSecret {
     static const int appID = ;

     static const String appSign = '';
   }

   /// Note that the userID needs to be globally unique,
   /// this demo use a random userID for test.
   String userID = Random().nextInt(10000).toString();

   // integrate code :
   class LivePage extends StatelessWidget {
     /// You can customize the liveID arbitrarily,
     /// just need to know: users who use the same liveID can talk with each other.
     final String liveID;
     final bool isHost;

     const LivePage({
       Key? key,
       required this.liveID,
       this.isHost = false,
     }) : super(key: key);

     @override
     Widget build(BuildContext context) {
       return SafeArea(
         child: ZegoUIKitPrebuiltLive(
           // input your appID
           appID: YourSecret.appID,
           // input your appSign
           appSign: YourSecret.appSign,
           // note that the userID needs to be globally unique,
           userID: userID,
           // user's name, we use userID as default name
           userName: 'user_$userID',
           // You can customize the liveID arbitrarily
           liveID: liveID,
           config: ZegoUIKitPrebuiltLiveConfig(
             // true if you are the host, false if you are a audience
             isHost: isHost,
           ),
         ),
       );
     }
   }
   ```

## project setting

### Android

1. If your project was created with a version of flutter that is not the latest stable, you may need to manually modify compileSdkVersion in `your_project/android/app/build.gradle` to 33

   ![compileSdkVersion](../../../doc/inner/image/prebuilt/compileSdkVersion.png)
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

   ![permission_android](../../../doc/inner/image/prebuilt/permission_android.png)

### iOS

Need add app permissions, open ·your_project/ios/Runner/Info.plist·, add the following code inside the "dict" tag:

```plist
<key>NSCameraUsageDescription</key>
<string>We require camera access to connect to a Live</string>
<key>NSMicrophoneUsageDescription</key>
<string>We require microphone access to connect to a Live</string>
```

![permission_ios](../../../doc/inner/image/prebuilt/permission_ios.png)

### Feature tips

1. Support dragging small view position
2. Support clicking on the small view to exchange it with the large view
3. Support display sound waves in audio Live mode
4. Perfectly adapt the phone rotation, both remote and local

For more features, see Advanced Customize config

# test tips

1. you need use real device to test, ios simulator doesn't support camera.
2. Please note that the two devices should not be very close to each other when testing, if your two devices are close to each other, there may be a problem with capturing each other's voices, causing echo oscillations. see https://en.wikipedia.org/wiki/Audio_feedback
3. We perfectly adapt the phone rotation, both remote and local perfectly adapt the phone rotation of remote and local device,You can click on the small screen, which will switch the remote and
   local screen positions, so that the remote video is rendered on the small screen. Then you can rotate both phones arbitrarily to test the adaptive video view
4. If you don't want your app to be rotated during a Live, you can use flutter's systemChrome API to set it up (this is not managed by our sdk)

## Advanced Customize config

As you can see from QuickStart, when you create `ZegoUIKitPrebuiltLive`, you need to pass a `ZegoUIKitPrebuiltLiveConfig`. In addition to the required parameters, this config has many parameters for
Customize. We will introduce these parameters in detail later. Let you have a full understanding of this product.

### Use your user's real avatar

User avatars are generally stored in your server, ZegoUIkitPrebuiltLive does not know each user's avatar, so by default, ZegoUIkitPrebuiltLive will use the first letter of the user name to draw the
default user avatar, as shown in the following figure,

| default avatar                                                                       | When the user is speaking                                                     |
| ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| ![img](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/_default_avatar_nowave.jpeg) | ![img](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/_default_avatar.jpeg) |

If you need to display the real avatar of your user, you can use the avatarBuilder to set the user avatar builder method (set user avatar widget builder), the usage is as follows:

```dart
class LivePage extends StatelessWidget {
   /// You can customize the liveID arbitrarily,
   /// just need to know: users who use the same liveID can talk with each other.
   final String liveID;
   final bool isHost;

   const LivePage({
      Key? key,
      required this.liveID,
      this.isHost = false,
   }) : super(key: key);

   @override
   Widget build(BuildContext context) {
      return SafeArea(
         child: ZegoUIKitPrebuiltLive(
            // input your appID
            appID: YourSecret.appID,
            // input your appSign
            appSign: YourSecret.appSign,
            // note that the userID needs to be globally unique,
            userID: userID,
            // user's name, we use userID as default name
            userName: 'user_$userID',
            // You can customize the liveID arbitrarily
            liveID: liveID,
            config: ZegoUIKitPrebuiltLiveConfig(
               // true if you are the host, false if you are a audience
               isHost: isHost,
               avatarBuilder: avatarBuilder,
            ),
         ),
      );
   }

   Widget avatarBuilder(
           BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
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
   }
}
```

### Distinguish between video Live and audio Live

host in ZegoUIkitPrebuiltLive is defaults to video mode, and hoster can click the camera button to turn off the camera and turn it into audio live mode.

The effect is as follows

| Both sides turn on the camera                                                | The local end closes the camera                                                   | The other side closes the camera                                                    | Both sides close the camera                                                   |
| ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| ![all_open](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/_all_open.jpeg) | ![local_close](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/_local_close.gif) | ![remote_close](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/_remote_close.gif) | ![all_close](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/_all_close.gif) |

### Hide built-in components you don't need

**Hide sound waves and avatars**

As seen earlier, when the user turns off the camera, ZegoUIkitPrebuiltLive will display the user's avatar and voice,

If you are not satisfied with the style of user avatar and voice, you can hide them using these two configurations,

| Configuration                                                                                                                                                                                                  | Effect                                                                                               |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| 1. showAvatarInAudioMode: In audio mode, whether to display the user avatar, the default display `<br>`2. showSoundWavesInAudioMode: In audio mode, whether to display user sound waves, the default display | ![sound_waves_avatars.png](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/sound_waves_avatars.png) |

### PIP layout configuration

Each layout has configuration items corresponding to the layout. You can select the specific layout and corresponding configuration through the layout parameter of ZegoUIkitPrebuiltLiveConfig.

The picture-in-picture view is configured as follows:

1. isSmallViewDraggable: Whether the small view in the picture-in-picture layout can be dragged to change the position, the default is draggable.
2. switchLargeOrSmallViewByClick: Whether to allow the user to click the small view to switch the user's size view

| Drag                                                                                       | Toggle                                                                               |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| ![layout_draggable](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_draggable.gif) | ![layout_switch](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/layout_switch.gif) |

The configuration method is as follows

```dart

class LivePage extends StatelessWidget {
   /// You can customize the liveID arbitrarily,
   /// just need to know: users who use the same liveID can talk with each other.
   final String liveID;
   final bool isHost;

   const LivePage({
      Key? key,
      required this.liveID,
      this.isHost = false,
   }) : super(key: key);

   @override
   Widget build(BuildContext context) {
      return SafeArea(
         child: ZegoUIKitPrebuiltLive(
            // input your appID
            appID: YourSecret.appID,
            // input your appSign
            appSign: YourSecret.appSign,
            // note that the userID needs to be globally unique,
            userID: userID,
            // user's name, we use userID as default name
            userName: 'user_$userID',
            // You can customize the liveID arbitrarily
            liveID: liveID,
            config: ZegoUIKitPrebuiltLiveConfig(
               // true if you are the host, false if you are a audience
               isHost: isHost,
               layout: ZegoLayout.pictureInPicture(
                  showMyViewWithVideoOnly: false,
                  isSmallViewDraggable: true,
                  switchLargeOrSmallViewByClick: true,
               ),
            ),
         ),
      );
   }
}

```

### Add logout confirmation for users

ZegoUIKitPrebuilt By default, when the user clicks to end the Live, or clicks the Android system return key, the Live will end directly.

If you need to pop up a confirmation prompt box for the user to confirm the second time before the user exits, you can use hangup-related configuration

1. endLiveConfirmInfo : You can configure the endLiveConfirmInfo parameter. After configuration, ZegoUIKitPrebuilt will pop up a confirmation prompt box with default style before launching, showing the endLiveConfirmInfo you set.

Effect:

 ![endlive_confirm](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/endlive_confirm.gif)

You can configure it like this

```dart
class LivePage extends StatelessWidget {
  /// You can customize the liveID arbitrarily,
  /// just need to know: users who use the same liveID can talk with each other.
  final String liveID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLive(
        // input your appID
        appID: YourSecret.appID,
        // input your appSign
        appSign: YourSecret.appSign,
        // note that the userID needs to be globally unique,
        userID: userID,
        // user's name, we use userID as default name
        userName: 'user_$userID',
        // You can customize the liveID arbitrarily
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveConfig(
          // true if you are the host, false if you are a audience
          isHost: isHost,
          endLiveConfirmInfo: EndLiveConfirmInfo(),
        ),
      ),
    );
  }
}
```

If you are not satisfied with the default style, or you need to pop up a more complex dialog, then you can use the `onEndLiveConfirming` parameter. `onEndLiveConfirming` is a Callback that you can
use with `showDialog` of `Flutter`. Of course, you can also do any business logic in this Callback to decide whether you need to end the Live. You can use like this:

```dart
class LivePage extends StatelessWidget {
   /// You can customize the liveID arbitrarily,
   /// just need to know: users who use the same liveID can talk with each other.
   final String liveID;
   final bool isHost;

   const LivePage({
      Key? key,
      required this.liveID,
      this.isHost = false,
   }) : super(key: key);

   @override
   Widget build(BuildContext context) {
      return SafeArea(
         child: ZegoUIKitPrebuiltLive(
            // input your appID
            appID: YourSecret.appID,
            // input your appSign
            appSign: YourSecret.appSign,
            // note that the userID needs to be globally unique,
            userID: userID,
            // user's name, we use userID as default name
            userName: 'user_$userID',
            // You can customize the liveID arbitrarily
            liveID: liveID,
            config: ZegoUIKitPrebuiltLiveConfig(
               // true if you are the host, false if you are a audience
               isHost: isHost,
               onEndLiveConfirming: onEndLiveConfirming,
            ),
         ),
      );
   }
   
   Future<bool?> onEndLiveConfirming(BuildContext context) async {
      return await showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context) {
            return AlertDialog(
               backgroundColor: Colors.blue[900]!.withOpacity(0.9),
               title: const Text("This is your custom dialog",
                       style: TextStyle(color: Colors.white70)),
               content: const Text("You can customize this dialog however you like",
                       style: TextStyle(color: Colors.white70)),
               actions: [
                  ElevatedButton(
                     child:
                     const Text("Cancel", style: TextStyle(color: Colors.white70)),
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
   }
}
```

Custom dialog effect:

![endlive_custom](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/endlive_custom.gif)

If you need to monitor the end Live event, such as you want to save the Live record, ZegoUIKitPrebuiltLive provides you with an onEndLive callback, which will be triggered when the Live end. You can
do your business logic in onEndLive, such as saving Live records, etc.

### custom background

If you need to customize the user's view background, you can use `backgroundBuilder` to configure, this callback is similar to other Flutter Builders, you need to return a Widget, we will place the Widget you return on the view background .

> When the user video is turned on, the user's video screen will be displayed, so this configuration is only valid when the user turns off the video.

For example: place the user image with the Gaussian blur effect on the background, you can achieve this:

```dart
class LivePage extends StatelessWidget {
  /// You can customize the liveID arbitrarily,
  /// just need to know: users who use the same liveID can talk with each other.
  final String liveID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLive(
        // input your appID
        appID: YourSecret.appID,
        // input your appSign
        appSign: YourSecret.appSign,
        // note that the userID needs to be globally unique,
        userID: userID,
        // user's name, we use userID as default name
        userName: 'user_$userID',
        // You can customize the liveID arbitrarily
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveConfig(
          // true if you are the host, false if you are a audience
          isHost: isHost,
          backgroundBuilder: backgroundBuilder,
        ),
      ),
    );
  }

  Widget backgroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    return Container(
      color: Colors.blue.withOpacity(0.2),
      child: Column(
        children: [
          Expanded(child: Container()),
          const Text(
            "hi, this is a custom background",
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xffffffff),
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
```

Effect:

![avview_bg_custom](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/avview_bg_custom.gif)

### custom foreground

If you need to add some custom components to the view, such as adding an avatar when displaying a video screen, adding a user level icon, etc., you can use `foregroundBuilder` to configure it. This callback is similar to other Flutter Builders and needs to be You return a Widget, and we will place the Widget you returned on top of the view.

For example: in video mode, add a user avatar to the lower left corner of the video screen, you can achieve this:

```dart
class LivePage extends StatelessWidget {
  /// You can customize the liveID arbitrarily,
  /// just need to know: users who use the same liveID can talk with each other.
  final String liveID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLive(
        // input your appID
        appID: YourSecret.appID,
        // input your appSign
        appSign: YourSecret.appSign,
        // note that the userID needs to be globally unique,
        userID: userID,
        // user's name, we use userID as default name
        userName: 'user_$userID',
        // You can customize the liveID arbitrarily
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveConfig(
          // true if you are the host, false if you are a audience
          isHost: isHost,
          foregroundBuilder: foregroundBuilder,
        ),
      ),
    );
  }

  Widget foregroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    return const Positioned(
      left: 120,
      top: 20,
      child: Icon(
        Icons.sunny,
        color: Colors.yellow,
      ),
    );
  }
}
```

Effect:

| Add a sun on the top right to user info                                                      |
| -------------------------------------------------------------------------------------------- |
| ![foreground_custom](https://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/live/foreground_custom.gif) |

It can be seen that the foreground will be displayed at the top right of user info.
