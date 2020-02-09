import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'commentPage.dart';
import 'services/postManagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/userManagement.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';


bool isLiked = false;
List description = new List();
String uid;
bool showHeartOverlay = false;
bool liked = false;
String name;
String photo;
List <Widget>media = new List<Widget>();
QuerySnapshot likes;
List <bool> like = new List <bool>();






final GoogleSignIn googleSignIn = GoogleSignIn();
QuerySnapshot friendList;


class FeedPage extends StatefulWidget  {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {




  void signOutGoogle() async {
    await googleSignIn.signOut();
    Navigator.of(context).pushReplacementNamed('/loginpage');

    print("User Sign Out");
  }

  UserManagement userManagement = new UserManagement();


  initFriends() async{
    return await FirebaseAuth.instance
        .currentUser().then((val) async {
          uid = val.uid;
          name = val.displayName;
          photo = val.photoUrl;
      await Firestore.instance.collection('/users')
          .where('uid', isEqualTo: val.uid)
          .getDocuments()
          .then((docs) async {
        await Firestore.instance.document(
            '/users/${docs.documents[0].documentID}')
            .collection('friends')
            .getDocuments()
            .then((fid) {
              setState(() {
                friendList = fid;
              });
        }).then((like) async{
          await Firestore.instance.collection('likes')
              .where('likerId', isEqualTo: uid)
              .getDocuments()
              .then((doc) {
                setState(() {
                  likes = doc;
                });
          });
          });
      });
    });
  }




  @override
  void initState() {
    super.initState();
    initFriends();
  }


  @override
  Widget build(BuildContext context) {
      return new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text('Intee',style: TextStyle(
              color: Colors.black,
              fontSize: 24
            ),),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                },
              ),
              IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/uploadpostpage');
                },
              ),
            ],
          ),
          body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: friendList == null ? 0 : friendList.documents.length,
          itemBuilder: (BuildContext context, i) {
            return new StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("posts")
                    .where('ownerId', isEqualTo: friendList.documents[i].data['friendId'])
                    .snapshots(),
                builder: (context, snap) {


                  //just add this line
                  if (snap.data == null)


                    return new Center(child: CircularProgressIndicator());
                  return new ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snap.data.documents.length,
                      itemBuilder: (BuildContext context, i) {
                        media.clear();




                        for (int j = 0; j <
                            snap.data.documents[i].data.length - 8; j++) {
                          media.add(
                            GestureDetector(

                              onDoubleTap: () {
                                setState(() {
                                 {
                                    Timer(
                                        const Duration(milliseconds: 500), () {
                                      setState(() {
                                        Icon(
                                                Icons.favorite, color: Colors.white, size: 75,
                                        );
                                      });
                                    }
                                    );
                                  }
                                });
                                if (like[i - 1] == false)
                                  setState(() {
                                    like[i - 1] = true;
                                    PostManagement.addLike(
                                        snap.data.documents[i - 1]
                                            .data['postId'], uid);
                                  });
                                else
                                  setState(() {
                                    like[i - 1] = false;
                                    PostManagement.removeLike(
                                        snap.data.documents[i - 1]
                                            .data['postId'], uid);
                                  });
                              },
                              child:
                            Image(
                                image:
                                NetworkImage(
                                    snap.data.documents[i].data['mediaUrl${j +
                                        1}'])
                            ),
                            )
                          );
                        }
                        i++;


                        if(like.length != snap.data.documents.length  && likes.documents.length != 0) {
                            for (int k = 0; k < likes.documents.length; k++) {
                              if (snap.data.documents[i - 1].data['postId'] ==
                                  likes.documents[k].data['postId']) {
                                like.add(true);
                              }
                              else
                                like.add(false);
                            }
                        }

                        else if(like.length != snap.data.documents.length){
                          like.add(false);
                        }


                        return new Container(
                            child: Card(
                                elevation: 4,
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, bottom: 10, top: 10),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.album),
                                        title: Text(
                                            'The Enchanted Nightingale'),
                                        subtitle: Text(
                                            'Project and design by ${snap
                                                .data
                                                .documents[i - 1]
                                                .data['displayName']}.'),
                                      ),

                                      CarouselSlider(
                                        enableInfiniteScroll: false,
                                        enlargeCenterPage: false,
                                        viewportFraction: 0.9,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        items: media,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                              icon: like[i-1] == true ? Icon(Icons.favorite, color: Colors.red,) :
                                                                      Icon(Icons.favorite_border, color: Colors.black,),

                                              onPressed: () {
                                                  if(like[i-1] == false)
                                                  setState(() {
                                                    like[i-1] = true;
                                                    PostManagement.addLike(snap.data.documents[i -1].data['postId'], uid);
                                                  });
                                                  else
                                                    setState(() {
                                                      like[i-1] = false;
                                                      PostManagement.removeLike(snap.data.documents[i -1].data['postId'], uid);
                                                    });
                                              },
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.chat_bubble_outline, color: Colors.black,),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                      new Comment(snap.data.documents[i - 1].data['postId'], uid, name, photo)));
                                            },
                                          ),

                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 330, bottom: 5),
                                        child: Text('${snap.data.documents[i - 1]
                                          .data['likes']} likes', style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child:
                                              Text(snap.data.documents[i - 1]
                                                  .data['displayName'], style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),)),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              child:
                                              Text(snap.data.documents[i - 1]
                                                  .data['description'])),
                                        ],

                                      )

                                    ]
                                )
                            )
                        );
                      });
                });
          })
      );
  }
}

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}


