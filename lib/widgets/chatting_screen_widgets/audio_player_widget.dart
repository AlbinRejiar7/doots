import 'dart:developer';

import 'package:audioplayers/audioplayers.dart' as voice;
import 'package:doots/constants/color_constants.dart';
import 'package:doots/controller/download_controller.dart';
import 'package:doots/models/message_model.dart';
import 'package:doots/service/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Message message;
  final String? groupId;
  const AudioPlayerWidget({
    super.key,
    required this.message,
    this.groupId,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late bool isUserForInitState;
  final voice.AudioPlayer advancedPlayer = voice.AudioPlayer();
  Duration? _duration = const Duration();
  Duration _position = const Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;
  late GetStorage data;
  List<IconData> icons = [Icons.play_circle_fill, Icons.pause_circle_filled];

  @override
  void initState() {
    super.initState();

    data = GetStorage();
    isUserForInitState = (widget.message.fromId == ChatService.user.uid);

    advancedPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    advancedPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = const Duration(seconds: 0);
        isPlaying = false;
      });
    });

    advancedPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    if (isUserForInitState) {
      advancedPlayer
          .setSourceDeviceFile(widget.message.localFileLocation)
          .then((value) async {
        _duration = await advancedPlayer.getDuration();
      });
    }
    if (!isUserForInitState && widget.message.isDownloaded) {
      advancedPlayer
          .setSourceDeviceFile(data.read(widget.message.filename))
          .then((value) async {
        _duration = await advancedPlayer.getDuration();
      });
    }
  }

  var downloadCtr = Get.put(DownloadController());
  Future<void> downloadVoice() async {
    if (widget.groupId != null) {
      ChatService.updateDownloadingStatusForGroup(
          widget.message, true, widget.groupId!);
      await downloadCtr.downloadAudioFromFirebase(
          widget.message.msg, widget.message.filename);
      ChatService.updateDownloadedStatusForGroup(
          widget.message, true, widget.groupId!);
      ChatService.updateDownloadingStatusForGroup(
          widget.message, false, widget.groupId!);
    } else {
      ChatService.updateDownloadingStatus(widget.message, true);
      await downloadCtr.downloadAudioFromFirebase(
          widget.message.msg, widget.message.filename);
      ChatService.updateDownloadedStatus(widget.message, true);
      ChatService.updateDownloadingStatus(widget.message, false);
    }
  }

  Widget slider() {
    return Slider(
        activeColor: kgreen1,
        inactiveColor: kWhite,
        min: 0.0,
        max: _duration!.inSeconds.toDouble(),
        value: _position.inSeconds.toDouble(),
        onChanged: (val) {
          setState(() {
            changeToSecond(val.toInt());
            _position = Duration(seconds: val.round());
          });
        });
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;
    final bool isUser = (widget.message.fromId == ChatService.user.uid);
    if (!isUser && widget.message.read.isEmpty) {
      ChatService.updateMessageStatus(widget.message);
    }

    return Padding(
      padding: EdgeInsets.all(width * 0.02),
      child: Column(
        children: [
          Container(
            height: height * 0.08,
            margin: isUser
                ? EdgeInsets.only(
                    left: width * 0.24,
                  )
                : EdgeInsets.only(right: width * 0.24),
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
              color: kgreen1.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.02),
                  topRight: Radius.circular(width * 0.02),
                  bottomLeft: isUser
                      ? Radius.circular(width * 0.02)
                      : Radius.circular(0),
                  bottomRight: isUser
                      ? Radius.circular(0)
                      : Radius.circular(width * 0.02)),
            ),
            child: Row(
              children: [
                if (isUser)
                  IconButton(
                      onPressed: () {
                        if (isPlaying == false) {
                          advancedPlayer.play(voice.DeviceFileSource(
                              widget.message.localFileLocation));
                          setState(() {
                            isPlaying = true;
                          });
                        } else if (isPlaying == true) {
                          advancedPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        }
                      },
                      icon: isPlaying == false
                          ? Icon(
                              icons[0],
                              color: kWhite,
                              size: width * 0.08,
                            )
                          : Icon(
                              icons[1],
                              color: kWhite,
                              size: width * 0.08,
                            )),
                if (!isUser)
                  if (!widget.message.isDownloaded)
                    widget.message.isDownloading
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        : IconButton(
                            onPressed: () async {
                              log("donwloaded enter");
                              await downloadVoice();
                            },
                            icon: Icon(Icons.download))
                  else
                    IconButton(
                        onPressed: () {
                          if (isPlaying == false) {
                            advancedPlayer.play(voice.DeviceFileSource(
                                data.read(widget.message.filename)));
                            setState(() {
                              isPlaying = true;
                            });
                          } else if (isPlaying == true) {
                            advancedPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          }
                        },
                        icon: isPlaying == false
                            ? Icon(
                                icons[0],
                                color: kWhite,
                                size: width * 0.08,
                              )
                            : Icon(
                                icons[1],
                                color: kWhite,
                                size: width * 0.08,
                              )),
                Text(ChatService.formatDuration(_position)),
                Flexible(child: slider()),
                Text(widget.message.duration),
              ],
            ),
          ),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                  ChatService.convertTimestampTo12HrTime(
                      int.parse(widget.message.sent)),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 12)),
              if (widget.message.read.isEmpty)
                isUser
                    ? Icon(
                        size: width * 0.05,
                        Icons.done,
                      )
                    : SizedBox.fromSize(),
              if (widget.message.read.isNotEmpty)
                isUser
                    ? Icon(
                        size: width * 0.05,
                        Icons.done_all,
                        color: Colors.blue,
                      )
                    : SizedBox.fromSize(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }
}
