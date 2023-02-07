part of 'zego_uikit.dart';

mixin ZegoUIKitUserService {
  // todo rename to sign in?
  Future<void> login(String id, String name) async {
    ZegoUIKitCore.shared.login(id, name);
  }

  Future<void> logout() async {
    return await ZegoUIKitCore.shared.logout();
  }

  ZegoUIKitUser getUser({String? userID}) {
    if ((userID == null) ||
        userID == ZegoUIKitCore.shared.coreData.localUser.id) {
      return ZegoUIKitCore.shared.coreData.localUser.toZegoUikitUser();
    } else {
      return ZegoUIKitCore.shared.coreData.remoteUser[userID]
              ?.toZegoUikitUser() ??
          ZegoUIKitUser(id: '', name: '');
    }
  }

  Stream<List<ZegoUIKitUser>> createUserListStream() {
    return ZegoUIKitCore.shared.coreData.streamControllerUserList.stream.map(
      (event) =>
          event.entries.map((entry) => entry.value.toZegoUikitUser()).toList(),
    );
  }
}
