// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/service/zego_uikit.dart';

import 'package:zego_uikit/prebuilts/call/call_config.dart';
import 'package:zego_uikit/prebuilts/call/invitation/defines.dart';
import 'package:zego_uikit/prebuilts/call/invitation/internal/page_service.dart';

typedef ContextQuery = BuildContext Function();
typedef ConfigQuery = ZegoUIKitPrebuiltCallConfig Function(
    ZegoCallInvitationData);

class ZegoCallInvitationService {
  ZegoCallInvitationService._internal();

  factory ZegoCallInvitationService() => instance;
  static final ZegoCallInvitationService instance =
      ZegoCallInvitationService._internal();

  late int appID;
  late String appSign;
  late String appSecret;
  late String userID;
  late String userName;
  late String tokenServerUrl;

  ///
  late ConfigQuery configQuery;

  /// we need a context object, to push/pop page when receive invitation request
  ///
  /// example:
  /// ------------------------------------------------------------------------
  /// import 'package:get_it/get_it.dart';
  ///
  /// GetIt locator = GetIt.instance;
  ///
  /// class NavigationService {
  ///   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ///
  ///   void init() {
  ///     locator.registerLazySingleton(() => NavigationService());
  ///   }
  /// }
  /// ------------------------------------------------------------------------
  ///
  /// you should register this object to app's navigation key by followed:
  ///
  /// void main() {
  ///   /// 1. init navigation service before run app
  ///   NavigationService().init();
  ///
  ///   runApp(const MyApp());
  /// }
  ///
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       /// 2. register app navigator key
  ///       navigatorKey: locator<NavigationService>().navigatorKey,
  ///     );
  ///   }
  /// }
  ///
  /// ZegoUIKitPrebuiltCallInvitationService.instance.init(
  ///   appID: ZegoSecret.appID,
  ///   appSecret: ZegoSecret.secret,
  ///   appSign: kIsWeb ? '' : ZegoSecret.appSign,
  ///   userID: widget.localUserID,
  ///   userName: 'user_${widget.localUserID}',
  ///   configQuery: (ZegoCallInvitationData data) {
  ///      return getCallConfig();
  ///    },
  ///   3. register a query callback
  ///   contextQuery: () {
  ///     return locator<NavigationService>().navigatorKey.currentContext!;
  ///   },
  /// );
  ///
  late ContextQuery contextQuery;

  Future<void> init({
    required int appID,
    String appSign = '',
    String appSecret = '',
    String tokenServerUrl = '',
    required String userID,
    required String userName,
    required ConfigQuery configQuery,
    required ContextQuery contextQuery,
  }) async {
    this.appID = appID;
    this.appSign = appSign;
    this.appSecret = appSecret;
    this.userID = userID;
    this.userName = userName;
    this.configQuery = configQuery;
    this.tokenServerUrl = tokenServerUrl;
    this.contextQuery = contextQuery;

    await ZegoUIKit()
        .init(appID: appID, appSign: appSign, tokenServerUrl: tokenServerUrl);
    await ZegoUIKit().loadZIM(appID: appID, appSecret: appSecret);
    await ZegoUIKit().login(userID, userName);

    ZegoInvitationPageService.instance.init();

    debugPrint(
      'zim init, appID:$appID, appSign:$appSign, appSecret:$appSecret, tokenServerUrl:$tokenServerUrl, userID:$userID, userName:$userName',
    );
  }

  Future<void> uninit() async {
    debugPrint('zim uninit');

    await ZegoUIKit().logout();
    await ZegoUIKit().unloadZim();
    await ZegoUIKit().uninit();
  }

  Future<void> reLogin(String userID, String userName) async {
    if (this.userID == userID && this.userName == userName) {
      debugPrint("same user, cancel this reLogin");
      return;
    }

    await ZegoUIKit().logout();

    this.userID = userID;
    this.userName = userName;
    await ZegoUIKit().login(userID, userName);
  }
}
