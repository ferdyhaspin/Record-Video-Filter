import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tapioca/tapioca.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String path;

  VideoView(this.path);

  @override
  _VideoAppState createState() => _VideoAppState(path);
}

class _VideoAppState extends State<VideoView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String path;
  var tempPath = "";

  bool isLoading = false;

  _VideoAppState(this.path);

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    tempPath = path;
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Filter Video',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Stack(
                children: [
                  Center(
                    child: _controller.value.isInitialized
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                              onTap: () => edit(Colors.red),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                              onTap: () => edit(Colors.green),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                              onTap: () => edit(Colors.blue),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                            SizedBox(width: 20),
                            FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: _saveVideo,
                              child: Icon(Icons.save),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void edit(Color color) async {
    setState(() {
      isLoading = true;
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    });

    var tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
    print(tempDir);
    try {
      final tapiocaBalls = [
        TapiocaBall.filterFromColor(color),
      ];
      final cup = Cup(Content(this.path), tapiocaBalls);

      cup.suckUp(path).then((_) async {
        print("finished");
        print(path);
        setState(() {
          isLoading = false;
          tempPath = path;
          _controller = VideoPlayerController.file(File(path))
            ..initialize().then((_) {
              setState(() {});
            });
        });
      });
    } on Exception catch (e) {
      print(e);
      print("error!!!!");
    }
  }

  void _saveVideo() {
    GallerySaver.saveVideo(tempPath).then((bool? success) {
      print(success.toString());
      if (success != null && success) {
        showInSnackBar('Video berhasil di simpan ke galeri');
        // Navigator.pop(context);
      }
    });
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
