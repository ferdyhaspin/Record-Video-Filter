import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'video_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) async => await _pickVideo());
  }

  _pickVideo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? video = await _picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        final currentState = navigatorKey.currentState;
        if (currentState != null) {
          currentState.push(
            MaterialPageRoute(
                builder: (context) => VideoView(video.path)),
          );
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "Record Video & Filter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "InterRegular",
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Record Video',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("Record Video"),
            onPressed: () async {
              await _pickVideo();
            },
          ),
        ),
      ),
    );
  }
}
