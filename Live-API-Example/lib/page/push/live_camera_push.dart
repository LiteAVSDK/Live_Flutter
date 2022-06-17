import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

import 'package:live_flutter_plugin/manager/tx_audio_effect_manager.dart';
import 'package:live_flutter_plugin/manager/tx_beauty_manager.dart';
import 'package:live_flutter_plugin/manager/tx_device_manager.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_pusher.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';
import 'package:live_flutter_plugin/v2_tx_live_pusher_observer.dart';

import '../../utils/url_utils.dart';
import 'settings/live_beauty_setting.dart';
import 'settings/live_audio_setting.dart';

/// 摄像头推流
class LiveCameraPushPage extends StatefulWidget {
  final V2TXLiveMode liveMode;
  final V2TXLiveAudioQuality audioQuality;
  final String streamId;

  const LiveCameraPushPage(
      {Key? key,
      required this.audioQuality,
      required this.streamId,
      required this.liveMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveCameraPushPageState();
  }
}

class _LiveCameraPushPageState extends State<LiveCameraPushPage> {

  /// 分辨率
  V2TXLiveVideoResolution _resolution =
      V2TXLiveVideoResolution.v2TXLiveVideoResolution1280x720;

  /// 旋转角度
  V2TXLiveRotation _liveRotation = V2TXLiveRotation.v2TXLiveRotation0;

  /// 摄像头
  V2TXLiveMirrorType _liveMirrorType =
      V2TXLiveMirrorType.v2TXLiveMirrorTypeAuto;

  bool _isEnableBeauty = false;
  /// 音频设置
  bool _microphoneEnable = true;
  TXDeviceManager? _txDeviceManager;
  TXBeautyManager? _txBeautyManager;
  TXAudioEffectManager? _txAudioManager;

  /// 美颜设置数据
  final LiveBeautySettings _beautySettings = LiveBeautySettings();
  /// 音频数据
  final LiveAudioSettings _audioSettings = LiveAudioSettings();
  int? _localViewId;
  V2TXLivePusher? _livePusher;

  @override
  void initState() {
    super.initState();
    initLive();
  }

  @override
  void deactivate() {
    debugPrint("Live-Camera push deactivate");
    _livePusher?.removeListener(onPusherObserver);
    _livePusher?.stopMicrophone();
    _livePusher?.stopCamera();
    _livePusher?.stopPush();
    resetBeautySetting();
    _livePusher?.destroy();
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint("Live-Camera push dispose");
    super.dispose();
  }

