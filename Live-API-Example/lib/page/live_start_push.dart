import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';

import 'push/live_camera_push.dart';
import 'push/live_screen_push.dart';
import 'live_web_view.dart';

enum LiveStartPushType {
  /// 摄像头推流
  camera,
  /// 屏幕分享
  screen,
}

/// 推流
class LiveStartPushPage extends StatefulWidget {
  final LiveStartPushType pushType;

  const LiveStartPushPage({Key? key, required this.pushType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveStartPushPageState();
}

class _LiveStartPushPageState extends State<LiveStartPushPage> {

  /// 直播流id
  String _streamId = '';

  /// 当前音频质量
  V2TXLiveAudioQuality _audioQuality =
      V2TXLiveAudioQuality.v2TXLiveAudioQualityDefault;

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  final _streamIdFocusNode = FocusNode();

  /// 隐藏底部输入框
  unFocus() {
    if (_streamIdFocusNode.hasFocus) {
      _streamIdFocusNode.unfocus();
    }
  }

  @override
  dispose() {
    unFocus();
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  /// 提示浮层
  showToastText(text) {
    showToast(
      text,
      context: context,
      alignment: Alignment.center,
    );
  }

  startLive(BuildContext context, V2TXLiveMode liveMode) {
    unFocus();
    if (_streamId == "") {
      showToastText("Stream Id can not empty");
      return;
    }
    if (widget.pushType == LiveStartPushType.camera) {
      startCameraLive(context, liveMode);
    } else {
      startScreenLive(context, liveMode);
    }
  }

  /// 摄像头推流
  startCameraLive(BuildContext context, V2TXLiveMode liveMode) {
    if (_streamId == "") {
      showToastText("Stream Id can not empty");
      return;
    }
    LiveCameraPushPage page = LiveCameraPushPage(
        audioQuality: _audioQuality, streamId: _streamId, liveMode: liveMode);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// 屏幕分享推流
  startScreenLive(BuildContext context, V2TXLiveMode liveMode) {
    if (_streamId == "") {
      showToastText("Stream Id can not empty");
      return;
    }
    LiveScreenPushPage page = LiveScreenPushPage(
        audioQuality: _audioQuality, streamId: _streamId, liveMode: liveMode);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.pushType == LiveStartPushType.camera
              ? "Camera Push"
              : "Screen Share"),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            unFocus();
          },
          child: Container(
            // color: Colors.black12,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 80,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                              style: const TextStyle(color: Colors.black),
                              autofocus: false,
                              focusNode: _streamIdFocusNode,
                              decoration: const InputDecoration(
                                labelText: "Please input Stream ID",
                                hintText: "Stream ID",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black26),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _streamId = value),
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
                            // color: Colors.red,
                            child: Text("Please choose audio Quality",
                                textAlign: TextAlign.left),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  child: const Text(
                                    "Default",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _audioQuality ==
                                                V2TXLiveAudioQuality
                                                    .v2TXLiveAudioQualityDefault
                                            ? Colors.blue
                                            : Colors.grey),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _audioQuality = V2TXLiveAudioQuality
                                          .v2TXLiveAudioQualityDefault;
                                    });
                                  },
                                ),
                              ),
                              const Spacer(flex: 1),
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  child: const Text(
                                    "Speech",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _audioQuality ==
                                                V2TXLiveAudioQuality
                                                    .v2TXLiveAudioQualitySpeech
                                            ? Colors.blue
                                            : Colors.grey),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _audioQuality = V2TXLiveAudioQuality
                                          .v2TXLiveAudioQualitySpeech;
                                    });
                                  },
                                ),
                              ),
                              const Spacer(flex: 1),
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  child: const Text(
                                    "Music",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _audioQuality ==
                                                V2TXLiveAudioQuality
                                                    .v2TXLiveAudioQualityMusic
                                            ? Colors.blue
                                            : Colors.grey),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _audioQuality = V2TXLiveAudioQuality
                                          .v2TXLiveAudioQualityMusic;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        "Standard Live Push",
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                      onPressed: () {
                        startLive(context, V2TXLiveMode.v2TXLiveModeRTMP);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                            text:
                                "Tencent Cloud’s proprietary RTC protocol features lower latency and better adaptability to poor network conditions when compared with traditional live streaming protocols, and can be used worldwide. For details, visit：\n\n"),
                        TextSpan(
                          text:
                              "https://cloud.tencent.com/document/product/454/52751",
                          style: const TextStyle(color: Colors.blue),
                          recognizer: _tapGestureRecognizer
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LiveWebView(
                                      urlString:
                                          "https://cloud.tencent.com/document/product/454/52751"),
                                ),
                              );
                            },
                        ),
                      ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        "RTC Push（Recommend）",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        startLive(context, V2TXLiveMode.v2TXLiveModeRTC);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
