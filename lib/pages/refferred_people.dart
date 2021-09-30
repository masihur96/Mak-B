import 'package:flutter/material.dart';

class RefferredPeople extends StatefulWidget {
  const RefferredPeople({Key? key}) : super(key: key);

  @override
  _RefferredPeopleState createState() => _RefferredPeopleState();
}

class _RefferredPeopleState extends State<RefferredPeople> {
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
          'Refferred People',
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
          Container(
              width: size.width,
              child: Text(
                'You reffered 20 people',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: size.width * .04,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: size.width * .02),
                  child: Card(
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: AssetImage(
                              'assets/images/profile_image_demo.png'),
                        ),
                        title: Text(
                          'Demo username',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * .04,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                );
              })
        ],
      ),
    );
  }
}
