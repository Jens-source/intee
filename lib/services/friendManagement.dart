import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'dart:math';

class FriendManagement {


  static Future updateFriend(context, friendName, friendLastName, friendPhoto,
      friendId) async {
    var randomNo = Random();
    String friendship = randomNo.nextInt(9999999).toString();


    FirebaseAuth.instance.currentUser().then((val) async {
      Firestore.instance.collection('/users')
          .where('uid', isEqualTo: val.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document(
        '/users/${docs.documents[0].documentID}')
        .collection('friends')
           .add({
          'friendName': friendName,
          'friendPhoto': friendPhoto,
          'friendship': friendship,
          'friendId': friendId
        }).then((values) {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: friendId)
              .getDocuments()
              .then((docss) {
                Firestore.instance.document(
                  '/users/${docss.documents[0].documentID}')
                .collection('friends')
                    .add({
                  'friendName': docs.documents[0].data['firstName'],
                  'friendPhoto': val.photoUrl,
                  'friendship': friendship,
                  'friendId': val.uid
                }).catchError((e){
                  print(e);
                }
                );
          }).catchError((e) {
            print (e);
          });
        })
            .then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/chathomepage');
        }).catchError((e) {
          print(e);
        });
      });
    });
  }
}




