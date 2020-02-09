import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'feedPage.dart';
import 'services/postManagement.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'commentPage.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => new _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

  var profilePicUrl;
  var uid;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        profilePicUrl = user.photoUrl;
        uid = user.uid;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
            children: <Widget>[
              Container(
                  child: DefaultTabController(
                      length: 4,
                      child: Scaffold(
                          appBar: AppBar(
                            title: Container(
                              padding: EdgeInsets.only(top:15),
                              child: Text('Library',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  letterSpacing: 0.3
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 5,
                            bottom: TabBar(
                              labelStyle: TextStyle(fontSize: 14),
                              unselectedLabelColor: Colors.black54,
                              labelColor: Colors.black,
                              indicatorColor: Color.fromRGBO(166, 133, 119, 1),
                              isScrollable: true,
                              tabs: <Widget>[
                                new Tab(text: 'POSTS'),
                                new Tab(text: 'PROJECTS'),
                                new Tab(text: 'TEAMS'),
                                new Tab(text: 'COMMUNITIES')
                              ],

                            ),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.search, color: Colors.black),
                                onPressed: () {

                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.black),
                                onPressed: () {

                                },
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child: new FlatButton(
                                    child: new CircleAvatar(
                                      backgroundImage: new NetworkImage(
                                          profilePicUrl),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/profilepage');
                                    },
                                  )
                              ),

                            ],
                          ),
                          body: new TabBarView(
                            children: <Widget>[
                              Projects(),
                              Collections(),
                              Teams(),
                              Communities()
                            ],

                          )
                      )
                  )
              )
            ]
        )
    );
  }
}

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
List <Widget>media = new List<Widget>();
List<bool> like = new List<bool>();
String uid;
String name;
String photo;
QuerySnapshot likes;


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
}


@override
void initState() {
  super.initState();
  initFriends();
}




  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("posts")
            .where('ownerId', isEqualTo: uid).snapshots(),
        builder: (context, snap) {
          //just add this line
          if (snap == null) return CircularProgressIndicator();
          return ListView.builder(
              itemCount: snap == null ? 0 : snap.data.documents.length,
              itemBuilder: (BuildContext context, i) {
                media.clear();
                like.clear();

                for (int j = 0; j <
                    snap.data.documents[i].data.length - 8; j++) {
                  media.add(
                    Image(
                        image:
                        NetworkImage(
                            snap.data.documents[i].data['mediaUrl${j +
                                1}'])
                    ),
                  );
                }


                i++;
                print(snap.data.documents.length);
                print(like.length);
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


                if(snap == null) {
                  return Center(child: CircularProgressIndicator(),);
                } 


                return Container(

                  child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album),
                          title: Text('The Enchanted Nightingale'),
                          subtitle: Text('Project and design by ${snap.data.documents[i-1].data['displayName']}.'),
                        ),
                    CarouselSlider(
                      enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: 0.9,
                    height: MediaQuery.of(context).size.width,
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
  }

}

class Collections extends StatefulWidget {
  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {

  QuerySnapshot brainstorms;
  String name;
  String photo;
  QuerySnapshot comments;


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((val) {
      name = val.displayName;
      photo = val.photoUrl;
      Firestore.instance.collection('brainstorms')
          .where('ownerId', isEqualTo: val.uid)
          .getDocuments()
          .then((docs) {
        setState(() {
          brainstorms = docs;
        });
      }).catchError((e) {
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color.fromRGBO(0, 30, 100, 0.1),
        body: Container(
          child:
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: brainstorms == null ? 0 : brainstorms.documents.length,
            itemBuilder: (BuildContext context, i) {
              return Container(
                child: Card(
                    elevation: 4,
                    margin: EdgeInsets.only(
                        left: 0, right: 0, bottom: 10, top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(photo),
                          ),
                          title: Text(
                              name),
                          subtitle: Text(
                              'Project and design by ${brainstorms.documents[i]
                                  .data['description']}'),
                        ),
                        Image(
                          image: NetworkImage(
                            brainstorms.documents[i].data['image']
                          ),
                        ),
                        if(brainstorms.documents[i].data['brianstormId'] != null)
                        StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.collection('comments')
                                .where('brainstormId', isEqualTo: brainstorms.documents[i].data['brianstormId'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: Container(),
                                );
                              List<DocumentSnapshot> docs = snapshot.data.documents;
                              print(docs.length);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                itemCount: docs == null ? 0 : docs.length,
                                  itemBuilder: (BuildContext context, j){
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                        ),


                                        Container(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(docs[j].data['photo']),
                                            ),
                                            title: Text(docs[j].data['name']),
                                            subtitle: Container(padding: EdgeInsets.only(bottom: 10),
                                              child: Text(docs[j].data['comment']),),
                                            trailing: Text(docs[j].data['date']),
                                          ),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  bottom: new BorderSide(color: Colors.black12)
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  );

                              });
                            }
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 5, top: 3, bottom: 5),
                            child:
                            Text(comments == null ? '0' : comments.documents.length, style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),),
                            ),
                            Icon(
                              Icons.chat_bubble_outline, color: Colors.grey,
                            )

                          ],
                        )

                      ],
                    )
                ),
              );
            }),
        )
    );
  }
}

