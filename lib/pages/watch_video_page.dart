import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/advertisement_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/variables/constants.dart';
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

  List<String>? savedSharedList;
 List<String> videoUrlListForSharedPreference = [];
  List<String> finalVideoLink=[];
  void startTimer( AdvertisementController advertisement,UserController userController,int index) async{
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () async {
          if (seconds != int.parse('${videoDuration!.inSeconds}') ) {
            seconds = seconds + 1;
          //  timer.cancel();
          } else {
            timer.cancel();
              seconds = 0;
            print('Updated');
           // updateVideoInfo();

            advertisement.updateAddAmount(userController);

            if(videoUrlListForSharedPreference.contains(videoUrlList[index])){
              print('This Video Link is already added');
            }else{

              videoUrlListForSharedPreference.add(videoUrlList[index]);
              List<String> videoSharedPrefList = videoUrlListForSharedPreference.map((i) => i).toList();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setStringList("videoUrlList", videoSharedPrefList);
             List<String>? savedUrlList = prefs.getStringList('videoUrlList');
              setState(() {
                savedSharedList = savedUrlList!.map((i) => i).toList();

              });
              print('Video list From Shared: $savedSharedList');
            }

            }

          }

      ),
    );
  }



  customInit(AdvertisementController advertisement, UserController userController)async{
     //To get SharedPreferenceData
    SharedPreferences preference = await SharedPreferences.getInstance();
     List<String>? savedUrlList = preference.getStringList('videoUrlList');

     var  id = preference.get('id');
     advertisement.getSingleUserData(id.toString()).then((value) async {
       String currentDate='${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
       print(advertisement.watchDate);
       print(currentDate);

       for(var i=0;i<advertisement.videoList.length;i++){
         videoUrlList.add(advertisement.videoList[i].videoUrl!);
       }
       if(currentDate == advertisement.watchDate){
         setState(() {
           savedUrlList !=null? videoUrlListForSharedPreference = savedUrlList:videoUrlListForSharedPreference=[];

         });
         print(advertisement.videoList.length);
         if(videoUrlListForSharedPreference.contains( advertisement.videoList[0].videoUrl!)){
           _controller = VideoPlayerController.network(
               advertisement.videoList[0].videoUrl!)
             ..initialize().then((_) {
               //  startTimer(advertisement,userController,0);
               setState(() {
                 videoDuration = _controller!.value.duration;
               });
               print('Video Duration: ${videoDuration!.inSeconds}');
               // print('Video Position: ${_controller!.value.position}');
               setState(() {
                 _controller!.play();
               });
             });
         }else {
           _controller = VideoPlayerController.network(
               advertisement.videoList[0].videoUrl!)
             ..initialize().then((_) {
               startTimer(advertisement,userController,0);
               setState(() {
                 videoDuration = _controller!.value.duration;
               });
               print('Video Duration: ${videoDuration!.inSeconds}');
               // print('Video Position: ${_controller!.value.position}');
               setState(() {
                 _controller!.play();
               });
             });
         }
       }else {
         List<String>? savedUrlList = preference.getStringList('videoUrlList');
         setState(() {
           savedUrlList !=null? videoUrlListForSharedPreference = savedUrlList:videoUrlListForSharedPreference=[];
         });
         if(videoUrlListForSharedPreference.contains( advertisement.videoList[0].videoUrl!)){
           _controller = VideoPlayerController.network(
               advertisement.videoList[0].videoUrl!)
             ..initialize().then((_) {
               //  startTimer(advertisement,userController,0);
               setState(() {
                 videoDuration = _controller!.value.duration;
               });
               print('Video Duration: ${videoDuration!.inSeconds}');
               // print('Video Position: ${_controller!.value.position}');
               setState(() {
                 _controller!.play();
               });
             });
         }else {
           _controller = VideoPlayerController.network(
               advertisement.videoList[0].videoUrl!)
             ..initialize().then((_) {
               startTimer(advertisement,userController,0);
               setState(() {
                 videoDuration = _controller!.value.duration;
               });
               print('Video Duration: ${videoDuration!.inSeconds}');
               // print('Video Position: ${_controller!.value.position}');
               setState(() {
                 _controller!.play();
               });
             });
         }
       }
     });





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
          advertisement.videoList[index].videoUrl!)
        ..initialize().then((_) async{
          startTimer(advertisement,userController,index);
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
          advertisement.videoList[index].videoUrl!)
        ..initialize().then((_) async {
          startTimer(advertisement, userController,index);
          setState(() {
            videoDuration = _controller!.value.duration;
          });

          setState(() {
            _controller!.play();
          });
        });
    }

  }
   bool _isLoading = true;

  @override
  void dispose() {
    _timer!=null?_timer!.cancel():null;
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserController userController =Get.find();
    String currentDate='${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';


    return GetBuilder<AdvertisementController>(
        builder: (advertisement) {
          Future.delayed(Duration.zero, () async {
            if (counter == 0) {
              SharedPreferences preference = await SharedPreferences.getInstance();
              var  id = preference.get('id');
              await advertisement.getSingleUserData(id.toString());
              if(currentDate != advertisement.watchDate){
                await preference.remove('videoUrlList');
              }

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

        child: Column(
          children: [
            Text('Video watched: ${videoUrlListForSharedPreference.length} /${advertisement.videoList.length}',style: TextStyle(fontSize: 20),),
            Text('Today Earn: ${videoUrlListForSharedPreference.length} TK',style: TextStyle(fontSize: 20),),
          ],
        ),

      ),
      ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: advertisement.videoList.length,
          itemBuilder: (BuildContext context, int index) {
          return videoUrlListForSharedPreference.contains(advertisement.videoList[index].videoUrl)?
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: Colors.red.shade100,
          //       borderRadius: BorderRadius.all(Radius.circular(10))
          //     ),
          //     padding: const EdgeInsets.all(8.0),
          //
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Row(
          //           children: [
          //             Image.asset('assets/images/video_icon.png',width: 50,height: 50,),
          //
          //             Padding(
          //               padding: const EdgeInsets.only(left: 18.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text('Title: ${ advertisement.videoList[index].title}'),
          //                   Text('Date: ${ advertisement.videoList[index].date}'),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //         videoUrlListForSharedPreference.contains(advertisement.videoList[index].videoUrl)? Text('Watched'):Container()
          //       ],
          //     ),
          //   ),
          // ):
           Container():InkWell(
            onTap: (){
            //  _timer!.cancel();
              _controller!.dispose();
              playVideo(index,advertisement,userController);
            },

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/video_icon.png',width: 50,height: 50,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Title: ${advertisement.videoList[index].title}'),
                              Text('Date: ${advertisement.videoList[index].date}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      )
      
    ],
  );




}
