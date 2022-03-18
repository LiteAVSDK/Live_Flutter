
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class LiveUserInputPage extends StatefulWidget {

  const LiveUserInputPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveUserInputPageState();
  }
}

class _LiveUserInputPageState extends State<LiveUserInputPage> {

  /// 用户名称
  String _userId = '';
  /// 链接点击
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  final userIdFocusNode = FocusNode();

  // 隐藏底部输入框
  unFocus() {
    if (userIdFocusNode.hasFocus) {
      userIdFocusNode.unfocus();
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
          title: const Text("Input User_id"),
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
                              focusNode: userIdFocusNode,
                              decoration: const InputDecoration(
                                labelText: "Please Input User Id",
                                hintText: "user ID",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black26),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black45),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _userId = value),
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            child: const Text(
                              "Next",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              Navigator.pop(context, _userId);
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