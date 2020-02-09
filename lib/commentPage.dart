import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'feedPage.dart';





class Comment extends StatefulWidget {
  FirebaseUser user;

String postId;
String uid;
  String name;
  String photo;

Comment(this.postId, this.uid, this.name, this.photo);

createState() => _CommentState(this.postId, this.uid, this.name, this.photo);
}

class _CommentState extends State<Comment> {

  _CommentState(this.postId, this.uid, this.name, this.photo);

  String postId;
  String uid;
  String name;
  String photo;


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection('comments').add({
        'postId': postId,
        'comment': messageController.text,
        'from': widget.name,
        'photo': widget.photo,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/homepage');
          },
        ),
        title: Text("Comment", style: TextStyle(
          color: Colors.black
        ),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send, color: Colors.black,),
            onPressed: () {
              //Send comment as a message to a friend
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('comments')
                .where('postId', isEqualTo: postId)
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                    from: doc.data['from'],
                    text: doc.data['comment'],
                    date: doc.data['date'],

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
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Enter a Comment...",

                      ),
                      controller: messageController,
                    ),
                  ),
                  SendButton(
                    text: "Post",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;


  final String date;

  const Message({Key key, this.from, this.text, this.date,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: NetworkImage(photo),
            ),
            title: Text(name),
            subtitle: Container(padding: EdgeInsets.only(bottom: 10),
                child: Text(text),),
            trailing: Text(date),
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
  }
}