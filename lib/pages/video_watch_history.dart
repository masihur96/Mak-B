import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/user_controller.dart';

class VideoWatchedHistory extends StatefulWidget {
  const VideoWatchedHistory({Key? key}) : super(key: key);

  @override
  _VideoWatchedHistoryState createState() => _VideoWatchedHistoryState();
}

class _VideoWatchedHistoryState extends State<VideoWatchedHistory> {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Video Watch History',
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width * .04,
          ),
        ),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * .04),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: userController.watchHistoryList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: size.width * .02),
                  child: Card(
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundColor: Colors.grey.shade200,
                      //   backgroundImage: NetworkImage(
                      //       userController.referredList[index].),
                      // ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Watch Date:  ${userController.watchHistoryList[index].watchDate!}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .045,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: size.width * .01,
                          ),
                          Text(
                            'Video watched:  ${userController.watchHistoryList[index].videoWatched!}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .04,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
