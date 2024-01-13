import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:video_player/video_player.dart';

class VideoHolder extends StatefulWidget {
  final File file;
  const VideoHolder({super.key, required this.file});

  @override
  State<VideoHolder> createState() => _VideoHolderState();
}

class _VideoHolderState extends State<VideoHolder> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(
      widget.file,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize().whenComplete(() {
      _controller.play();
      // _controller.setLooping(true);
      setState(() {});
    });

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        // If the VideoPlayerController has finished initialization, use
        // the data it provides to limit the aspect ratio of the video.
        return AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          // Use the VideoPlayer widget to display the video.
          child: VideoPlayer(_controller),
        );
      },
    );
  }
}

class VideoHolderTwo extends StatefulWidget {
  final String file;
  const VideoHolderTwo({super.key, required this.file});

  @override
  State<VideoHolderTwo> createState() => _VideoHolderTwoState();
}

class _VideoHolderTwoState extends State<VideoHolderTwo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.file,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize().whenComplete(() {
      _controller.play();
      setState(() {});
    });

    // Use the controller to loop the video.
    _controller.setLooping(false);
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        // If the VideoPlayerController has finished initialization, use
        // the data it provides to limit the aspect ratio of the video.
        return AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          // Use the VideoPlayer widget to display the video.
          child: VideoPlayer(_controller),
        );
      },
    );
  }
}
