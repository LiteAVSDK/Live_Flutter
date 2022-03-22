
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'debug/generate_test_user_sig.dart';
import 'page/common/live_switch_role.dart';
import 'page/common/live_common_def.dart';
import 'page/live_start_push.dart';
import 'page/live_start_play.dart';

import 'utils/file_utils.dart';

void main() {
  runApp(const MaterialApp(
    title: "home",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _sdkVersion = "";

  @override
  void initState() {
    super.initState();
    V2TXLivePremier.setObserver(onPremierObserver);
    V2TXLivePremier.setLicence(GenerateTestUserSig.LICENSEURL, GenerateTestUserSig.LICENSEURLKEY);
    _getSDKVersion();
  }

  _getSDKVersion() async {
    var sdkVersion = await V2TXLivePremier.getSDKVersionStr();
    var platformVersion = Platform.version;
    setState(() {
      _sdkVersion = "Live SDK Version: $sdkVersion\nPlatform.version: $platformVersion";
    });
  }

  onPremierObserver(V2TXLivePremierObserverType type, param) {
    debugPrint("==premier listener type= ${type.toString()}");
    debugPrint("==premier listener param= $param");
  }

  /// Plugin Log export
  _onOpenLogExport() async {
    var logFiles = await FileUtils.getLogFiles();
    if (logFiles != null && logFiles.isNotEmpty) {
      List<BottomSheetAction> actions = [];
      for (var file in logFiles) {
        var fileName = file.path.split("/").last;
        var action = BottomSheetAction(
          title: Text(fileName),
          onPressed: () {
            Share.shareFiles([file.path]);
          },
        );
        actions.add(action);
      }
      debugPrint("logFiles: $logFiles");
      showAdaptiveActionSheet(
        context: context,
        actions: actions,
        cancelAction: CancelAction(title: const Text("Cancel")),
      );
    } else {
      debugPrint("logFiles: not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: GestureDetector (
            child: const Text('Home'),
            onLongPress: () {
              _onOpenLogExport();
            },
          ),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: ListView(
            restorationId: 'live_index_page',
            padding: const EdgeInsets.all(40),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              ElevatedButton(
                child: const Text(
                  "Camera Push",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveStartPushPage(pushType: LiveStartPushType.camera)),
                  );
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Screen Share",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveStartPushPage(pushType: LiveStartPushType.screen)),
                  );
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Live Streaming",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveStartPlayPage()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Link-Mic",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveSwitchRolePage(pageType: LivePageType.linkMic)),
                  );
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Link-PK",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveSwitchRolePage(pageType: LivePageType.pk)),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                      _sdkVersion,
                      textAlign: TextAlign.center),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
