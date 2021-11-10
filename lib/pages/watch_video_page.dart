import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/advertisement_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:video_player/video_player.dart';

class WatchVideo extends StatefulWidget {
  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {


  List <String> videoUrlList = [];

  int counter=0;
  customInit(AdvertisementController advertisement){
      counter++;
    for(var i =0;i<advertisement.videoList.length;i++){
   videoUrlList.add(advertisement.videoList[i].videoUrl!);
    }
      if (videoUrlList.length > 0) {
        _initController(0).then((_) {
          _playController(0);
        });
      }

      if (videoUrlList.length > 1) {
        _initController(1).whenComplete(() => _lock = false);
      }
    print(videoUrlList);
  }

 int index = 0;
 double _position = 0;
 double _buffer = 0;
 bool _lock = true;
  bool _isLoading = true;
 Map<String, VideoPlayerController> _controllers = {};
 Map<int, VoidCallback> _listeners = {};
 // @override
 // void initState() {
 //   super.initState();
 //
 //   if (videoUrlList.length > 0) {
 //     _initController(0).then((_) {
 //       _playController(0);
 //     });
 //   }
 //
 //   if (videoUrlList.length > 1) {
 //     _initController(1).whenComplete(() => _lock = false);
 //   }
 // }

 VoidCallback _listenerSpawner(index) {
   return () {
     int dur = _controller(index)!.value.duration.inMilliseconds;
     int pos = _controller(index)!.value.position.inMilliseconds;
     int buf = _controller(index)!.value.buffered.last.end.inMilliseconds;

     setState(() {
       if (dur <= pos) {
         _position = 0;
         return;
       }
       _position = pos / dur;
       _buffer = buf / dur;
     });
     if (dur - pos < 1) {
       if (index < videoUrlList.length - 1) {
         _nextVideo();
       }
     }
   };
 }
 VideoPlayerController? _controller(int index) {
   return _controllers[videoUrlList.elementAt(index)];
 }
 Future<void> _initController(int index) async {

   var controller = VideoPlayerController.network(videoUrlList.elementAt(index));
   _controllers[videoUrlList.elementAt(index)] = controller;
   await controller.initialize();

 }
 void _removeController(int index) {
   _controller(index)!.dispose();
   _controllers.remove(videoUrlList.elementAt(index));
   _listeners.remove(index);
 }
 void _stopController(int index) {
   _controller(index)!.removeListener(_listeners[index]!);
   _controller(index)!.pause();
   _controller(index)!.pause();
   _controller(index)!.seekTo(Duration(milliseconds: 0));

   // if(index == 4 && _controller(index)!())


 }

  Duration? duration;

 void _playController(int index) async {
   final AdvertisementController advertisementController=Get.find<AdvertisementController>();

   if (!_listeners.keys.contains(index)) {
     _listeners[index] = _listenerSpawner(index);
   }
   _controller(index)!.addListener(_listeners[index]!);
   await _controller(index)!.play().then((value){
     setState(() {
       _isLoading=false;
     });
   });


   setState(() {
    duration = _controller(index)!.value.duration ;
   });

   if(duration==_controller(4)!.value.duration ){
     
     print('OK');
   advertisementController.updateAddAmount();
   }
 }
 // void _previousVideo() {
 //   if (_lock || index == 0) {
 //     return;
 //   }
 //   _lock = true;
 //
 //   _stopController(index);
 //
 //   if (index + 1 < videoUrlList.length) {
 //     _removeController(index + 1);
 //   }
 //
 //   _playController(--index);
 //
 //   if (index == 0) {
 //     _lock = false;
 //   } else {
 //     _initController(index - 1).whenComplete(() => _lock = false);
 //   }
 // }
 void _nextVideo() async {
   if (_lock || index == videoUrlList.length - 1) {
     return;
   }
   _lock = true;

   _stopController(index);

   if (index - 1 >= 0) {
     _removeController(index - 1);
   }
   _playController(++index);
   if (index == videoUrlList.length - 1) {
     _lock = false;
   } else {
     _initController(index + 1).whenComplete(() => _lock = false);
   }
 }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller(index)!.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<AdvertisementController>(

      builder: (advertisement) {

        if(counter==0){
          customInit(advertisement);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Watch Video'),
          ),
          body: _bodyUI(size,advertisement),
        );
      }
    );
  }
  Widget _bodyUI(Size size,AdvertisementController advertisement) => ListView(
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
          Stack(
            children: <Widget>[

              _isLoading?Center(child: Padding(
                padding:  EdgeInsets.only(top: size.width*.5),
                child: CircularProgressIndicator(),
              )):Container(),
              Center(
                child: AspectRatio(
                  aspectRatio: _controller(index)!.value.aspectRatio,

                  child: Center(child: VideoPlayer(_controller(index)!,)),
                ),
              ),

              Positioned(
                                bottom: 0,
                child: Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width * _buffer,
                  color: Colors.grey,

                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width * _position,
                  color: Colors.greenAccent,
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(duration.toString(),style: TextStyle(color: Colors.white,fontSize: 10),),
                  ),
                ),
              ),

              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Container(
              //     height: 10,
              //
              //     color: Colors.greenAccent,
              //     child:Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Text(_position.toString(),style: TextStyle(color: Colors.white,fontSize: 10),),
              //     ),
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
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                //text: 'Hello ',
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: size.width*.038,
                      fontFamily: "ZillaSlab"),
                  children: <TextSpan>[
                    TextSpan(text: 'Video watched: '),
                    TextSpan(text: "Playing ${index + 1} of ${videoUrlList.length}",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green)),
                    TextSpan(text: '\nEarned  TK: '),
                    TextSpan(text: "${index + 1} of ${videoUrlList.length}",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green)),
                  ]
              ),
            ),
          ),



        ],
      );




}
