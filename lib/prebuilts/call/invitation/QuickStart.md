# Quick start (with call invitation)

---
<img src="http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/invitation/invitee_voice_accept.gif" width=300>

## Add ZegoUIKitPrebuiltCall as dependencies

1. Unzip `zego_uikit.zip` and place it at the same level as your project's root directory
   <img src="http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/import_zip_to_project.png" width=600>

2. Edit your project's pubspec.yaml and add local project dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  zego_uikit:           # Add this line
    path: ../zego_uikit # Add this line
```

3. Execute the command as shown below under your project's root folder to install all dependencies

```
flutter pub get
```

## Import SDK

Now in your Dart code, you can import prebuilt.

```dart
import 'package:zego_uikit/prebuilts/call.dart';
```

## Integrate the call functionality with the invitation feature

### 1. Initialize the invitation service

> You can get the AppID, AppSign and AppSecret from [ZEGOCLOUD's Console](https://console.zegocloud.com).
> Users who use the same callID can talk to each other. (ZegoUIKitPrebuiltCall supports 1 on 1 call for now, and will support group call soon)

We recommend you wrap the `ZegoUIKitPrebuiltCallWithInvitation` in your widget after your user login:

```dart
@override
Widget build(BuildContext context) {
   return ZegoUIKitPrebuiltCallWithInvitation(
      appID: /*Your App ID*/,
      appSecret: '/*Your App Secret*/',
      appSign: kIsWeb ? '' : /*Your App Sign*/,
      userID: user_id, // userID should only contain numbers, English characters and  '_'
      userName: 'user_name',
      //  we will ask you for config when we need it, you can customize your app with data
      requireConfig: (ZegoCallInvitationData data) {
         return ZegoUIKitPrebuiltCallConfig();
      },
      child: /*your widget*/,
   );
}
```

### 2. Add a button for making a call

```dart
ZegoStartCallCallInvitation(
   isVideoCall: true,
   invitees: [
      ZegoUIKitUser(
         id: user_id,
         name: 'user_name',
      )
   ],
)
```

**Now, you can invite someone to the call by simply clicking this button.**

## How to customize the calling page?
> this example is try to make different menubar between audio call or video call
```
@override
Widget build(BuildContext context) {
   return ZegoUIKitPrebuiltCallWithInvitation(
      appID: /*Your App ID*/,
      appSecret: '/*Your App Secret*/',
      appSign: kIsWeb ? '' : /*Your App Sign*/,
      userID: user_id, // userID should only contain numbers, English characters and  '_'
      userName: 'user_name',
      //  we will ask you for config when we need it, you can customize your app with data
      requireConfig: (ZegoCallInvitationData data) {
        var config = ZegoUIKitPrebuiltCallConfig();
        if (ZegoInvitationType.videoCall == data.type) {
          config.menuBarExtendButtons = [
            IconButton(color: Colors.white, icon: const Icon(Icons.phone), onPressed:() {}),
            IconButton(color: Colors.white, icon: const Icon(Icons.cookie), onPressed:() {}),
            IconButton(color: Colors.white, icon: const Icon(Icons.speaker), onPressed:() {}),
            IconButton(color: Colors.white, icon: const Icon(Icons.air), onPressed:() {}),
          ];
        }
        return config;
      },
      child: /*your widget*/,
   );
}
```
![customize_config](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/invitation/customize_config.gif)

## How to run

### 1. Config your project

#### Android

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
   <uses-permission android:name="android.permission.VIBRATE"/>
   ```
<img src="http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/invitation/permission_android.png" width=800>

#### iOS

Need add app permissions, open ·your_project/ios/Runner/Info.plist·, add the following code inside the "dict" tag:

```plist
<key>NSCameraUsageDescription</key>
<string>We require camera access to connect to a call</string>
<key>NSMicrophoneUsageDescription</key>
<string>We require microphone access to connect to a call</string>
```
<img src="http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/permission_ios.png" width=800>

### 2. Build & Run

Now you can simply click the "Run" or "Debug" button to build and run your App on your device.
![/Pics/ZegoUIKit/Flutter/run_flutter_project.jpg](http://doc.oa.zego.im/Pics/ZegoUIKit/Flutter/run_flutter_project.jpg)

## Related guide

[Custom prebuilt UI](!ZEGOUIKIT_Custom_prebuilt_UI)
