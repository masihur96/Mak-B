import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/advertisement_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:video_player/video_player.dart';

class WatchVideo extends StatefulWidget {
  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {

  VideoPlayerController? _controller;

  List <String> videoUrlList = [];
  int counter=0;

  int seconds = 0;
  Timer? _timer;

  Duration? videoDuration;

  void startTimer( AdvertisementController advertisementController,UserController userController) async{
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (seconds != int.parse('${videoDuration!.inSeconds}') ) {
            seconds = seconds + 1;
          //  timer.cancel();
          } else {
            timer.cancel();
              seconds = 0;
            print('Updated');
           // updateVideoInfo();

            advertisementController.updateAddAmount(userController);

            }
            if (seconds == 0) {
              _timer!.cancel();
            }
          }

      ),
    );
  }
  customInit(AdvertisementController advertisement, UserController userController){
    for(var i =0;i<advertisement.videoList.length;i++){
      videoUrlList.add(advertisement.videoList[i].videoUrl!);
    }
    _controller = VideoPlayerController.network(
        videoUrlList[0])
      ..initialize().then((_) {
        startTimer(advertisement,userController);
        setState(() {
          videoDuration = _controller!.value.duration;
        });
        print('Video Duration: ${videoDuration!.inSeconds}');
       // print('Video Position: ${_controller!.value.position}');
        setState(() {
          _controller!.play();
        });
      });

    print(videoUrlList);
  }

  _showDialog() {

    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '** ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.orange),
                      ),
                      Text(
                        'Watched video and get Money ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: kPrimaryColor,
                            fontSize: MediaQuery.of(context).size.width * .040),
                      ),
                      Text(
                        '**',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.orange
                            ,fontSize: MediaQuery.of(context).size.width * .040),
                      ),


                    ],
                  ),
                  Text(
                    ' You will get 1 TK to watch every video. And you can watch 5 videos per day.\nEach day you get 5 videos to watch.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor
                        ,fontSize: MediaQuery.of(context).size.width * .040
                    ),

                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }


  playVideo(int index,AdvertisementController advertisement, UserController userController){
    if(_controller!=null){
      //_controller!.dispose();
      _controller = VideoPlayerController.network(
          videoUrlList[index])
        ..initialize().then((_) {
          startTimer(advertisement,userController);
          setState(() {
            videoDuration = _controller!.value.duration;
          });
          print('Video Duration: ${videoDuration!.inSeconds}');

          setState(() {
            _controller!.play();
          });
        });
    }else {
      _controller = VideoPlayerController.network(
          videoUrlList[index])
        ..initialize().then((_) {
          startTimer(advertisement, userController);
          setState(() {
            videoDuration = _controller!.value.duration;
          });
          print('Video Duration: ${videoDuration!.inSeconds}');
          setState(() {
            _controller!.play();
          });
        });
    }

  }
   bool _isLoading = true;

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserController userController =Get.find();

    return GetBuilder<AdvertisementController>(
        builder: (advertisement) {
          Future.delayed(Duration.zero, () async {
            if (counter == 0) {
              customInit(advertisement,userController);
              setState(() {
                counter++;
              });
              _showDialog();

            }
          });
          return Scaffold(
            appBar: AppBar(
              title: Text('Watch Video'),
            ),
            body: _bodyUI(size,advertisement, userController),
          );
        }
    );
  }
  Widget _bodyUI(Size size,AdvertisementController advertisement, UserController userController) => ListView(
    children: [
      SizedBox(height: 10),
      Stack(
        children: <Widget>[

          _isLoading?Center(child: Padding(
            padding:  EdgeInsets.only(top: size.width*.3),
            child: CircularProgressIndicator(),
          )):Container(),
          Center(
            child: AspectRatio(
              aspectRatio: 5/3,
              child: _controller!=null?Center(child: VideoPlayer(_controller!,)):Container(),
            ),
          ),
       // Align(
       //   alignment: Alignment.center,
       //   child: Padding(
       //     padding:  EdgeInsets.only(top: size.width*.25),
       //     child: FloatingActionButton(
       //       backgroundColor: Colors.grey,
       //      onPressed: () {
       //        startTimer(advertisement);
       //          setState(() {
       //          _controller!.value.isPlaying
       //          ? _controller!.pause()
       //                : _controller!.play();
       //          });
       //          },
       //          child: Icon(
       //          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
       //          ),
       //      ),
       //   ),
       // ),
        ],
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

      ),
      Container(
        height: size.width,
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: advertisement.videoList.length,
            itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                _timer!.cancel();
                _controller!.dispose();
                playVideo(index,advertisement,userController);
              },
              child: Row(
                children: [
                  Image.asset('assets/images/video_icon.png',width: 50,height: 50,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${ advertisement.videoList[index].title}'),
                        Text('Date: ${ advertisement.videoList[index].date}'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      )
      
    ],
  );




}
