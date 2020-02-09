import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profileEdit.dart';
import 'resumeEdit.dart';
import 'services/userManagement.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

class EditProfilePage extends StatefulWidget {
@override
_EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  var profilePicUrl =  'https://www.cmcaindia.org/wp-content/uploads/2015/11/default-profile-picture-gmail-2.png';
  String userName = '';
  File newProfilePic;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
      uploadImage();
    });
  }

  uploadImage() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${DateTime.now()}.jpg');
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(newProfilePic);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl =  await taskSnapshot.ref.getDownloadURL();
    final StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    task.onComplete.then((value) {
      userManagement.updateProfilePicture(downloadUrl).then((val) {
        Navigator.of(context).pushReplacementNamed('/homepage');
      });
    }).catchError((e) {
      print(e);
    });
  }


  UserManagement userManagement = new UserManagement();


  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        profilePicUrl = user.photoUrl;
        userName = user.displayName;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.lightBlue,
        title: new Text('Edit Profile'),
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black54,
            onPressed: () {
          Navigator.of(context).pushReplacementNamed('/profilepage');
        }),
      ),
      body: new Stack(
          children: <Widget>[
            Container(
              child: DefaultTabController(
                  length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(
                                  profilePicUrl),
                              colorFilter: ColorFilter.mode(Color(0xFF757575), BlendMode.darken),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        ),
                           child: new IconButton(
                          icon: Icon(Icons.add_a_photo),
                          color: Colors.white,
                          onPressed: getImage,
                            )),
                        backgroundColor: Colors.grey,
                        bottom: TabBar(
                    tabs: <Widget>[
                      new Tab(text: 'Profile'),
                      new Tab(text: 'Resume')
                    ],
                  ),
                ),
                body : new TabBarView(
                  children: <Widget>[
                    ProfileEdit(),
                    ResumeEdit()
                  ],

                )
            )
              ))],
            )
    );
  }
}