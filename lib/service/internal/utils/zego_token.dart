// Dart imports:
import 'dart:convert';
import 'dart:core';
import 'dart:math' as math;
import 'dart:typed_data';

// Package imports:
import 'package:encrypt/encrypt.dart' as encrypt;

// Project imports:
import 'string_utils.dart';

class TokenInfo04 {
  int appid;
  String userID;
  int nonce;
  int ctime;
  int expire;
  String payload;

  String toJson() {
    return '{"app_id":$appid,"user_id":"$userID","nonce":$nonce,"ctime":$ctime,"expire":$expire,"payload":"$payload"}';
  }

  TokenInfo04(
      {required this.appid,
      required this.userID,
      required this.ctime,
      required this.expire,
      required this.nonce,
      required this.payload});
}

//生成04版本版本的token
Future<String> generateZegoToken(int appID, String userID, String secret,
    {int effectiveTimeInSeconds = 60 * 60 * 24, String payload = ""}) async {
  if (appID == 0) {
    throw "appID Invalid";
  }
  if (userID == "") {
    throw "userID Invalid";
  }
  if (secret.length != 32) {
    throw "secret Invalid";
  }
  if (effectiveTimeInSeconds <= 0) {
    throw "effectiveTimeInSeconds Invalid";
  }
  var tokenInfo = TokenInfo04(
    appid: appID,
    userID: userID,
    nonce: math.Random().nextInt(math.pow(2, 31).toInt()),
    ctime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    expire: 0,
    payload: payload,
  );
  tokenInfo.expire = tokenInfo.ctime + effectiveTimeInSeconds;
  // Convert token information to json
  final tokenJson = tokenInfo.toJson();

  // Randomly generated 16-byte string, used as AES encryption vector,
  // before the ciphertext for Base64 encoding to generate the final token
  String ivStr = StringUtils.makeRandomString(16);
  var iv = encrypt.IV.fromUtf8(ivStr);

  final key = encrypt.Key.fromUtf8(secret);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(tokenJson, iv: iv);

  // // this way need to do endian conversion, too troublesome
  // Uint8List maybeLittleEndian = Uint32List.fromList([tokenInfo.expire]).buffer.asUint8List();
  // var fixedExpire = ByteData.sublistView(maybeLittleEndian).getUint32(0, Endian.big);
  // Uint8List BigEndianBytes = Uint32List.fromList([0,fixedExpire]).buffer.asUint8List();

  // use radix insted
  Uint8List bytes1 = Hex.createUint8ListFromInt(tokenInfo.expire);
  Uint8List bytes2 = Uint8List.fromList([0, 16]);
  Uint8List bytes3 = Uint8List.fromList(utf8.encode(ivStr));
  Uint8List bytes4 = Uint8List.fromList([0, encrypted.bytes.length]);
  Uint8List bytes5 = encrypted.bytes;

  var bytes = Uint8List(4) + bytes1 + bytes2 + bytes3 + bytes4 + bytes5;
  var ret = '04${base64.encode(bytes)}';
  return ret;
}
