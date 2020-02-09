import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'feedPage.dart';
import 'services/userManagement.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';


class SelectprofilepicPage extends StatefulWidget {

  @override
  _SelectprofilepicPageState createState() => _SelectprofilepicPageState();
}

class _SelectprofilepicPageState extends State<SelectprofilepicPage> {
  File newProfilePic;
  String _name;
  String picUrl;


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        picUrl = user.photoUrl;
        print(user.photoUrl);
      });
    }).catchError((e) {
      print(e);
    });
  }

  UserManagement userManagement = new UserManagement();
  @override
  Widget build(BuildContext context) {
    if(picUrl == null) {
      picUrl = 'https://i.stack.imgur.com/34AD2.jpg';
    }

      return new Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
              child:
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 100, bottom: 20),
                      child: Text(" Let's setup your profile", style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                      ),)
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 80, right: 80),
                      child: Center(
                          child:
                          Text(" Make it easier for your friends to find",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54
                            ),))
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 90, right: 90, bottom: 30),
                      child: Center(
                          child:
                          Text(
                            "and connect with you on Intee", style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54
                          ),))
                  ),
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                picUrl),
                            colorFilter: ColorFilter.mode(
                                Colors.black54, BlendMode.darken),
                            fit: BoxFit.cover
                        ),

                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      ),
                      child: new IconButton(
                          icon: Icon(
                            Icons.add_a_photo, color: Colors.white, size: 30,),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    new ImageEdit(picUrl)));
                          }
                      )
                  ),

                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextField(
                        decoration: InputDecoration(
                            labelText: 'Set a custom username',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        }
                    ),
                  ),


                  SizedBox(height: 25.0),

                  Container(
                      width: 270,
                      height: 40,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color.fromRGBO(81, 113, 100, 0.6),
                      ),
                      child: OutlineButton(
                          child: Center(
                              child: Text('Next',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  )
                              )
                          ),
                          onPressed: () {
                            UserManagement.updateNickName(_name);
                            Navigator.of(context).pushReplacementNamed('/homepage');
                          }
                      )
                  )


                ],
              )
          )
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
    return true;
  }
}

class ImageEdit extends StatefulWidget{
  ImageEdit(this.picUrl);
  final picUrl;

  @override
_ImageEditState createState() => _ImageEditState(this.picUrl);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.picUrl);
  final picUrl;
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }


  Future getImageGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = tempImage;
    });
    _cropImage();
  }

  Future getImageCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = tempImage;
    });
    _cropImage();
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });

  }

  void _clear() {
    setState(() => _imageFile = null);
  }


  @override
  Widget build(BuildContext context) =>
      new Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera)
              ),
              IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery)
              )
            ],
          )
        ),


        body: ListView(
          children: <Widget>[
            if(_imageFile == null) ...[
              Image(
                image: NetworkImage(picUrl)
              )
            ],
            if (_imageFile != null) ...[

              Image.file(_imageFile),
              Row(
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
                    onPressed: () {
                    },
                  )
                ],
              ),

              Uploader(file: _imageFile)

            ]
          ],
        )
      );
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://interi.appspot.com');

  StorageUploadTask _uploadTask;

  String filePath;
  String filePaths;

  void _startUpload() async {
    filePath = 'images/${DateTime.now()}.png';




    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
    String downloadUrl =  await snapshot.ref.getDownloadURL();
    await UserManagement.updateProfilePictureFirst(downloadUrl);
  }

  Future<Null> _handleRefresh() async{
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {


    });

  }


  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null) {


      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder:  (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =  event != null
          ? event.bytesTransferred / event.totalByteCount
              : 0;

          return Column(
            children: <Widget>[
              if(_uploadTask.isComplete)
                Stack(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.add),
                      onPressed: (
                      ) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        new SelectprofilepicPage()));
                      }
                    )
                  ],
                ),



              if(_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.resume,
                ),

              if(_uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause),
                  onPressed: _uploadTask.pause,
                ),

              LinearProgressIndicator(value: progressPercent),
              Text(
                '${(progressPercent * 100).toStringAsFixed(2)} %'
              )
            ],
          );

        });
    } else {
      return  FlatButton.icon(
        label: Text('Upload to firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }

  }
}

