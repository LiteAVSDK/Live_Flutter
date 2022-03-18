# live_flutter_plugin
[English](./README.md) | 简体中文

腾讯实时音视频（Tencent Real-Time Communication，TRTC）低延时互动直播方案
凭借行业领先的网络与音视频技术，结合腾讯云优质的节点资源，帮助开发者搭建卡顿率更低、延时1秒以内的互动直播，让直播走进 CDN 2.0 时代。

[移动直播Flutter插件主页](https://pub.dev/packages/live_flutter_plugin/versions)

## 功能特性
- 支持 RTMP, HTTP-FLV, TRTC 以及 WebRTC；
- 屏幕截图，可以截取当前直播流的视频画面；
- 延时调节，可以设置播放器缓存自动调整的最小和最大时间；
- 美颜、滤镜、贴纸，包含多套美颜磨皮算法（自然&光滑）和多款色彩空间滤镜（支持自定义滤镜）；
- Qos 流量控制技术，具备上行网络自适应能力，可以根据主播端网络的具体情况实时调节音视频数据量；

## plugin文件说明

```
.
├── manager
│   ├── tx_audio_effect_manager.dart  背景音乐、短音效和人声特效的管理类
│   ├── tx_beauty_manager.dart  美颜与图像处理参数设置类
│   ├── tx_device_manager.dart  音视频设备管理类
│   └── tx_live_manager.dart  音视频pusher/player生命周期管理模块类
├── v2_tx_live_code.dart  腾讯云直播服务(LVB)错误码和警告码的定义。
├── v2_tx_live_def.dart  腾讯云直播服务(LVB)关键类型定义
├── v2_tx_live_player.dart  腾讯云直播播放器-主要负责从指定的直播流地址拉取音视频数据，并进行解码和本地渲染播放。
├── v2_tx_live_player_observer.dart  腾讯云直播的播放器回调通知。
├── v2_tx_live_premier.dart  SDK配置、授权接口
├── v2_tx_live_pusher.dart  腾讯云直播推流器-主要负责将本地的音频和视频画面进行编码，并推送到指定的推流地址，支持任意的推流服务端。
├── v2_tx_live_pusher_observer.dart 腾讯云直播推流的回调通知。
└── widget
    └── v2_tx_live_video_widget.dart 视频播放视图RenderViewWidget

```


## 快速集成SDK
Flutter SDK 已经发布到 pub 库，您可以通过配置 pubspec.yaml 自动下载更新。

### 1. 在项目的 pubspec.yaml 中写如下依赖：

```dart
dependencies:
  live_flutter_plugin: latest version number

```
### 2. 开通摄像头和麦克风的权限，即可开启语音通话功能。

### iOS
#### 1.需要在 Info.plist 中加入对相机和麦克风的权限申请:

```dart
<key>NSCameraUsageDescription</key>
<string>授权摄像头权限才能正常视频通话</string>
<key>NSMicrophoneUsageDescription</key>
<string>授权麦克风权限才能正常语音通话</string>
```
#### 2. 开通摄像头和麦克风的权限，即可开启语音通话功能。

### Android

#### 1. 打开 /android/app/src/main/AndroidManifest.xml 文件。
#### 2. 将 xmlns:tools="http://schemas.android.com/tools" 加入到 manifest 中。
#### 3. 将 tools:replace="android:label" 加入到 application 中。
>Note: 若不执行此步，会出现 Android Manifest merge failed 编译失败 问题。

![](https://main.qcloudimg.com/raw/7a37917112831488423c1744f370c883.png)

## 快速开始

### 1. 配置[License授权](./example/README_zh-CN.md)

```dart
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';

 /// 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
setupLicense() {
  // 当前应用的License LicenseUrl
  var LICENSEURL = "";
  // 当前应用的License Key
  var LICENSEURLKEY = "";
  V2TXLivePremier.setLicence(LICENSEURL, LICENSEURLKEY);
}

```

### 2. 设置推流端
>note: 请使用一台真机设备，不支持模拟器。

#### 2.1 初始化V2TXLivePusher
```dart
import 'package:live_flutter_plugin/v2_tx_live_pusher.dart';

/// V2TXLivePusher 初始化
initPusher() {
  _livePusher = V2TXLivePusher(V2TXLiveMode.v2TXLiveModeRTC);
  /// 设置Pusher回调
  _livePusher.addListener(onPusherObserver);
}

/// pusher回调
onPusherObserver(V2TXLivePusherListenerType type, param) {
  debugPrint("==pusher listener type= ${type.toString()}");
  debugPrint("==pusher listener param= $param");
}

```

#### 2.2 设置视频渲染RenderView

```dart
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

/// 视频渲染View Widget
Widget renderView() {
  return V2TXLiveVideoWidget(
    onViewCreated: (viewId) async {
      /// 设置视频渲染View
      _livePusher.setRenderViewID(_renderViewId);
    },
  );
}

```

#### 2.3 开始推流

```dart
/// 开始推流
startPush() async {
  // 打开摄像头
  await _livePusher.startCamera(true);
  // 打开麦克风
  await _livePusher.startMicrophone();
  // 生成推流地址 RTMP/TRTC
  var url = "";
  // 开始推流
  await _livePusher.startPush(url);
}

```

#### 2.4 停止推流
```dart
/// 停止推流
stopPush() async {
  // 关闭摄像头
  await _livePusher.stopCamera();
  // 关闭麦克风
  await _livePusher.stopMicrophone();
  // 停止推流
  await _livePusher.stopPush();
}

```

### 3. 设置拉流端
>note: 请使用另外一台设备配合推流端测试。

#### 3.1 初始化V2TXLivePlayer

```dart
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
/// 初始化V2TXLivePlayer
initPlayer() {
  _livePlayer = V2TXLivePlayer();
  _livePlayer.addListener(onPlayerObserver);
}

/// Player 回调
onPlayerObserver(V2TXLivePlayerListenerType type, param) {
  debugPrint("==player listener type= ${type.toString()}");
  debugPrint("==player listener param= $param");
}
```

#### 3.2 设置视频渲染RenderView

```dart
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

/// 视频渲染View Widget
Widget renderView() {
  return V2TXLiveVideoWidget(
    onViewCreated: (viewId) async {
      // 设置视频渲染View
      _livePlayer.setRenderViewID(_renderViewId);
    },
  );
}

```

#### 3.3 开始拉流

```dart
/// 开始拉流
startPlay() async {
  // 生成拉流url RTMP/TRTC/Led
  var url = ""
  // 开始拉流
  await _livePlayer?.startPlay(url);
}
```

#### 3.4 停止拉流
```dart
/// 停止拉流
stopPlay() {
  _livePlayer.stopPlay();
}
```

## 常见问题

更多常见问题参考[文档](https://cloud.tencent.com/document/product/647/51623)

## iOS无法显示视频（Android是好的）

请确认 io.flutter.embedded_views_preview为`YES`在你的info.plist中

## Android Manifest merge failed编译失败

请打开/example/android/app/src/main/AndroidManifest.xml文件。

1.将xmlns:tools="http://schemas.android.com/tools" 加入到manifest中

2.将tools:replace="android:label"加入到application中。

![图示](https://main.qcloudimg.com/raw/7a37917112831488423c1744f370c883.png)

