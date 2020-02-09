import 'package:flutter/material.dart';
import 'services/userManagement.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}


class _AddPostPageState extends State<AddPostPage> {
  File newProfilePic;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
      uploadImage();
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: newProfilePic.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      newProfilePic = cropped ?? newProfilePic;
    });
  }


  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      newProfilePic = selected;
    });
  }

  void _clear() {
    setState(() => newProfilePic = null);
  }


  uploadImage() async {
    var randomno = Random();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${randomno.nextInt(5000).toString()}.jpg');
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


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: newProfilePic == null ? getChooseButton() : getUploadButton());
  }

  Widget getChooseButton() {
    return new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery
                .of(context)
                .size
                .height / 5,
            child: Column(
              children: <Widget>[
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://icon-library.net/images/default-profile-icon/default-profile-icon-24.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 15.0),
                Text(
                  'You have signed up.',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Choose a profile picture',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: getImage,
                            child: Center(
                              child: Text(
                                'Change pic',
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.blue,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/homepage');
                            },
                            child: Center(
                              child: Text(
                                'Skip',
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ))
      ],
    );
  }

  Widget getUploadButton() {
    return new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.teal.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: 350,
            top: 100,
            child: Column(
              children: <Widget>[
                if (newProfilePic != null) ...[

                  Image.file(newProfilePic),

                Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: FileImage(newProfilePic), fit: BoxFit.cover),
                        )),
                ],
                SizedBox(height: 90.0),
                Text(
                  'You have signed up',
                  style:
                  TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 90.0),
                Text(
                  'Tap upload to proceed',
                  style:
                  TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                child: Icon(Icons.crop),
                                onPressed: _cropImage,
                              ),
                              FlatButton(
                                child: Icon(Icons.refresh),
                                onPressed: _clear,
                              ),
                              FlatButton(
                                child: Icon(Icons.file_upload),
                                onPressed: uploadImage,
                              )
                            ],
                          ),
                          ),
                        )
                  ],
                )
              ],
            )
        )
      ],
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

