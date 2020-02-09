import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app43221/timelinePage.dart';
import 'services/userManagement.dart';
import 'package:image_picker/image_picker.dart';

class DesignPage extends StatefulWidget  {
  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {

  File _image;


  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;


    });
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new TimelinePage()));


  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new LoadDesign(_image, null)));
  }

  Future loadImage(File image) async {
    print(image);
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: Image.file(
              image
            ),

          )
        ],
      )
    );
  }

  List<Widget> images = List<Widget>();

  Future<bool> addProject(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,

        builder: (BuildContext context) {
          return Scaffold(
              backgroundColor: Colors.black26,
              body: Container(
                  padding: EdgeInsets.only(top: 200, left: 70,),
                  child:
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 75,
                            padding: EdgeInsets.only(left: 5),
                            child: Material(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.lightBlue,
                                child:
                                IconButton(
                                  iconSize: 35,
                                  color: Colors.white,
                                  splashColor: Colors.white12,
                                  hoverColor: Colors.white12,
                                  highlightColor: Colors.white12,
                                  focusColor: Colors.white12,
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    getImageCamera();
                                  },
                                )
                            ),
                          ),
                          Container(
                            height: 70,
                            width: 180,
                            padding: EdgeInsets.only(left: 110),
                            child: Material(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orangeAccent,
                                child:
                                IconButton(
                                  iconSize: 35,
                                  color: Colors.white,
                                  splashColor: Colors.white12,
                                  hoverColor: Colors.white12,
                                  highlightColor: Colors.white12,
                                  focusColor: Colors.white12,
                                  icon: Icon(Icons.library_books),
                                  onPressed: () {
                                    getImageGallery();
                                  },
                                )
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[

                          Text(
                            'Take a picture',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,

                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(left: 70),
                            child:
                          Text(
                            'Choose from gallery',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,

                            ),
                          ),
                          )
                        ],
                      )

                    ],
                  )
              )
          );
        });
  }




  @override
  Widget build(BuildContext context) {

    images.clear();
   images.add(
     OutlineButton(
       borderSide: BorderSide.none,
       splashColor: Colors.white24,
       highlightColor: Colors.white24,
       child:
       Container(

       decoration: new BoxDecoration(
         boxShadow: [
           BoxShadow(
             color: Colors.grey,
             blurRadius: 10.0,
             spreadRadius: 5.0,
             offset: Offset(0, 30,)
             ),
         ],
           borderRadius: new BorderRadius.all(Radius.circular(30))
       ),
     child: ClipRRect(
     child: Image.asset('lib/assets/01.jpg'),
     borderRadius: BorderRadius.circular(30),
     ),
   ),
         onPressed: () {
           addProject(context);
   },
     )
   );
    images.add(
        OutlineButton(
          borderSide: BorderSide.none,
          splashColor: Colors.white24,
          highlightColor: Colors.white24,
          child:
          Container(
            decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: Offset(0, 30,)
                  ),
                ],
                borderRadius: new BorderRadius.all(Radius.circular(30))
            ),
            child: ClipRRect(
              child: Image.asset('lib/assets/2.jpg'),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            addProject(context);

          },
        )
    );
    print(images);

    return new Scaffold(
        backgroundColor: Color.fromRGBO(0, 30, 100, 0.1),
        body:
        Center(
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(bottom: 450, left: 125),
                    child: Text(
                      "Let's design",
                      style: TextStyle(
                          fontSize: 30
                      ),
                    )
                ),
                Container(
                  height: 350 ,
                  padding: EdgeInsets.only(top: 50),
                  child: CarouselSlider(
                  items: images,
                  height: 200,
                  aspectRatio: 16/9,
                  viewportFraction: 0.6,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                )
                ),


              ],
            )

        )
    );
  }
}

class LoadDesign extends StatefulWidget {
    LoadDesign(this.image, this.friends);
  final image;
    final List<DocumentSnapshot> friends;
  @override
  _LoadDesignState createState() => _LoadDesignState(this.image, this.friends);
}

class _LoadDesignState extends State<LoadDesign> {
  _LoadDesignState(this.image, this.friends);
  final List<DocumentSnapshot> friends;
  File image;
  String designText;
  String uid;
  String downloadUrl;

