
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/v2_tx_live_pusher.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

import '../../Utils/URLUtils.dart';

class LiveLinkMicAudiencePage extends StatefulWidget {
  final String streamId;
  final String userId;
  const LiveLinkMicAudiencePage({Key? key, required this.streamId, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveLinkMicAudiencePageState();
  }
}

class _LiveLinkMicAudiencePageState extends State<LiveLinkMicAudiencePage> {


  late V2TXLivePusher _livePusher;
  late V2TXLivePlayer _livePlayer;

  int? _localViewId;
  int? _remoteViewId;

  bool _isStartPlay = false;
  bool _isStartLink = false;


  @override
  void initState() {
    super.initState();
    initLive();
  }

  @override
  dispose() {
    debugPrint("Link-Mic Audience dispose");
    _livePlayer.stopPlay();
    _livePlayer.destroy();

    _livePusher.stopMicrophone();
    _livePusher.stopCamera();
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

  startLebPlay() async {
    if (_localViewId != null) {
      var code = await _livePlayer.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        showErrordDialog("startLebPlay error： please check Anchor RenderView");
        return;
      }
    }
    var url = URLUtils.generateLedPlayUrl(widget.streamId);
    debugPrint("startLebPlay url: $url");
    var playCode = await _livePlayer.startPlay(url);
    if (playCode != V2TXLIVE_OK) {
      showErrordDialog("startLebPlay error： please check playURL: $url");
      return;
    }
  }

  startRtcPlay() async {
    if (_localViewId != null) {
      var code = await _livePlayer.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        showErrordDialog("startRtcPlay error： please check Anchor RenderView");
        return;
      }
    }
    var url = URLUtils.generateTRTCPlayUrl(widget.streamId, null);
    debugPrint("startRtcPlay url: $url");
    var playCode = await _livePlayer.startPlay(url);
    if (playCode != V2TXLIVE_OK) {
      showErrordDialog("startLebPlay error： please check playURL: $url");
      return;
    }
  }

  stopPlay() {
    _livePlayer.stopPlay();
  }

  startLinkMic() async {

    var cameraCode = await _livePusher.startCamera(true);
    if (cameraCode != V2TXLIVE_OK) {
      debugPrint("cameraCode: $cameraCode");
      return;
    }
    if (_remoteViewId != null) {
      var code = await _livePusher.setRenderViewID(_remoteViewId!);
      if (code != V2TXLIVE_OK) {
        showErrordDialog("startLinkMic error： please check remote renderView");
        return;
      }
    }
    var url = URLUtils.generateTRTCPushUrl(widget.userId, null);
    var pushCode = await _livePusher.startPush(url);
    if (pushCode != V2TXLIVE_OK) {
      showErrordDialog("startLinkMic error： please check url: $url");
      return;
    }
    await _livePusher.startMicrophone();
    setState(() {
      _isStartLink = true;
    });
  }

  stopLinkMic() {
    _livePusher.stopMicrophone();
    _livePusher.stopCamera();
    _livePusher.stopPush();
    setState(() {
      _isStartLink = false;
    });
  }

  onClickStartLink() async {
    await stopPlay();
    await startRtcPlay();
    await startLinkMic();
  }

  onClickStopLink() async {
    setState(() {
      _isStartLink = false;
    });
    await stopPlay();
    await stopLinkMic();
    await startLebPlay();
  }


  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        await _livePlayer.setRenderViewID(viewId);
        setState(() {
          _localViewId = viewId;
        });
        if (_isStartPlay == false) {
          _isStartPlay = true;
          startLebPlay();
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