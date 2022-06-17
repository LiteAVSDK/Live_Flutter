
import 'package:flutter/cupertino.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_pusher.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

import 'package:flutter/material.dart';
import '../../utils/url_utils.dart';


/// 屏幕分享
class LiveScreenPushPage extends StatefulWidget {

  final V2TXLiveMode liveMode;
  final V2TXLiveAudioQuality audioQuality;
  final String streamId;

  const LiveScreenPushPage(
      {Key? key,
        required this.audioQuality,
        required this.streamId,
        required this.liveMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveScreenPushPageState();
  }

}

class _LiveScreenPushPageState extends State<LiveScreenPushPage> {

  int? _localViewId;
  V2TXLivePusher? _livePusher;
  bool _isStartPush = false;

  @override
  void initState() {
    super.initState();
    initLive();
  }

  @override
  void deactivate() {
    debugPrint("Live-Screen push deactivate");
    _livePusher?.stopMicrophone();
    _livePusher?.stopScreenCapture();
    _livePusher?.destroy();
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint("Live-Screen push dispose");
    super.dispose();
  }

  initLive() async {
    await initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePusher = await V2TXLivePusher.create(widget.liveMode);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    debugPrint("CreatePusher result is ${_livePusher?.status}");
  }

  startPush() async {
    if (_livePusher == null) {
      return;
    }

    await _livePusher?.setAudioQuality(widget.audioQuality);

    if (_localViewId != null) {
      debugPrint("_localViewId: $_localViewId");
      await _livePusher?.setRenderViewID(_localViewId!);
    }

    var sharedCode = await _livePusher?.startScreenCapture("group.com.tencent.liteav.RPLiveStreamShare");
    if (sharedCode == null || sharedCode != V2TXLIVE_OK) {
      showErrordDialog("Start screen share error: Please check Control Center Screen Recording");
      return;
    }

    var url = URLUtils.generateTRTCPushUrl(widget.streamId, widget.streamId);
    if (widget.liveMode == V2TXLiveMode.v2TXLiveModeRTMP) {
      url = URLUtils.generateRtmpPushUrl(widget.streamId);
    }

    var pushCode = await _livePusher?.startPush(url);
    if (pushCode == null || pushCode != V2TXLIVE_OK) {
      _livePusher?.stopMicrophone();
      _livePusher?.stopScreenCapture();
      showErrordDialog("Start screen share error:: push error($pushCode)，Please check push url or license");
      return;
    }
    await _livePusher?.startMicrophone();
    setState(() {
      _isStartPush = true;
    });
  }

  stopPush() async {
    await _livePusher?.stopMicrophone();
    await _livePusher?.stopScreenCapture();
    setState(() {
      _isStartPush = false;
    });
  }

  clickStartScreenPush(bool isStart) {
    if (isStart) {
      startPush();
    } else {
      stopPush();
    }
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

  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        setState(() {
          debugPrint("_localViewId: $viewId");
          _localViewId = viewId;
        });
      },
    );
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
                  child:  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, left: 20, right: 20),
                          child: SizedBox (
                            height: 80,
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          child: Text(
                                            _isStartPush ? "Stop screen share":"Open screen share",
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(_isStartPush? Colors.grey:Colors.blue),
                                          ),
                                          onPressed: () {
                                            clickStartScreenPush(!_isStartPush);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

}