  uploadImage() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('brainstorms/${DateTime.now()}.jpg');
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    downloadUrl =  await taskSnapshot.ref.getDownloadURL();
    final StorageUploadTask task = firebaseStorageRef.putFile(image);
    task.onComplete.then((value) {
        callback();
          Navigator.of(context).pushReplacementNamed('/librarypage');
        });
  }




  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((val){
      uid = val.uid;
    });
  }

  Future<void> callback() async {
    var randomno = Random();
    String brainstormId = randomno.nextInt(9999999).toString();

      await Firestore.instance.collection('brainstorms').add({
        'brainstormId' : brainstormId,
        'ownerId': uid,
        'image': downloadUrl,
        'description': designText,
        'date': DateTime.now().toIso8601String().toString(),
        for(int j = 0; j < friends.length; j++)
            'friends${j + 1}': friends[j].data['friendId']

      }).then((goo) {
        for(int j = 0; j < friends.length; j++)
          {
            UserManagement.updateBrainstormFriends(friends[j].data['friendId'], brainstormId);
          }
        UserManagement.updateBrainstormPicture(brainstormId);
        Navigator.of(context).pushReplacementNamed('/homepage');
      });
  }


  @override
  Widget build(BuildContext context) {
    if(image == null) {
      return Container();
    }


      return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: (
          Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width: 350,
                  padding: EdgeInsets.only(top: 40, right: 10, left: 10),
                  child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: "Explain the picture.",
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                      obscureText: false,
                      maxLines: 3,
                      expands: false,
                      onChanged: (value) {
                        setState(() {
                          designText = value;
                        });
                      }
                  )
              ),
            ],
          ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  height: MediaQuery.of(context).size.height * 0.13,
                  child:
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: friends == null ? 0 : friends.length,
                      itemBuilder: (BuildContext context, i){
                        return
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child:
                              CircleAvatar(
                                backgroundImage: NetworkImage(friends[i].data['friendPhoto'], ),
                              )
                          );

                      }),
                ),

              ],
            ),



          Row(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 60, bottom: 10),
            height: 60,
            width: 110,
            child: Material(
                borderRadius: BorderRadius.circular(50),
                color: Colors.lightGreen,
                child:
                IconButton(
                  iconSize: 25,
                  color: Colors.white,
                  splashColor: Colors.white12,
                  hoverColor: Colors.white12,
                  highlightColor: Colors.white12,
                  focusColor: Colors.white12,
                  icon: Icon(Icons.people_outline),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new AddFriend(image)));
                  },
                )
            ),
          ),
            Container(
              padding: EdgeInsets.only(left: 180, bottom: 10),
              height: 60,
              width: 230,
              child: Material(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.orangeAccent,
                  child:
                  IconButton(
                    iconSize: 25,
                    color: Colors.white,
                    splashColor: Colors.white12,
                    hoverColor: Colors.white12,
                    highlightColor: Colors.white12,
                    focusColor: Colors.white12,
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                       uploadImage();
                    },
                  )
              ),
            ),
          ],),


          Image.file(image, scale: 3),
        ],
      )),

    );
  }
}



class Design extends StatefulWidget {
  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {

  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[

          new Container(
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.black,),
              onPressed:  () {}
            ),
          ),
      new Container(
        child: new GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset _localPosition =
              object.globalToLocal(details.globalPosition);
              _points = new List.from(_points)..add(_localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
          child: new CustomPaint(
            painter: new Signature(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.clear),
        onPressed: () => _points.clear(),
      ),
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


class AddFriend extends StatefulWidget {
  AddFriend(this.image);
  final image;
  @override
  _AddFriendState createState() => _AddFriendState(this.image);
}

class _AddFriendState extends State<AddFriend> {
  _AddFriendState(this.image);
  final image;
  List<bool> friendList = new List<bool>();
  List<DocumentSnapshot> friendList2 = new List<DocumentSnapshot>();

  String designText;

  QuerySnapshot friends;

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['friendName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
            print(element);
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((val) {
      Firestore.instance.collection('users')
          .where('uid', isEqualTo: val.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document('users/${docs.documents[0].documentID}')
            .collection('friends')
            .getDocuments()
            .then((fdocs) {
          setState(() {
            friends = fdocs;
            for(int i = 0; i < fdocs.documents.length; i++) {
              friendList.add(false);
            }
          });
        });
      });
    });
  }

  String text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white12,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Add a Friend', style: TextStyle(
              color: Colors.black
          ),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check, color: Colors.black),
              onPressed: () {
                print(friendList);
                for(int j = 0; j < friendList.length; j++)
                  {
                    if(friendList[j] == true)
                      {
                        friendList2.add(friends.documents[j]);
                      }
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new LoadDesign(image, friendList2)));
                  }



              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                      Icons.search
                  ),
                  title: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                    obscureText: false,
                    maxLines: 1,
                    expands: false,
                    onChanged: (val) {
                      initiateSearch(val);
                    },

                  ),
                ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: friends == null ? 0 : friends.documents.length,
                      itemBuilder: (BuildContext context, i) {
                        return Row(
                          children: <Widget>[
                            Checkbox(
                              value: friendList[i],
                              onChanged: (bool value) {
                                setState(() {
                                  friendList[i] = value;
                                });
                              },
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(friends.documents[i]
                                  .data['friendPhoto']),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(friends.documents[i]
                                    .data['friendName'])
                            )
                          ],
                        );
                      }),
              ],
            )
          ],
        )
    );
  }

}


class SearchService {
  searchByName(String searchField) {
    return FirebaseAuth.instance.currentUser().then((val) {
      prefix0.Firestore.instance.collection('users')
      .where('uid', isEqualTo: val.uid)
      .getDocuments()
      .then((docs){
        Firestore.instance.document('users/${docs.documents[0].documentID}')
            .collection('friends')
            .where('friendName',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
            .getDocuments();
      });
    });
  }
}

Widget buildResultCard(data) {
    print(data['friendName']);
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(data['friendName'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              )
          )
      )
  );
}