import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/userManagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'services/crud.dart';


class ProfileEdit extends StatefulWidget {
@override
_ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String _email = 'Empty';
  String _about = 'Empty';
  String _firstName = "Empty";
  String _lastName = "Empty";
  String _phoneNumber = "Empty";
  String _location = "Empty";
  String _jobTitle = "Empty";
  String _desiredJobTypes = "Empty";
  String _desiredSalary = "Empty";
  String _relocatable = "Empty";
  String _degree = "Empty";
  String _school = "Empty";
  String _fieldOfStudy = "Empty";
  String _skills = "Empty";


  crudMethods crudObj = new crudMethods();
  QuerySnapshot info;

  Future<bool> addBasic(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Basic info', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'First name'),
                  onChanged: (value) {
                    this._firstName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Last name'),
                  onChanged: (value) {
                    this._lastName = value;
                  },
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Tell us about yourself'),
                  onChanged: (value) {
                    this._about = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  if (_about != 'Empty') {UserManagement.updateAbout(_about);};
                  if (_firstName != 'Empty') {UserManagement.updateFirstName(_firstName);};
                  if (_lastName != 'Empty') { UserManagement.updateLastName(_lastName);};

                 dialogTrigger(context);
                },
              )
            ],
          );
        });
  }

  Future<bool> addContact(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Basic info', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    this._email = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Phone Number'),
                  onChanged: (value) {
                    this._phoneNumber = value;
                  },
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Country'),
                  onChanged: (value) {
                    this._location = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  if(_email != 'empty'){UserManagement.updateEmail(_email);};
                  if(_phoneNumber != 'empty'){UserManagement.updatePhoneNumber(_phoneNumber);};
                  if(_location != 'empty'){UserManagement.updateLocation(_location);};
                  dialogTrigger(context);
                },
              )
            ],
          );
        });
  }

  Future<bool> addEducation(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Education info', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(hintText: 'School'),
                  onChanged: (value) {
                    this._school = value;
                  },
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Degree eg. Bachelors, Masters..'),
                  onChanged: (value) {
                    this._degree = value;
                  },
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Field of Study'),
                  onChanged: (value) {
                    this._fieldOfStudy = value;
                  },
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Skills'),
                  onChanged: (value) {
                    this._skills = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  if(_school != 'empty'){UserManagement.updateSchool(_school);};
                  if(_degree != 'empty'){UserManagement.updateDegree(_degree);};
                  if(_fieldOfStudy != 'empty'){UserManagement.updateFieldOfStudy(_fieldOfStudy);};
                  if(_skills != 'empty'){UserManagement.updateSkills(_skills);};
                  dialogTrigger(context);
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/editprofilepage');
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
      crudObj.getData().then((val) {
        FirebaseAuth.instance
            .currentUser().then((val) {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: val.uid)
              .getDocuments().then((results) {
            setState(() {
              info = results;
            });
          });
          super.initState();
        });
      });
  }


  @override
  Widget build(BuildContext context) {
    if (info != null) {
      return new Scaffold(
          backgroundColor: Colors.black12,
          body: ListView(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                    child: Card(
                        color: Colors.white,
                        child: new ListTile(
                          title: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Text("Basic Information",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                ),
                                Container(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: IconButton(
                                      icon: Icon(Icons.create, color: Colors
                                          .black),
                                      onPressed: () {
                                        addBasic(context);
                                      },
                                    )
                                )
                              ]
                          ),
                          subtitle: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('First Name:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['firstName']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Last Name:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['lastName']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            bottom: 75),
                                        child: Text('About:',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        width: 160,
                                        margin: const EdgeInsets.only(left: 15),
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2.0,
                                            color: Colors.black38,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                        ),
                                        child: Text(
                                          info.documents[0].data['about'],

                                        ),
                                      ),
                                    ]),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 20)),

                              ]
                          ),
                        )
                    )
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                        color: Colors.white,
                        child: new ListTile(
                          title: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Text("Contact Information",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                ),
                                Container(
                                    padding: const EdgeInsets.only(left: 65),
                                    child: IconButton(
                                      icon: Icon(Icons.create, color: Colors
                                          .black),
                                      onPressed: () {
                                        addContact(context);
                                      },
                                    )
                                )
                              ]
                          ),
                          subtitle: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Email:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 30),),
                                      Text(info.documents[0].data['email']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Number:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['phoneNumber']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Country:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['location']),
                                    ]),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 20)),

                              ]
                          ),
                        )
                    )
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                        color: Colors.white,
                        child: new ListTile(
                          title: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Text("Education Information",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                ),
                                Container(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: IconButton(
                                      icon: Icon(Icons.create, color: Colors
                                          .black),
                                      onPressed: () {
                                        addEducation(context);
                                      },
                                    )
                                )
                              ]
                          ),
                          subtitle: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('School:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 30),),
                                      Text(info.documents[0].data['school']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Degree:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['degree']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Field of Study:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['fieldOfStudy']),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(
                                          left: 10),),
                                      Text('Skills:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(
                                          left: 15),),
                                      Text(info.documents[0].data['skills']),
                                    ]),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 20)),

                              ]
                          ),
                        )
                    )
                ),
              ]
          )
      );
    } else
      return Text("Please be patient while loading");
  }
}