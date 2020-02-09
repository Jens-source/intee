import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app43221/designPage.dart';
import 'package:flutter_app43221/timelinePage.dart';
import 'chatHome.dart';
import 'editProfilePage.dart';
import 'feedPage.dart';
import 'library.dart';
import 'welcomePage.dart';
import 'addFriendPage.dart';
import 'profilePage.dart';
import 'loginPage.dart';
import 'signupPage.dart';
import 'homePage.dart';
import 'library.dart';
import 'selectprofilepic.dart';


void main() {

    runApp(new MyApp()
    );
}

class MyApp extends StatelessWidget {
  get picUrl => null;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: TimelinePage(),
      routes: <String, WidgetBuilder> {
        '/landingpage': (BuildContext context)=> new MyApp(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/timelinepage': (BuildContext context) => new MyHomePage(),
        '/homepage': (BuildContext context) => new MyHomePage(),
        '/selectpic': (BuildContext context) => new SelectprofilepicPage(),
        '/librarypage': (BuildContext context) => new LibraryPage(),
        '/profilepage': (BuildContext context) => new ProfilePage(),
        '/editprofilepage': (BuildContext context) => new EditProfilePage(),
        '/feedpage': (BuildContext context) => new FeedPage(),
        '/loginpage': (BuildContext context) => new LoginPage(),
        '/addfriendpage': (BuildContext context) => new AddFriendPage(),
        '/chathomepage': (BuildContext context) => new ChatHome(),
        '/welcomepage': (BuildContext context) => new WelcomePage(),
        '/uploadpostpage': (BuildContext context) => new UploadPost(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}
