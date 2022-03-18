
import 'package:flutter/material.dart';

import 'LiveCommonDef.dart';
import '../LiveStartPK.dart';
import '../LiveStartLinkMic.dart';

class LiveSwitchRolePage extends StatefulWidget {
  final LivePageType pageType;
  const LiveSwitchRolePage({Key? key, required this.pageType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveSwitchRolePageState();
  }
}

class _LiveSwitchRolePageState extends State<LiveSwitchRolePage> {
  /// 身份
  LiveRoleType _roleType = LiveRoleType.annchor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.pageType == LivePageType.pk ? "Link-PK":"Link-Mic"),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)
          ),
        ),
        body: Container(
          // color: Colors.black12,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Text("Choose Role", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                child: SizedBox (
                  height: 80,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ElevatedButton(
                            child: const Text(
                              "Anchor",
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(_roleType == LiveRoleType.annchor ? Colors.blue:Colors.grey),
                            ),
                            onPressed: () {
                              setState(() {
                                _roleType = LiveRoleType.annchor;
                              });
                            },
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ElevatedButton(
                            child: const Text(
                              "Audience",
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(_roleType == LiveRoleType.audience ? Colors.blue:Colors.grey),
                            ),
                            onPressed: () {
                              setState(() {
                                _roleType = LiveRoleType.audience;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, left: 40, right: 40),
                child: Center(
                  child: SizedBox (
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        if (widget.pageType == LivePageType.pk) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveStartPKPage(roleType: _roleType)));
                        }
                        if (widget.pageType == LivePageType.linkMic) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveStartLinkMicPage(roleType: _roleType)));
                        }
                      },
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}