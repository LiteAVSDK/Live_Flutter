
import 'package:flutter/material.dart';


import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

import '../../utils/url_utils.dart';

class LivePKAudiencePage extends StatefulWidget {
  final String streamId;
  const LivePKAudiencePage({Key? key, required this.streamId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LivePKAudiencePageState();
  }

}

class _LivePKAudiencePageState extends State<LivePKAudiencePage> {

  late V2TXLivePlayer _livePlayer;

  int? _localViewId;

  bool _isStartPlay = false;

  @override
  void initState() {
    super.initState();
    initLive();
  }

  @override
  void deactivate() {
    debugPrint("Live-PK Audience deactivate");
    _livePlayer.stopPlay();
    _livePlayer.destroy();
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint("Live-PK Audience dispose");
    super.dispose();
  }

  initLive() async {
    await initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _livePlayer = await V2TXLivePlayer.create();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  startPlay() async {
    if (_localViewId != null) {
      await _livePlayer.setRenderViewID(_localViewId!);
    }
    var url = URLUtils.generateLedPlayUrl(widget.streamId);
    debugPrint("play url: $url");
    var playStatus = await _livePlayer.startLivePlay(url);
    if (playStatus != V2TXLIVE_OK) {
      debugPrint("play error: $playStatus url: $url");
      return;
    }
  }

  stopPlay() {
    _livePlayer.stopPlay();
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
          Future.delayed(const Duration(seconds: 1), (){
            startPlay();
          });
        }
      },
    );
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
        body: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity, minHeight: double.infinity),
          child: Container(
            child: renderView(),
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}