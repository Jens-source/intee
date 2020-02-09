import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/friendManagement.dart';
import 'services/crud.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  String friend;
  String _photoUrl;
  String _friend;


  ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: Text('Friend search'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/chathomepage');
              },
            )
        ),
        body: Stack(
            children: <Widget>[
              ListTile(
                  title: TextField(
                    onChanged: (value) {
                      setState(() {
                        friend = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter your friend's ID",
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () =>
                    _friend = friend,


                  )
              ),
              if(_friend != null)
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .where('displayName', isEqualTo: _friend)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );


                  List<DocumentSnapshot> docs = snapshot.data.documents;


                  List<Widget> messages = docs
                      .map((doc) =>
                      Message(
                        photo: doc.data['photoUrl'],
                        firstName: doc.data['firstName'],
                        lastName: doc.data['lastName'],
                              uid : doc.data['uid']
                      ))
                      .toList();
                  return ListView(
                    controller: scrollController,
                    children: <Widget>[

                      ...messages,
                    ],
                  );
                },
              ),
            ])
    );
  }
}

class Message extends StatelessWidget {
  final String photo;
  final String firstName;
  final String lastName;
  final String uid;

  const Message({Key key, this.photo, this.firstName, this.lastName, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Column(
        children: <Widget>[
          SizedBox(height: 100),
          Center(
              child: Container(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(photo),
                  )
              )
          ),
          SizedBox(height: 10),
          Center(
              child: Container(
                height: 80,
                child: Text('${firstName} ${lastName}',
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold
                  ),),
              )
          ),
          SizedBox(height: 10,),
          Container(
              height: 30.0,
              width: 200,
              child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  elevation: 7.0,
                  child: Center(
                      child: Container(
                          height: 80,
                          width: 80,
                          child: GestureDetector(
                            onTap: () {
                              FriendManagement.updateFriend(context, firstName, lastName, photo, uid);
                            },
                            child: Text(
                              'ADD',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          )
                      )
                  )
              )
          ),
        ]
    );
  }
}