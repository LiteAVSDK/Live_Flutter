import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_flutter_plugin/v2_tx_live_def.dart';

import '../../common/live_slider_widget.dart';

class LiveAudioSettings {
  /// 音乐播放文件
  late AudioMusicParam musicParam;

  /// 远端音量大小
  int publishVolume = 100;

  /// 本地音量大小
  int localVolume = 100;

  /// 全局背景音乐的本地和远端音量的大小
  int allMusicVolume = 100;

  /// 音调高低
  double musicPitch = 0;

  /// 变速
  double speedRate = 1.0;

  /// 是否正在播放中
  bool isPlaying = false;

  LiveAudioSettings() {
    musicParam = AudioMusicParam(
        path:
            "http://dldir1.qq.com/hudongzhibo/LiteAV/demomusic/testmusic1.mp3",
        id: 1);
    musicParam.loopCount = 0;
    musicParam.publish = true;
  }
}

class LiveAudioSheetPage extends StatefulWidget {
  final LiveAudioSettings settings;

  /// 开始播放音乐
  final AsyncCallback? onMusicStartPlay;

  /// 暂停播放音乐
  final AsyncCallback? onMusicPausePlay;

  /// 停止播放音乐
  final AsyncCallback? onMusicStopPlay;

  /// 远端音量大小回调
  final AsyncValueSetter<int>? onPublishVolumeChanged;

  /// 本地音量大小回调
  final AsyncValueSetter<int>? onLocalVolumeChanged;

  /// 全局背景音乐的本地和远端音量的大小回调
  final AsyncValueSetter<int>? onAllMusicVolumeChanged;

  /// 音调高低回调
  final AsyncValueSetter<double>? onMusicPitchChanged;

  /// 音调高低回调
  final AsyncValueSetter<double>? onSpeedRateChanged;

  const LiveAudioSheetPage(
      {Key? key,
      required this.settings,
      this.onMusicStartPlay,
      this.onMusicPausePlay,
      this.onMusicStopPlay,
      this.onPublishVolumeChanged,
      this.onLocalVolumeChanged,
      this.onAllMusicVolumeChanged,
      this.onMusicPitchChanged,
      this.onSpeedRateChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LiveAudioSheetPageState();
}

class LiveAudioSheetPageState extends State<LiveAudioSheetPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Center(
              child: Text(
                "Audio Settings",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: ListView(
              restorationId: "tx_live_demo_audio_settings",
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              children: [
                SizedBox(
                  height: 60,
                  child: Column(
                    children: <Widget>[
                      Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: ElevatedButton(
                              child: Text(widget.settings.isPlaying
                                  ? "Pause Music"
                                  : "Start Music"),
                              onPressed: () {
                                if (widget.settings.isPlaying) {
                                  if (widget.onMusicPausePlay != null) {
                                    widget.onMusicPausePlay!();
                                    setState(() {
                                      widget.settings.isPlaying = false;
                                    });
                                  }
                                } else {
                                  if (widget.onMusicStartPlay != null) {
                                    widget.onMusicStartPlay!();
                                    setState(() {
                                      widget.settings.isPlaying = true;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 5,
                            child: ElevatedButton(
                              child: const Text("Stop"),
                              onPressed: () {
                                if (widget.onMusicStopPlay != null) {
                                  widget.onMusicStopPlay!();
                                  setState(() {
                                    widget.settings.isPlaying = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                LiveSliderWidget(
                  minValue: 0,
                  maxValue: 100,
                  title: "Publish Volume",
                  currentValue: widget.settings.publishVolume.toDouble(),
                  onValueChanged: (value) {
                    var publishVolume = value.toInt();
                    widget.settings.publishVolume = publishVolume;
                    if (widget.onPublishVolumeChanged != null) {
                      widget.onPublishVolumeChanged!(publishVolume);
                    }
                  },
                ),
                LiveSliderWidget(
                  minValue: 0,
                  maxValue: 100,
                  title: "Local Volume",
                  currentValue: widget.settings.localVolume.toDouble(),
                  onValueChanged: (value) {
                    var localVolume = value.toInt();
                    widget.settings.localVolume = localVolume;
                    if (widget.onLocalVolumeChanged != null) {
                      widget.onLocalVolumeChanged!(localVolume);
                    }
                  },
                ),
                LiveSliderWidget(
                  minValue: 0,
                  maxValue: 100,
                  title: "All Music Volume",
                  currentValue: widget.settings.allMusicVolume.toDouble(),
                  onValueChanged: (value) {
                    var allMusicVolume = value.toInt();
                    widget.settings.allMusicVolume = allMusicVolume;
                    if (widget.onAllMusicVolumeChanged != null) {
                      widget.onAllMusicVolumeChanged!(allMusicVolume);
                    }
                  },
                ),
                LiveSliderWidget(
                  minValue: -1,
                  maxValue: 1,
                  title: "Music Pitch",
                  currentValue: widget.settings.musicPitch,
                  onValueChanged: (value) {
                    widget.settings.musicPitch = value;
                    if (widget.onMusicPitchChanged != null) {
                      widget.onMusicPitchChanged!(value);
                    }
                  },
                ),
                LiveSliderWidget(
                  minValue: 0.5,
                  maxValue: 2,
                  title: "SpeedRate",
                  currentValue: widget.settings.speedRate,
                  onValueChanged: (value) {
                    widget.settings.speedRate = value;
                    if (widget.onSpeedRateChanged != null) {
                      widget.onSpeedRateChanged!(value);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
