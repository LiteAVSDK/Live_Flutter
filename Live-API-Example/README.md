# TRTC Flutter API-Example 
[中文](README_zh-CN.md) | English

## Background
This open-source demo shows how to use some APIs of the [Live Flutter Plugin](https://intl.cloud.tencent.com/products/trtc) to help you better understand the APIs and use them to implement some basic TRTC features. 

## Contents
This demo covers the following features (click to view the details of a feature):

- Basic Features
  - [Camera Push](./lib/page/Push/LiveCameraPush.dart)
  - [Screen Share](./lib/page/Push/LiveScreenPush.dart)
  - [Live Streaming](./lib/page/Play/LivePlay.dart)
  - [Link-Mic](./lib/page/LinkMic/LiveLinkMicAnchor.dart)
  - [Link-PK](./lib/page/PK/LivePKAnchor.dart)

## Environment Requirements
- Flutter 2.0or above
- **Developing for Android:**
  - Android Studio 3.5 or above
  - Devices with Android 4.1 or above
- **Developing for iOS:**
  - Xcode 11.0 or above
  - Your project has a valid developer signature.

## Demo Run Example

#### Prerequisites
You have [signed up for a Tencent Cloud account](https://intl.cloud.tencent.com/document/product/378/17985) and completed [identity verification](https://intl.cloud.tencent.com/document/product/378/3629).


### Obtaining `SDKAPPID` and `SECRETKEY`
1. Log in to the TRTC console and select **Development Assistance** > **[Demo Quick Run](https://console.cloud.tencent.com/trtc/quickstart)**.
2. Enter an application name such as `TestTRTC`, and click **Create**.

![ #900px](https://main.qcloudimg.com/raw/169391f6711857dca6ed8cfce7b391bd.png)
3. Click **Next** to view your `SDKAppID` and key.


### Configuring demo project files
1. Open the [generate_test_user_sig.dart](debug/generate_test_user_sig.dart) file in the Debug directory.
2. Configure two parameters in the `generate_test_user_sig.dart` file:
  - `SDKAPPID`: `PLACEHOLDER` by default. Set it to the actual `SDKAppID`.
  - `SECRETKEY`: left empty by default. Set it to the actual key.
 ![ #900px](https://main.qcloudimg.com/raw/fba60aa9a44a94455fe31b809433cfa4.png)

3. Return to the TRTC console and click **Next**.
4. Click **Return to Overview Page**.

>!The method for generating `UserSig` described in this document involves configuring `SECRETKEY` in client code. In this method, `SECRETKEY` may be easily decompiled and reversed, and if your key is disclosed, attackers can steal your Tencent Cloud traffic. Therefore, **this method is suitable only for the local execution and debugging of the demo**.
>The correct `UserSig` distribution method is to integrate the calculation code of `UserSig` into your server and provide an application-oriented API. When `UserSig` is needed, your application can make a request to the business server for dynamic `UserSig`. For more information, please see [How to Calculate UserSig](https://intl.cloud.tencent.com/document/product/647/35166).


### Compiling and running the project
1. Run `flutter pub get`.
2. Compile, run, and debug the project.

####  Android
1. Run `flutter run`.
2. Open the demo project with Android Studio (3.5 or above), and click **Run**.

#### iOS
1. Run `pod install`.
2. Open the `/ios` demo project in the source code directory with Xcode (11.0 or above) and compile and run the demo project.

