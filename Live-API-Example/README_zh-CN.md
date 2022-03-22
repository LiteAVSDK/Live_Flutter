# live_flutter_plugin-Example 
中文 | [English](README.md)

## 前言
这个Demo主要演示了 [Live Flutter Plugin 移动直播](https://cloud.tencent.com/document/product/454) 部分API的使用示例，帮助开发者可以更好的理解 TRTC 实时音视频 Flutter SDK 的API，从而快速实现一些音视频场景的基本功能。 

## 结构说明
在这个示例项目中包含了以下场景:（带上对应的跳转目录，方便用户快速浏览感兴趣的功能）

- 基础功能
  - [直播推流](./lib/page/Push/LiveCameraPush.dart)
  - [屏幕分享](./lib/page/Push/LiveScreenPush.dart)
  - [直播拉流](./lib/page/Play/LivePlay.dart)
  - [连麦互动](./lib/page/LinkMic/LiveLinkMicAnchor.dart)
  - [PK互动](./lib/page/PK/LivePKAnchor.dart)
  

## 环境准备
- Flutter 2.0 及以上版本。
- **Android 端开发：**
  - Android Studio 3.5及以上版本。
  - App 要求 Android 4.1及以上版本设备。
- **iOS & macOS 端开发：**
  - Xcode 11.0及以上版本。
  - osx 系统版本要求 10.11 及以上版本
  - 请确保您的项目已设置有效的开发者签名。
  
## 运行示例

### 前提条件
您已 [注册腾讯云](https://cloud.tencent.com/document/product/378/17985) 账号，并完成 [实名认证](https://cloud.tencent.com/document/product/378/3629)。


### 申请 SDKAPPID 和 SECRETKEY
1. 登录实时音视频控制台，选择【开发辅助】>【[快速跑通Demo](https://console.cloud.tencent.com/trtc/quickstart)】。
2. 单击【立即开始】，输入您的应用名称，例如`TestTRTC`，单击【创建应用】。

![](https://main.qcloudimg.com/raw/169391f6711857dca6ed8cfce7b391bd.png)
3. 创建应用完成后，单击【我已下载，下一步】，可以查看 SDKAppID 和密钥信息。


### 配置 Demo 工程文件
1. 打开 Debug 目录下的 [generate_test_user_sig.dart](debug/generate_test_user_sig.dart) 文件。
2. 配置`generate_test_user_sig.dart`文件中的两个参数：
  - SDKAPPID：替换该变量值为上一步骤中在页面上看到的 SDKAppID。
  - SECRETKEY：替换该变量值为上一步骤中在页面上看到的密钥。
 ![ #900px](https://main.qcloudimg.com/raw/fba60aa9a44a94455fe31b809433cfa4.png)

4. 返回实时音视频控制台，单击【粘贴完成，下一步】。
5. 单击【关闭指引，进入控制台管理应用】。

>!本文提到的生成 UserSig 的方案是在客户端代码中配置 SECRETKEY，该方法中 SECRETKEY 很容易被反编译逆向破解，一旦您的密钥泄露，攻击者就可以盗用您的腾讯云流量，因此**该方法仅适合本地跑通 Demo 和功能调试**。
>正确的 UserSig 签发方式是将 UserSig 的计算代码集成到您的服务端，并提供面向 App 的接口，在需要 UserSig 时由您的 App 向业务服务器发起请求获取动态 UserSig。更多详情请参见 [服务端生成 UserSig](https://cloud.tencent.com/document/product/647/17275#Server)。


### 编译运行
1.执行`flutter pub get`

2.Android调试：
* （1）可以执行`flutter run`
* （2）可以使用 Android Studio（3.5及以上的版本）打开源码工程，单击【运行】即可。
  
3.iOS调试：
*  (1) cd ios
*  (2) pod install
*  (3) 使用 XCode（11.0及以上的版本）打开源码目录下的 /ios工程，编译并运行 Demo 工程即可。


### 常见问题

更多常见问题参考[文档](https://cloud.tencent.com/document/product/647/51623)

##### iOS无法显示视频（Android是好的）

请确认 io.flutter.embedded_views_preview为`YES`在你的info.plist中

##### Android Manifest merge failed编译失败

请打开/example/android/app/src/main/AndroidManifest.xml文件。

1.将xmlns:tools="http://schemas.android.com/tools" 加入到manifest中

2.将tools:replace="android:label"加入到application中。

![图示](https://main.qcloudimg.com/raw/7a37917112831488423c1744f370c883.png)

##### 更新 SDK 版本后，iOS CocoaPods 运行报错？
1. 删除 iOS 目录下 `Podfile.lock` 文件。
2. 执行 `pod repo update`。
3. 执行 `pod install`。
4. 重新运行。
