
import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

import '../debug/GenerateTestUserSig.dart';
class URLUtils {

  /// md5 加密
  static String generate_MD5(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  static String _getSafeUrl(String streamId) {
    var date = DateTime.now().millisecondsSinceEpoch~/1000+60*60;
    var hexTime = date.toRadixString(16).toUpperCase();
    var secret = "${GenerateTestUserSig.LIVE_URL_KEY}$streamId$hexTime";
    var txSecret = generate_MD5(secret);
    return "txSecret=$txSecret&txTime=$hexTime";
  }

  static String generateRandomUserId() {
    var rng = new Random();//随机数生成类
    var userId = rng.nextInt(10000-1)+10000000;
    return "$userId";
  }

  static String generateRandomStreamId() {
    var rng = new Random();//随机数生成类
    var streamId = rng.nextInt(10000-1)+10000000;
    return "$streamId";
  }

  static String generateRtmpPushUrl(String streamId) {
    return "rtmp://${GenerateTestUserSig.PUSH_DOMAIN}/live/$streamId?${_getSafeUrl(streamId)}";
  }
  static String generateRtmpPlayUrl(String streamId) {
    return "rtmp://${GenerateTestUserSig.PLAY_DOMAIN}/live/$streamId";
  }

  static String generateTRTCPushUrl(String streamId, String? userId) {
    var userIdString = userId;
    if (userIdString == null || userIdString.isEmpty) {
      userIdString = streamId;
    }
    var usersig = GenerateTestUserSig.genTestSig(userIdString);
    return "trtc://cloud.tencent.com/push/$streamId?sdkappid=${GenerateTestUserSig.sdkAppId}&userid=$userIdString&usersig=$usersig";
  }

  static String generateTRTCPlayUrl(String streamId, String? userId) {
    var userIdString = userId;
    if (userIdString == null || userIdString.isEmpty) {
      userIdString = generateRandomUserId();
    }
    var usersig = GenerateTestUserSig.genTestSig(userIdString);
    return "trtc://cloud.tencent.com/play/$streamId?sdkappid=${GenerateTestUserSig.sdkAppId}&userid=$userIdString&usersig=$usersig";
  }

  static String generateLedPlayUrl(String streamId) {
    return "webrtc://${GenerateTestUserSig.PLAY_DOMAIN}/live/$streamId";
  }

}