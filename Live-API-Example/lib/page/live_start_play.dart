
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'play/live_play.dart';
import 'live_web_view.dart';

/// 直播拉流
class LiveStartPlayPage extends StatefulWidget {
  const LiveStartPlayPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveStartPlayPageState();
}

class _LiveStartPlayPageState extends State<LiveStartPlayPage> {

  /// 直播流id
  String _streamId = '';

  /// 链接点击
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  final _streamIdFocusNode = FocusNode();

  // 隐藏底部输入框
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

  startPlay(BuildContext context, V2TXLivePlayMode playMode) {
    unFocus();
    if (_streamId == "") {
      showToastText("Stream Id can not empty");
      return;
    }
    LivePlayPage page = LivePlayPage(streamId: _streamId, playMode: playMode);
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
          title: const Text('Live Streaming'),
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
                                labelText: "Please Input Stream ID",
                                hintText: "Stream ID",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black26),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45),
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
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                            text:
                                "LEB is an ultra-low-latency version of LVB. \n\n"),
                        const TextSpan(
                            text:
                                "It delivers excellent instant streaming performance and can handle ultra-high concurrency. Tencent Cloud’s proprietary RTC protocol features low latency and strong adaptability to poor network conditions, and can be used worldwide. It is suitable for application scenarios such as e-commerce streaming and sports streaming. For details, visit:\n"),
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
                        const TextSpan(
                            text:
                                "\nLVB playback supports multiple protocols including FLV, RTMP, and HLS. It is a mature playback scheme and can handle high concurrency, but its latency is high."),
                        const TextSpan(
                            text: "\n\nLEB playback is recommended.",
                            style: TextStyle(
                              color: Colors.red,
                            ))
                      ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            child: const Text(
                              "Standard Playback",
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            onPressed: () {
                              startPlay(context,
                                  V2TXLivePlayMode.v2TXLivePlayModeStand);
                            },
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            child: const Text(
                              "RTC Playback",
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            onPressed: () {
                              startPlay(context,
                                  V2TXLivePlayMode.v2TXLivePlayModeRTC);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        "LEB Playback (Recommended)",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        startPlay(
                            context, V2TXLivePlayMode.v2TXLivePlayModeLeb);
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