class _UploadPostState extends State<UploadPost> {
//  List<Asset> _imageFile = List<Asset>();
  FirebaseUser user;
  String postText;
  List _image = new List();


//  Future getImageGallery() async {
//    var tempImage = await MultiImagePicker.pickImages(maxImages: 15, enableCamera: true);
//    setState(() {
//      _imageFile = tempImage;
//    });
//  }
//
//
//  void _clear() {
//    setState(() => _imageFile = null);
//  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((val) {
      user = val;
    }).catchError((e) {
      print(e);
    });
  }
//
//  Widget buildGridViewLarge() {
//    return GridView.count(
//      crossAxisCount: 3,
//      children: List.generate(_imageFile.length, (index) {
//        Asset asset = _imageFile[index];
//        return AssetThumb(
//          asset: asset,
//          width: 400,
//          height: 400,
//        );
//      }),
//    );
//  }
//
//  Widget buildGridViewSmall() {
//    return GridView.count(
//      crossAxisCount: 3,
//        children: List.generate(_imageFile.length, (index) {
//        Asset asset = _imageFile[index];
//        return AssetThumb(
//          asset: asset,
//          width: 200,
//          height: 200,
//        );
//      }),
//    );
//  }


//  Future saveImage(Asset asset) async {
//    ByteData byteData = await asset.requestOriginal();
//    List<int> imageData = byteData.buffer.asUint8List();
//    StorageReference ref = FirebaseStorage.instance.ref().child('postpics/${DateTime.now()}.png');
//    StorageUploadTask uploadTask = ref.putData(imageData);
//    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//    String downloadUrl =  await taskSnapshot.ref.getDownloadURL();
//    _image.add(downloadUrl);
//    return await (await uploadTask.onComplete).ref.getDownloadURL();
//  }


  @override
  Widget build(BuildContext context) =>
      Scaffold(
          bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.photo_library),
//                      onPressed: () => getImageGallery()
                  )
                ],
              )
          ),


          body: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.clear, size: 30,),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                '/homepage');
                          },
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 250),
                            height: 35,
                            child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color.fromRGBO(81, 113, 100, 0.6),
                                elevation: 0,
                                child: OutlineButton(
                                    borderSide: BorderSide(color: Colors.white),
                                    child: Center(
                                      child: Text(
                                        'Post',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacementNamed('/feedpage');
//                                      for(int i = 0; i < _imageFile.length; i++)
//                                      {
//                                        await saveImage(_imageFile[i]);
//                                      }
                                      PostManagement.updateMediaUrl(context, _image, postText);

                                    })
                            )
                        )
                      ],
                    )
                ),
                Row(
                  children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 140, left: 10),
                  child: CircleAvatar(
                      backgroundImage: user == null ? null : NetworkImage(
                          user.photoUrl)
                  ),
                ),
                Container(
                  width: 350,
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: "What's happening?",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                        obscureText: false,
                        maxLines: 10,
                        expands: false,
                        onChanged: (value) {
                          setState(() {
                            postText = value;
                          });
                        }
                    )
                ),
                  ]
                ),
                    Expanded(
//                      child: buildGridViewLarge(),

                ),
                  ],
          )

      );
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