class Teams extends StatefulWidget {
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  QuerySnapshot brainstormDocs;
  List <QuerySnapshot> brains = new List <QuerySnapshot>();
  QuerySnapshot comments;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((val) {
      Firestore.instance.collection('users')
          .where('uid', isEqualTo: val.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document('users/${docs.documents[0].documentID}')
            .collection('brainstorms')
            .getDocuments()
            .then((bdocs) {
          setState(() {
            brainstormDocs = bdocs;
            print(brainstormDocs.documents.length);
          });
        }).then((docs) {
          for (int i = 0; i < brainstormDocs.documents.length; i++) {
            Firestore.instance.collection('brainstorms')
                .where('brainstormId',
                isEqualTo: brainstormDocs.documents[i].data['brianstormId'])
                .getDocuments()
                .then((bdocs) {
              setState(() {
                brains.add(bdocs);
              });
            });
          }
        });
      }).catchError((e) {
        print(e);
      });
    });
  }

  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: brains == null ? 0 : brains.length,
          itemBuilder: (BuildContext context, i) {
            return Container(
              child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(
                      left: 0, right: 0, bottom: 10, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            brains[i].documents[0].data['ownerId']),
                        subtitle: Text(
                            'Project and design by ${brains[i].documents[0]
                                .data['ownerId']}'),
                      ),
                      Image(
                        image: NetworkImage(
                            brains[i].documents[0].data['image']
                        ),
                      ),
                      if(brains[i].documents[0].data['brainstormId'] != null)
                        StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.collection('comments')
                                .where('brainstormId', isEqualTo: brains[i]
                                .documents[0].data['brainstormId'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: Container(),
                                );
                              List<DocumentSnapshot> docs = snapshot.data
                                  .documents;
                              print(docs.length);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: docs == null ? 0 : docs.length,
                                  itemBuilder: (BuildContext context, j) {
                                    return Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                          ),

                                          Container(
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    docs[j].data['photo']),
                                              ),
                                              title: Text(docs[j].data['name']),
                                              subtitle: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                    docs[j].data['comment']),),
                                              trailing: Text(
                                                  docs[j].data['date']),
                                            ),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    bottom: new BorderSide(
                                                        color: Colors.black12)
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                        ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 5, top: 3, bottom: 5),
                            child:
                            Text(comments == null ? '0' : comments.documents
                                .length, style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),),
                          ),
                          Icon(
                            Icons.chat_bubble_outline, color: Colors.grey,
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new Design(brains[i].documents[0].data['image'])));
                            },
                          )
                        ],
                      )

                    ],
                  )
              ),
            );
          }),
    );
  }

}

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(0, 30, 100, 0.1),
      body: Text('Communities'),
    );
  }

}


class Design extends StatefulWidget {
  Design(this.pic);
  final pic;
  @override
  _DesignState createState() => _DesignState(this.pic);
}



class _DesignState extends State<Design> {
  _DesignState(this.pic);

  final pic;
  static GlobalKey screen = new GlobalKey();
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  List<Offset> _points = <Offset>[];

  ScreenShot() async {
    RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    var filePath = await ImagePickerSaver.saveFile(
        fileData: byteData.buffer.asUint8List());
    print(filePath);
  }


  @override
  Widget build(BuildContext context) {
    return new Screenshot(
        controller: screenshotController,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              new IconButton(
                  icon: Icon(Icons.clear,
                    color: Colors.white,),
                  onPressed: () {
                    setState(() {
                      _points.clear();
                    });
                  }
              ),
              IconButton(
                icon: Icon(Icons.add_circle,
                    color: Colors.white),
                onPressed: () {
                  screenshotController.capture().then((
                      File image) {
                    setState(() async {
                      _imageFile = image;
                      final StorageReference firebaseStorageRef = FirebaseStorage
                          .instance
                          .ref()
                          .child(
                          'jens/${DateTime.now()}.jpg');
                      final StorageUploadTask uploadTask = firebaseStorageRef
                          .putFile(_imageFile);
                      StorageTaskSnapshot taskSnapshot = await uploadTask
                          .onComplete;
                      String downloadUrl = await taskSnapshot
                          .ref.getDownloadURL();
                      final StorageUploadTask task = firebaseStorageRef
                          .putFile(_imageFile);
                      task.onComplete.then((value) {

                      }).catchError((e) {
                        print(e);
                      });
                    });
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.line_style,
                    color: Colors.white),
                onPressed: () {
                },
              ),
            ],
          ),
        body: new Stack(
          children: <Widget>[
             Stack(
                  children: <Widget>[
                    new Container(
                        child: Image(image: NetworkImage(pic),)
                    ),
                    Stack(
                      children: <Widget>[
                        new Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: new GestureDetector(
                            onPanUpdate: (DragUpdateDetails details) {
                              setState(() {
                                RenderBox object = context.findRenderObject();
                                Offset _localPosition =
                                object.globalToLocal(details.localPosition);
                                _points = new List.from(_points)
                                  ..add(_localPosition);
                              });
                            },
                            onPanEnd: (DragEndDetails details) =>
                                _points.add(null),
                            child: new CustomPaint(
                              painter: new Signature(
                                  points: _points
                              ),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ]
              ),
          ],
        )
        )
    );
  }

}

class Signature extends CustomPainter {

  List<Offset> points;

  Signature({this.points});


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}