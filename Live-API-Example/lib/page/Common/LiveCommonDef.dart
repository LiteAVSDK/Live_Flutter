

enum LivePageType {
  /// 摄像头推流
  cameraPush,
  /// 屏幕分享
  screenPush,
  /// 直播拉流
  livePlay,
  /// PK互动
  pk,
  /// 连麦互动
  linkMic,
}

/// 直播角色
enum LiveRoleType {
  /// 观众
  audience,
  /// 主播
  annchor,
}