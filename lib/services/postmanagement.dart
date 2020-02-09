import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:http/http.dart';

class PostManagement {

  static Future updateMediaUrl(context, mediaUrl, description) async {

    var randomno = Random();
    String postId = randomno.nextInt(9999999).toString();
    var date = new DateTime.now().toIso8601String();
    print(mediaUrl[0]);

   await FirebaseAuth.instance.currentUser().then((val) {
     Firestore.instance.collection('posts').add({
       for(int i = 0; i < mediaUrl.length; i++)
         'mediaUrl${i + 1}': mediaUrl[i],
       'comments': 0,
       'likes': 0,
       'description': description,
       'location': '',
       'postId': postId,
       'displayName': val.displayName,
       'ownerId': val.uid,
       'timestamp': date,
     }).then((value){
       print('written to posts');
     });
   });



    var postPhoto = new UserUpdateInfo();
    var postPic = new UserUpdateInfo();


    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(postPic).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .collection('posts').add({
            'postId': postId
          });
          print('Wriiten postId to user');
        }).catchError((e) {
          print(e);
        }
        );
      });
    }


    );
  }

  static Future addLike(postId, ownerId) async {
    var date = new DateTime.now().toIso8601String();

    var likes = new UserUpdateInfo();
    int like;
    await Firestore.instance.collection('likes')
        .add({
      'timestamp': date,
      'likerId': ownerId,
      'postId': postId,
    }).then((vol) {
      FirebaseAuth.instance.currentUser().then((val) {
        val.updateProfile(likes).then((user) {
          Firestore.instance
              .collection('posts')
              .where('postId', isEqualTo: postId)
              .getDocuments()
              .then((docs) {
            like = docs.documents[0].data['likes'] + 1;
            Firestore.instance.document(
                '/posts/${docs.documents[0].documentID}')
                .updateData({
              'likes': like
            });
          });
        });
      });
    });
  }

  static removeLike(postId, ownerId) async {
    var likes = new UserUpdateInfo();
    int like;
    String docId;

    await Firestore.instance.collection('likes')
        .where('postId', isEqualTo: postId)
        .getDocuments()
        .then((doc){
          Firestore.instance.document('likes/${doc.documents[0].documentID}')
        .delete()
        .then((vol) {
      FirebaseAuth.instance.currentUser().then((val) {
        val.updateProfile(likes).then((user) {
          Firestore.instance
              .collection('posts')
              .where('postId', isEqualTo: postId)
              .getDocuments()
              .then((docs) {
            like = docs.documents[0].data['likes'] - 1;
            Firestore.instance.document(
                '/posts/${docs.documents[0].documentID}')
                .updateData({
              'likes': like
            });
          });
          });
        });
      });
    });
  }
}

