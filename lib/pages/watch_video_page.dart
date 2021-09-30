import 'package:flutter/material.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:video_player/video_player.dart';

class WatchVideo extends StatefulWidget {
  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Video'),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size) => ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            padding: EdgeInsets.all(8.0),
            height: 150,
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 5.0)
                ]),
            child: Text(
              'Watch video and get TK. You will get 1 TK to watch every'
              ' video. And you can watch 5 videos per day. Each day you get 5 videos to watch.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ),
          SizedBox(height: 10),
           Container(
             alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: _controller!.value.isInitialized
                    ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ) : loadingWidget
              ),
          SizedBox(height: 20),

          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            padding: EdgeInsets.all(8.0),
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 5.0)
                ]),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                //text: 'Hello ',
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: size.width*.038,
                      fontFamily: "ZillaSlab"),
                  children: <TextSpan>[
                    TextSpan(text: 'Video watched: '),
                    TextSpan(text: "2/5\n",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green)),
                    TextSpan(text: 'Earned  TK: '),
                    TextSpan(text: "2/5",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green)),
                  ]
              ),
            ),
          ),
        ],
      );
}