  initLive() async {
    await initPlatformState();
    // 获取设备管理模块
    _txDeviceManager = _livePusher?.getDeviceManager();
    // 获取美颜管理对象
    _txBeautyManager = _livePusher?.getBeautyManager();
    // 获取音效管理类 TXAudioEffectManager
    _txAudioManager = _livePusher?.getAudioEffectManager();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePusher = await V2TXLivePusher.create(widget.liveMode);
    _livePusher?.addListener(onPusherObserver);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      debugPrint("CreatePusher result is ${_livePusher?.status}");
    });
  }

  onPusherObserver(V2TXLivePusherListenerType type, param) {
    debugPrint("==pusher listener type= ${type.toString()}");
    debugPrint("==pusher listener param= $param");

    if (type == V2TXLivePusherListenerType.onMusicObserverStart) {
      setState(() {
        _audioSettings.isPlaying = true;
      });
    }
    if (type == V2TXLivePusherListenerType.onMusicObserverPlayProgress) {

    }
    if (type == V2TXLivePusherListenerType.onMusicObserverComplete) {
      setState(() {
        _audioSettings.isPlaying = false;
      });
    }
  }

  startPush() async {
    if (_livePusher == null) {
      return;
    }
    await _livePusher?.setRenderMirror(_liveMirrorType);
    var videoEncoderParam = V2TXLiveVideoEncoderParam();
    videoEncoderParam.videoResolution = _resolution;
    videoEncoderParam.videoResolutionMode =
        V2TXLiveVideoResolutionMode.v2TXLiveVideoResolutionModePortrait;
    await _livePusher?.setVideoQuality(videoEncoderParam);
    await _livePusher?.setAudioQuality(widget.audioQuality);

    if (_localViewId != null) {
      var code = await _livePusher?.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        showErrordDialog("StartPush error： please check remoteView load");
        return;
      }
    }
    var cameraCode = await _livePusher?.startCamera(true);
    if (cameraCode == null || cameraCode != V2TXLIVE_OK) {
      debugPrint("cameraCode: $cameraCode");
      showErrordDialog("Camera push error：please check Camera system auth.");
      return;
    }
    var url = URLUtils.generateTRTCPushUrl(widget.streamId, null);
    if (widget.liveMode == V2TXLiveMode.v2TXLiveModeRTMP) {
      url = URLUtils.generateRtmpPushUrl(widget.streamId);
    }
    debugPrint("推流地址： $url");
    var pushCode = await _livePusher?.startPush(url);
    if (pushCode == null || pushCode != V2TXLIVE_OK) {
      showErrordDialog(
          "Camera push error：($pushCode) please check push url or LicenceURL");
      return;
    }
    if (_microphoneEnable) {
      await _livePusher?.startMicrophone();
    }
    var isFrontCamera = await _txDeviceManager?.isFrontCamera();
    debugPrint("current device isFrontCamera: $isFrontCamera");
  }

  stopPush() async {
    await _livePusher?.stopMicrophone();
    await _livePusher?.stopCamera();
    await _livePusher?.stopPush();
  }

  resetBeautySetting() async {
    _txBeautyManager?.setWhitenessLevel(0);
    _txBeautyManager?.setRuddyLevel(0);
    _txBeautyManager?.setBeautyLevel(0);
  }

  void setMicrophone(bool enable) async {
    if (enable) {
      var code = await _livePusher?.startMicrophone();
      if (code != null && code == V2TXLIVE_OK) {
        setState(() {
          _microphoneEnable = true;
        });
      } else {
        showErrordDialog("please check microphone system auth");
        setState(() {
          _microphoneEnable = false;
        });
      }
    } else {
      await _livePusher?.stopMicrophone();
      setState(() {
        _microphoneEnable = enable;
      });
    }
  }

  void setLiveMirrorType(V2TXLiveMirrorType type) async {
    await _livePusher?.setRenderMirror(type);
    setState(() {
      _liveMirrorType = type;
    });
  }

  String _liveMirrorTitle() {
    if (_liveMirrorType == V2TXLiveMirrorType.v2TXLiveMirrorTypeAuto) {
      // front camera mirror only
      return "Auto";
    } else if (_liveMirrorType == V2TXLiveMirrorType.v2TXLiveMirrorTypeEnable) {
      // front and background camera mirror both
      return "Enable";
    } else {
      // front and background camera mirror disable
      return "Disable";
    }
  }

  void setLiveRotation(V2TXLiveRotation rotation) async {
    var code = await _livePusher?.setRenderRotation(rotation);
    debugPrint("setLiveRotation code: $code, rotation: $rotation ");
    if (code == V2TXLIVE_OK) {
      setState(() {
        _liveRotation = rotation;
      });
    } else {
      showErrordDialog("setLiveRotation error: code-$code");
    }
  }

  String _liveRotationTitle() {
    if (_liveRotation == V2TXLiveRotation.v2TXLiveRotation0) {
      return "0";
    } else if (_liveRotation == V2TXLiveRotation.v2TXLiveRotation90) {
      return "90";
    } else if (_liveRotation == V2TXLiveRotation.v2TXLiveRotation180) {
      return "180";
    } else {
      return "270";
    }
  }

  void setLiveVideoResolution(V2TXLiveVideoResolution resolution) async {
    var videoEncoderParam = V2TXLiveVideoEncoderParam();
    videoEncoderParam.videoResolution = resolution;
    await _livePusher?.setVideoQuality(videoEncoderParam);
    setState(() {
      _resolution = resolution;
    });
  }

  String _liveResolutionTitle() {
    if (_resolution == V2TXLiveVideoResolution.v2TXLiveVideoResolution640x360) {
      return "360P";
    } else if (_resolution ==
        V2TXLiveVideoResolution.v2TXLiveVideoResolution960x540) {
      return "540P";
    } else if (_resolution ==
        V2TXLiveVideoResolution.v2TXLiveVideoResolution1280x720) {
      return "720P";
    } else if (_resolution ==
        V2TXLiveVideoResolution.v2TXLiveVideoResolution1920x1080) {
      return "1080P";
    } else {
      return "unknown";
    }
  }

  bool _isStartPush = false;
  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        _localViewId = viewId;
        if (_isStartPush == false) {
          _isStartPush = true;
          Future.delayed(const Duration(seconds: 1), (){
            startPush();
          });
        }
      },
    );
  }

  // sdk出错信查看
  Future<bool?> showErrordDialog(errorMsg) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Alert"),
          content: Text(errorMsg),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 打开美颜面板
  void _showModalBeautySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return LiveBeautySheetPage(
          settings: _beautySettings,
          onRuddyValueChanged: (value) async {
            debugPrint("onRuddyValueChanged: $value");
            await _txBeautyManager?.setRuddyLevel(value);
          },
          onWhitenessValueChanged: (value) async {
            debugPrint("onWhitenessValueChanged: $value");
            await _txBeautyManager?.setWhitenessLevel(value);
          },
          onPituValueChanged: (value) async {
            debugPrint("onPituValueChanged: $value");
            await _txBeautyManager?.setBeautyStyle(TXBeautyStyle.tXBeautyStylePitu);
            await _txBeautyManager?.setBeautyLevel(value);
          },
        );
      },
    );
  }

  /// 打开音效面板
  void _showModalAudioSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return LiveAudioSheetPage(
          settings: _audioSettings,
          onMusicStartPlay: () async {
            debugPrint("onMusicStartPlay");
            await _txAudioManager?.startPlayMusic(_audioSettings.musicParam);
          },
          onMusicPausePlay: () async {
            debugPrint("onMusicPausePlay");
            await _txAudioManager?.pausePlayMusic(_audioSettings.musicParam.id);
          },
          onMusicStopPlay: () async {
            debugPrint("onMusicStopPlay");
            await _txAudioManager?.stopPlayMusic(_audioSettings.musicParam.id);
          },
          onAllMusicVolumeChanged: (value) async {
            debugPrint("onAllMusicVolumeChanged: $value");
            await _txAudioManager?.setAllMusicVolume(value);
          },
          onPublishVolumeChanged: (value) async {
            debugPrint("onPublishVolumeChanged: $value");
            await _txAudioManager?.setMusicPublishVolume(
                _audioSettings.musicParam.id, value);
          },
          onLocalVolumeChanged: (value) async {
            debugPrint("onLocalVolumeChanged: $value");
            await _txAudioManager?.setMusicPlayoutVolume(
                _audioSettings.musicParam.id, value);
          },
          onMusicPitchChanged: (value) async {
            debugPrint("onMusicPitchChanged: $value");
            await _txAudioManager?.setMusicPitch(
                _audioSettings.musicParam.id, value);
          },
          onSpeedRateChanged: (value) async {
            debugPrint("onSpeedRateChanged: $value");
            await _txAudioManager?.setMusicSpeedRate(
                _audioSettings.musicParam.id, value);
          },
        );
      },
    );
  }

  void _enableCustomBeauty() {
    _isEnableBeauty = !_isEnableBeauty;
    var enableCustomVideo = _livePusher?.enableCustomVideoProcess(_isEnableBeauty);
    debugPrint("enable custom VideoProcess: $enableCustomVideo");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.streamId),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: ConstrainedBox(
          // color: Colors.black12,
          constraints: const BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: Center(
                  child: renderView(),
                ),
                color: Colors.black,
              ),
              Positioned(
                bottom: 40.0,
                left: 10,
                right: 10,
                child: Container(
                  // color: Colors.black12,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          height: 80,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Offstage(
                                  offstage: false,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text("Audio Settings",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Offstage(
                                          offstage: false,
                                          child: ElevatedButton(
                                            child: const Text(
                                              "audio settings",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onPressed: () {
                                              _showModalAudioSheet(context);
                                            },
                                          ),
                                        )),
                                    const Spacer(flex: 1)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          height: 80,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text("Enable Beauty",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        child: const Text(
                                          "enable Beauty",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () {
                                          _enableCustomBeauty();
                                        },
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          height: 80,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text("Beauty Settings",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        child: const Text(
                                          "Beauty settings",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () {
                                          _showModalBeautySheet(context);
                                        },
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          height: 80,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text("microphone Settings",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        child: Text(
                                          _microphoneEnable ? "open" : "close",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () {
                                          setMicrophone(!_microphoneEnable);
                                        },
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          height: 80,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text("videoSettings",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text("Resolution",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  child: Text(
                                                    _liveResolutionTitle(),
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.grey),
                                                  ),
                                                  onPressed: () {
                                                    showAdaptiveActionSheet(
                                                      context: context,
                                                      title: null,
                                                      androidBorderRadius: 30,
                                                      actions: <
                                                          BottomSheetAction>[
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '360P',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveVideoResolution(
                                                                  V2TXLiveVideoResolution
                                                                      .v2TXLiveVideoResolution640x360);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '540P',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveVideoResolution(
                                                                  V2TXLiveVideoResolution
                                                                      .v2TXLiveVideoResolution960x540);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '720P',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveVideoResolution(
                                                                  V2TXLiveVideoResolution
                                                                      .v2TXLiveVideoResolution1280x720);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '1080P',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveVideoResolution(
                                                                  V2TXLiveVideoResolution
                                                                      .v2TXLiveVideoResolution1920x1080);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                      ],
                                                      cancelAction: CancelAction(
                                                          title: const Text(
                                                              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                    );
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                    Expanded(
                                      flex: 5,
                                      child: Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text("Rotation",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  child: Text(
                                                    _liveRotationTitle(),
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.grey),
                                                  ),
                                                  onPressed: () {
                                                    showAdaptiveActionSheet(
                                                      context: context,
                                                      title: null,
                                                      androidBorderRadius: 30,
                                                      actions: <
                                                          BottomSheetAction>[
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '0',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveRotation(
                                                                  V2TXLiveRotation
                                                                      .v2TXLiveRotation0);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '90',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveRotation(
                                                                  V2TXLiveRotation
                                                                      .v2TXLiveRotation90);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '180',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveRotation(
                                                                  V2TXLiveRotation
                                                                      .v2TXLiveRotation180);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                '270',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveRotation(
                                                                  V2TXLiveRotation
                                                                      .v2TXLiveRotation270);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                      ],
                                                      cancelAction: CancelAction(
                                                          title: const Text(
                                                              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                    );
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                    Expanded(
                                      flex: 5,
                                      child: Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text("MirrorType",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  child: Text(
                                                    _liveMirrorTitle(),
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.grey),
                                                  ),
                                                  onPressed: () {
                                                    showAdaptiveActionSheet(
                                                      context: context,
                                                      title: null,
                                                      androidBorderRadius: 30,
                                                      actions: <
                                                          BottomSheetAction>[
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                'MirrorTypeAuto',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveMirrorType(
                                                                  V2TXLiveMirrorType
                                                                      .v2TXLiveMirrorTypeAuto);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                'MirrorTypeEnable',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveMirrorType(
                                                                  V2TXLiveMirrorType
                                                                      .v2TXLiveMirrorTypeEnable);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        BottomSheetAction(
                                                            title: const Text(
                                                                'MirrorTypeDisable',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed: () {
                                                              setLiveMirrorType(
                                                                  V2TXLiveMirrorType
                                                                      .v2TXLiveMirrorTypeDisable);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                      ],
                                                      cancelAction: CancelAction(
                                                          title: const Text(
                                                              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                    );
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
