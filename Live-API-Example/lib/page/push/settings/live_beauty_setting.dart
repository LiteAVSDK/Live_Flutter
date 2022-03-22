import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/live_slider_widget.dart';

class LiveBeautySettings {

  ///优图，由优图实验室提供，磨皮效果介于光滑和自然之间，比光滑保留更多皮肤细节，比自然磨皮程度更高。
  int beautyPituLevel = 0;

  /// 美白级别
  int whitenessLevel = 0;

  /// 红润级别
  int ruddyLevel = 0;
}

class LiveBeautySheetPage extends StatefulWidget {

  final LiveBeautySettings settings;
  /// 优图
  final AsyncValueSetter<int>? onPituValueChanged;
  /// 美白
  final AsyncValueSetter<int>? onWhitenessValueChanged;
  /// 红润
  final AsyncValueSetter<int>? onRuddyValueChanged;

  const LiveBeautySheetPage(
      {Key? key,
        required this.settings,
        this.onWhitenessValueChanged,
        this.onRuddyValueChanged,
        this.onPituValueChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveBeautySheetPageState();
  }
}

class _LiveBeautySheetPageState extends State<LiveBeautySheetPage> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Center(
              child: Text(
                "Beauty Settings",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: ListView(
              restorationId: "tx_live_demo_beauty_settings",
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 40),
              children: [
                LiveSliderWidget(
                  minValue: 0,
                  maxValue: 9,
                  divisions: 10,
                  title: "Pitu",
                  currentValue: widget.settings.whitenessLevel.toDouble(),
                  onValueChanged: (value) {
                    var beautyPituLevel = value.toInt();
                    widget.settings.beautyPituLevel = beautyPituLevel;
                    if (widget.onPituValueChanged != null) {
                      widget.onPituValueChanged!(beautyPituLevel);
                    }
                  },
                ),
                LiveSliderWidget(
                  minValue: 0,
                  maxValue: 9,
                  divisions: 10,
                  title: "Whiteness",
                  currentValue: widget.settings.whitenessLevel.toDouble(),
                  onValueChanged: (value) {
                    var whitenessLevel = value.toInt();
                    widget.settings.whitenessLevel = whitenessLevel;
                    if (widget.onWhitenessValueChanged != null) {
                      widget.onWhitenessValueChanged!(whitenessLevel);
                    }
                  },
                ),
                LiveSliderWidget(
                  minValue: 0,
                  maxValue: 9,
                  divisions: 10,
                  title: "Ruddy",
                  currentValue: widget.settings.ruddyLevel.toDouble(),
                  onValueChanged: (value) {
                    var ruddyLevel = value.toInt();
                    widget.settings.ruddyLevel = ruddyLevel;
                    if (widget.onRuddyValueChanged != null) {
                      widget.onRuddyValueChanged!(ruddyLevel);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
