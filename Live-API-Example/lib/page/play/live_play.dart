import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';
import 'package:live_flutter_plugin/v2_tx_live_player_observer.dart';

import '../../utils/url_utils.dart';

enum V2TXLivePlayMode {
  /// 标准直播拉流
  v2TXLivePlayModeStand,

  /// RTC拉流
  v2TXLivePlayModeRTC,

  /// 快直播拉流
  v2TXLivePlayModeLeb,
}

/// 直播拉流
class LivePlayPage extends StatefulWidget {
  final String streamId;
  final V2TXLivePlayMode playMode;

  const LivePlayPage({Key? key, required this.streamId, required this.playMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LivePlayPageState();
}

class _LivePlayPageState extends State<LivePlayPage> {

  bool _muteState = false;

  int? _localViewId;

  V2TXLivePlayer? _livePlayer;

  @override
  void initState() {
    super.initState();
    initPlatformState();

  }

  @override
  void deactivate() {
    debugPrint("Live-Play deactivate");
    _livePlayer?.removeListener(onPlayerObserver);
    _livePlayer?.stopPlay();
    _livePlayer?.destroy();
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint("Live-Play dispose");
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePlayer = await V2TXLivePlayer.create();
    _livePlayer?.addListener(onPlayerObserver);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    debugPrint("CreatePlayer result is ${_livePlayer?.status}");
  }

  onPlayerObserver(V2TXLivePlayerListenerType type, param) {
    debugPrint("==player listener type= ${type.toString()}");
    debugPrint("==player listener param= $param");

  }

  /// 提示浮层
  showToastText(text) {
    showToast(
      text,
      context: context,
      alignment: Alignment.center,
    );
  }

  /// 设置静音
  void setMuteState(bool isMute) async {
    var code = await _livePlayer?.snapshot();
    debugPrint("result code $code");
    if (isMute) {
      _livePlayer?.setPlayoutVolume(0);
    } else {
      _livePlayer?.setPlayoutVolume(100);
    }
    setState(() {
      _muteState = isMute;
    });
  }

  bool _isPlaying = false;

  void startPlay() async {
    if (_isPlaying) {
      return;
    }
    if (_localViewId != null) {
      debugPrint("_localViewId $_localViewId");
      var code = await _livePlayer?.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        debugPrint("StartPlay error： please check remoteView load");
      }
    }
    var url = "";
    if (widget.playMode == V2TXLivePlayMode.v2TXLivePlayModeStand) {
      url = URLUtils.generateRtmpPlayUrl(widget.streamId);
    }
    if (widget.playMode == V2TXLivePlayMode.v2TXLivePlayModeRTC) {
      url = URLUtils.generateTRTCPlayUrl(widget.streamId, null);
    }
    if (widget.playMode == V2TXLivePlayMode.v2TXLivePlayModeLeb) {
      url = URLUtils.generateLedPlayUrl(widget.streamId);
    }
    debugPrint("play url: $url");
    var playStatus = await _livePlayer?.startPlay(url);
    if (playStatus == null || playStatus != V2TXLIVE_OK) {
      debugPrint("play error: $playStatus url: $url");
      return;
    }
    await _livePlayer?.setPlayoutVolume(100);
    setState(() {
      _isPlaying = true;
    });
  }

  stopPlay() async {
    await _livePlayer?.stopPlay();
    setState(() {
      _isPlaying = false;
    });
  }

  Widget renderView() {
    return V2TXLiveVideoWidget(
      onViewCreated: (viewId) async {
        _localViewId = viewId;
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
              onPressed: () => {
                Navigator.pop(context)
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: renderView(),
                color: Colors.black,
              ),
              Positioned(
                bottom: 40.0,
                right: 20,
                width: 100,
                child: ElevatedButton(
                  child: Text(
                    _muteState ? "取消静音" : "静音",
                    style: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    setMuteState(!_muteState);
                  },
                ),
              ),
              Positioned(
                bottom: 40.0,
                left: 20,
                width: 100,
                child: ElevatedButton(
                  child: Text(
                    _isPlaying ? "Stop" : "Start",
                    style: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    if (_isPlaying) {
                      stopPlay();
                    } else {
                      startPlay();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
