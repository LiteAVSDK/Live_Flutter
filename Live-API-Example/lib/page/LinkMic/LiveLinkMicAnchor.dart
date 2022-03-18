
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/v2_tx_live_pusher.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

import '../../Utils/URLUtils.dart';

class LiveLinkMicAnchorPage extends StatefulWidget {
  final String streamId;

  const LiveLinkMicAnchorPage({Key? key, required this.streamId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveLinkMicAnchorPageState();
  }
}

class _LiveLinkMicAnchorPageState extends State<LiveLinkMicAnchorPage> {

  String _linkMicStreamId = '';

  final inputFocusNode = FocusNode();

  late V2TXLivePusher _livePusher;
  late V2TXLivePlayer _livePlayer;

  int? _localViewId;
  int? _remoteViewId;

  bool _isStartPush = false;
  bool _isStartLink = false;

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
  dispose() {
    unFocus();
    debugPrint("Link-Mic Anchor dispose");
    _livePlayer.stopPlay();
    _livePlayer.destroy();

    _livePusher.stopMicrophone();
    _livePusher.stopCamera();
    _livePusher.setMixTranscodingConfig(null);
    _livePusher.stopPush();
    _livePusher.destroy();
    super.dispose();
  }

  initLive() async {
    await initPlatformState();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePusher = V2TXLivePusher(V2TXLiveMode.v2TXLiveModeRTC);
    _livePlayer = V2TXLivePlayer();
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
    var url = URLUtils.generateTRTCPushUrl(widget.streamId, null);
    var pushCode = await _livePusher.startPush(url);
    if (pushCode != V2TXLIVE_OK) {
       showErrordDialog("push error：($pushCode) please check push url or LicenceURL");
      return;
    }
    await _livePusher.startMicrophone();
    await _livePusher.setMixTranscodingConfig(null);
  }

  stopPush() {
    _livePusher.stopMicrophone();
    _livePusher.stopCamera();
    _livePusher.stopPush();
  }

  startLinkMic(String streamId) async {
    if (streamId.isEmpty) {
      showErrordDialog("streamId can not empty");
      return;
    }
    debugPrint("remote streamId: $streamId");
    if (_remoteViewId != null) {
      var code = await _livePlayer.setRenderViewID(_remoteViewId!);
      if (code != V2TXLIVE_OK) {
        showErrordDialog("startLinkMic error： please check remoteView load");
        return;
      }
    } else {
      showErrordDialog("startLinkMic error： can not found remoteView");
      return;
    }
    var url = URLUtils.generateTRTCPlayUrl(streamId, widget.streamId);
    var playCode = await _livePlayer.startPlay(url);
    if (playCode != V2TXLIVE_OK) {
      showErrordDialog("startLinkMic error： please check playURL: $url");
      return;
    }

    V2TXLiveTranscodingConfig config = V2TXLiveTranscodingConfig();
    config.videoWidth = 360;
    config.videoHeight = 640;
    config.videoBitrate = 900;

    V2TXLiveMixStream mainStream = V2TXLiveMixStream(userId: widget.streamId);
    mainStream.streamId = widget.streamId;
    mainStream.width = 360;
    mainStream.height = 640;
    mainStream.x = 0;
    mainStream.y = 0;
    mainStream.zOrder = 1;
    mainStream.inputType = V2TXLiveMixInputType.v2TXLiveMixInputTypeAudioVideo;

    V2TXLiveMixStream subStream = V2TXLiveMixStream(userId: streamId);
    subStream.streamId = streamId;
    subStream.width = 120;
    subStream.height = 180;
    subStream.x = 225;
    subStream.y = 300;
    subStream.zOrder = 2;
    subStream.inputType = V2TXLiveMixInputType.v2TXLiveMixInputTypeAudioVideo;

    config.mixStreams = [mainStream, subStream];
    _livePusher.setMixTranscodingConfig(config);

    setState(() {
      _isStartLink = true;
    });
  }

  stopLinkMic() async {
    await _livePlayer.stopPlay();
    await _livePusher.setMixTranscodingConfig(null);
  }

  onClickStartLink() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Please input link-Mic user id'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  TextField(
                      focusNode: inputFocusNode,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'user id',
                          filled: true,
                          fillColor: Colors.grey.shade50),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _linkMicStreamId = value
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  startLinkMic(_linkMicStreamId);
                },
                child:const Text('OK'),
              ),
            ],
          );
        });
  }

  onClickStopLink() async {
    setState(() {
      _isStartLink = false;
    });
    await stopLinkMic();
    _linkMicStreamId = '';
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
          startPush();
        }
      },
    );
  }

  Widget remoteView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        await _livePlayer.setRenderViewID(viewId);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Link-Mic(${widget.streamId})'),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)
          ),
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
                  bottom: 100.0,
                  right: 20,
                  width: 120,
                  height: 180,
                  child:  Stack(
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
                          offstage: _isStartLink,
                          child: IconButton(
                            iconSize: 100,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              onClickStartLink();
                            },
                          ),
                        ),
                      ),
                      Positioned(
                          left: 0,
                          top: 0,
                          child: Offstage(
                            offstage: !_isStartLink,
                            child: IconButton(
                              icon: const Icon(Icons.close_outlined),
                              onPressed: () {
                                onClickStopLink();
                              },
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}