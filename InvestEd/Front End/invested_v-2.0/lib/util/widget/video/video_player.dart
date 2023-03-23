import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String youtubeVideoId;
  const VideoPlayer({super.key, this.youtubeVideoId = ''});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isVideoPlaying = false;
  bool isVideoMute = false;

  YoutubePlayerController controller = YoutubePlayerController(initialVideoId: '');

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: widget.youtubeVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.33,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                  child: YoutubePlayer(
                      controller: controller, showVideoProgressIndicator: true),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isVideoMute = !isVideoMute;

                                if (isVideoMute) {
                                  controller.mute();
                                } else {
                                  controller.unMute();
                                }
                              });
                            },
                            icon: Icon(isVideoMute
                                ? Ionicons.volume_mute_outline
                                : Ionicons.volume_high_outline)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              controller.seekTo(controller.value.position -
                                  const Duration(seconds: 2));
                            },
                            icon:
                            const Icon(Ionicons.md_play_skip_back_outline)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isVideoPlaying = !isVideoPlaying;

                                if (isVideoPlaying) {
                                  controller.play();
                                } else {
                                  controller.pause();
                                }
                              });
                            },
                            icon: Icon(isVideoPlaying
                                ? Ionicons.pause_outline
                                : Ionicons.play_outline)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              controller.seekTo(controller.value.position +
                                  const Duration(seconds: 2));
                            },
                            icon: const Icon(
                                Ionicons.md_play_skip_forward_outline)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              controller.toggleFullScreenMode();
                            },
                            icon:
                            const Icon(MaterialCommunityIcons.arrow_expand))
                      ],
                    ))
              ],
            )));
  }
}