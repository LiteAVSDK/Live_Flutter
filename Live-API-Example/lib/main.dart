
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'debug/GenerateTestUserSig.dart';
import 'page/LiveStartPush.dart';
import 'page/LiveStartPlay.dart';
import 'page/Common/LiveCommonDef.dart';
import 'page/Common/LiveSwitchRole.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
                    MaterialPageRoute(builder: (context) => LiveStartPushPage(pushType: LiveStartPushType.camera)),
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
                    MaterialPageRoute(builder: (context) => LiveStartPushPage(pushType: LiveStartPushType.screen)),
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
                    MaterialPageRoute(builder: (context) => LiveStartPlayPage()),
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
                    MaterialPageRoute(builder: (context) => LiveSwitchRolePage(pageType: LivePageType.linkMic)),
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
                    MaterialPageRoute(builder: (context) => LiveSwitchRolePage(pageType: LivePageType.pk)),
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
