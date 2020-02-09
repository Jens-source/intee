import 'package:flutter/material.dart';
import 'addFriendPage.dart';
import 'chatHome.dart';
import 'chatPage.dart';
import 'designPage.dart';
import 'feedPage.dart';
import 'jobPage.dart';
import 'library.dart';
import 'timelinePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


File sampleImage;
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      floatingActionButton:  new FloatingActionButton(
//        onPressed: userManagement.updateProfilePicture,
//        tooltip: 'Add Image',
//        child: new Icon(Icons.add_a_photo),
//      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        child: TabBar(
          unselectedLabelColor: Colors.black38,
          labelColor: Colors.black,
          indicatorColor: Colors.white,
              
          controller: tabController,
          tabs: <Widget>[
            new Tab(icon: Icon(Icons.home)),
            new Tab(icon: Icon(Icons.chat)),
            new Tab(icon: Icon(Icons.add_circle, color: Colors.red, size: 35)),
            new Tab(icon: Icon(Icons.explore)),
            new Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
      body : new TabBarView(
        controller: tabController,
          children: <Widget>[
            FeedPage(),
            ChatHome(),
            DesignPage(),
            JobPage(),
            LibraryPage()
          ],

      ),
    );
  }
}

Widget enableUpload() {
  return Container(
    child: Column(
      children: <Widget>[
        Image.file(sampleImage, height: 300.0, width: 300.0),
        RaisedButton(
          elevation: 7.0,
          child: Text('Upload'),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () {
            final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child('myimage.jpg');
            final StorageUploadTask task =
               firebaseStorageRef.putFile(sampleImage);
          },
        )
      ],
    )
  );
}

//          actions: <Widget>[
//            IconButton(
//                icon: Icon(Icons.exit_to_app),
//                onPressed: () {
//                  FirebaseAuth.instance.signOut().then((value) {
//                    Navigator
//                        .of(context)
//                        .pushReplacementNamed('/landingpage');
//                  }).catchError((e) {
//                    print(e);
//                  });
//                }
//            ),
//          ],
//
//          title: new Text('Tabs app'),
//          backgroundColor: Colors.teal,
//          bottom: new TabBar(
//            controller: controller,
//            tabs: <Widget>[       new Tab(icon: new Icon(Icons.access_alarm)),
//              new Tab(icon: new Icon(Icons.account_balance)),
//              new Tab(icon: new Icon(Icons.category)),
//              new Tab(icon: new Icon(Icons.cake)),
//            ],
//          ),
//        ),
//
//        body: new TabBarView(
//          controller: controller,
//          children: <Widget>[
//            new jobPage.JobPage(),
//            new timelinePage.TimelinePage(),
//            new profilePage.ProfilePage(),
//            new designPage.DesignPage()
//          ],
//        )
//    );
//
//  }
//}