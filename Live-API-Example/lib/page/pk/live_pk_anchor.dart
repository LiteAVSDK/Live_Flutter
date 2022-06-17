
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/v2_tx_live_pusher.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

import '../../utils/url_utils.dart';

class LivePKAnchorPage extends StatefulWidget {
  final String streamId;
  const LivePKAnchorPage({Key? key, required this.streamId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LivePKAnchorPageState();
  }

}

class _LivePKAnchorPageState extends State<LivePKAnchorPage> {

  String _pkStreamId = "";
  final inputFocusNode = FocusNode();

  late V2TXLivePusher _livePusher;
  late V2TXLivePlayer _livePlayer;

  int? _localViewId;
  int? _remoteViewId;

  bool _isStartPush = false;
  bool _isStartPK = false;

  @override
  void initState() {
    super.initState();
    initLive();
  }

  // 隐藏底部输入框
  unFocus() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
  }

  @override
  void deactivate() {
    unFocus();
    debugPrint("Live-PK Anchor deactivate");
    _livePlayer.stopPlay();
    _livePlayer.destroy();

    _livePusher.stopMicrophone();
    _livePusher.stopCamera();
    _livePusher.setMixTranscodingConfig(null);
    _livePusher.stopPush();
    _livePusher.destroy();
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint("Live-PK Anchor dispose");
    super.dispose();
  }

  initLive() async {
    await initPlatformState();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePusher = await V2TXLivePusher.create(V2TXLiveMode.v2TXLiveModeRTC);
    _livePlayer = await V2TXLivePlayer.create();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  startPush() async {

    var cameraCode = await _livePusher.startCamera(true);
    if (cameraCode != V2TXLIVE_OK) {
      debugPrint("cameraCode: $cameraCode");
      return;
    }
    await _livePusher.startMicrophone();
    if (_localViewId != null) {
      _livePusher.setRenderViewID(_localViewId!);
    }
    var url = URLUtils.generateTRTCPushUrl(widget.streamId, null);
    var pushCode = await _livePusher.startPush(url);
    if (pushCode != V2TXLIVE_OK) {
      showErrordDialog("Push error：($pushCode) please check push url or LicenceURL");
      return;
    }
  }

  stopPush() async {
    await _livePusher.stopMicrophone();
    await _livePusher.stopCamera();
    await _livePusher.stopPush();
  }

  startPK(String streamId) async {
    if (streamId.isEmpty) {
      showErrordDialog("streamId can not empty");
      return;
    }
    if (_remoteViewId != null) {
      await _livePlayer.setRenderViewID(_remoteViewId!);
    }
    debugPrint("remote streamId: streamId");
    var url = URLUtils.generateTRTCPlayUrl(streamId, widget.streamId);
    _livePlayer.startPlay(url);

    V2TXLiveTranscodingConfig config = V2TXLiveTranscodingConfig();
    config.videoWidth = 360;
    config.videoHeight = 640;
    config.videoBitrate = 900;

    V2TXLiveMixStream mainStream = V2TXLiveMixStream(userId: widget.streamId);
    mainStream.streamId = widget.streamId;
    mainStream.x = 10;
    mainStream.y = 20;
    mainStream.width = 160;
    mainStream.height = 320;
    mainStream.zOrder = 1;
    mainStream.inputType = V2TXLiveMixInputType.v2TXLiveMixInputTypeAudioVideo;

    V2TXLiveMixStream subStream = V2TXLiveMixStream(userId: streamId);
    subStream.streamId = streamId;
    subStream.x = 190;
    subStream.y = 20;
    subStream.width = 160;
    subStream.height = 320;
    subStream.zOrder = 2;
    subStream.inputType = V2TXLiveMixInputType.v2TXLiveMixInputTypeAudioVideo;

    config.mixStreams = [mainStream, subStream];
    _livePusher.setMixTranscodingConfig(config);

    setState(() {
      _isStartPK = true;
    });
  }

  stopPK() async {
    await _livePlayer.stopPlay();
    await _livePusher.setMixTranscodingConfig(null);
  }

  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        await _livePusher.setRenderViewID(viewId);
        setState(() {
          _localViewId = viewId;
        });
        if (_isStartPush == false) {
          _isStartPush = true;
          Future.delayed(const Duration(seconds: 1), (){
            startPush();
          });
        }
      },
    );
  }

  Widget remoteView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        setState(() {
          _remoteViewId = viewId;
        });
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

  onClickStartPK() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Please input pk stream_id"),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  TextField(
                      focusNode: inputFocusNode,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'pk stream_id',
                          filled: true,
                          fillColor: Colors.grey.shade50),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _pkStreamId = value
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  startPK(_pkStreamId);
                },
                child:const Text('OK'),
              ),
            ],
          );
        });
  }

  onClickStopPK() async {
    setState(() {
      _isStartPK = false;
    });
    _pkStreamId = '';
    await stopPK();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Link-PK'),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)
          ),
        ),
        body: Column (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Container(
                      height: 320,
                      child: ClipRect(
                        child: renderView(),
                      ),
                      color: Colors.black,
                    )
                ),
                const Spacer(flex: 1),
                Expanded(
                    flex: 6,
                    child: SizedBox (
                      height: 320,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: ClipRect(
                                child: remoteView(),
                              ),
                            ),
                            color: Colors.grey,
                          ),
                          Positioned(
                            child: Offstage(
                              offstage: _isStartPK,
                              child: IconButton(
                                iconSize: 100,
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  onClickStartPK();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                              left: 0,
                              top: 0,
                              child: Offstage(
                                offstage: !_isStartPK,
                                child: IconButton(
                                  icon: const Icon(Icons.close_outlined),
                                  onPressed: () {
                                    onClickStopPK();
                                  },
                                ),
                              ))
                        ],
                      ),
                    )
                ),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}