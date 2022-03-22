
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'common/live_common_def.dart';
import 'pk/live_pk_anchor.dart';
import 'pk/live_pk_audience.dart';

class LiveStartPKPage extends StatefulWidget {

  final LiveRoleType roleType;
  const LiveStartPKPage({Key? key, required this.roleType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveStartPKPageState();
  }
}

class _LiveStartPKPageState extends State<LiveStartPKPage> {

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Link-PK"),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)
          ),
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
                  child: SizedBox (
                    height: 240,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                              style: const TextStyle(color: Colors.black),
                              autofocus: false,
                              focusNode: _streamIdFocusNode,
                              decoration: const InputDecoration(
                                labelText: "Please Input Stream Id",
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
                        const Spacer(flex: 3),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            child: const Text(
                              "Next",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              unFocus();
                              if (_streamId == "") {
                                showToastText("Stream Id can not empty");
                                return;
                              }
                              if (widget.roleType == LiveRoleType.anchor) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LivePKAnchorPage(streamId: _streamId)));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LivePKAudiencePage(streamId: _streamId)));
                              }
                            },
                          ),
                        ),
                      ],
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