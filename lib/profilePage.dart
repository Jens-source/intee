import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  var profilePicUrl =  'https://www.cmcaindia.org/wp-content/uploads/2015/11/default-profile-picture-gmail-2.png';
  String userName = '';
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        profilePicUrl = user.photoUrl;
        userName = user.displayName;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text('Profile Page'),
          centerTitle: true,
          leading: new IconButton(icon: Icon(Icons.arrow_back),color: Colors.white, onPressed: (){
            Navigator.of(context).pushReplacementNamed('/timelinepage');
          }),
        ),
        body: new Stack(
          children: <Widget>[

            ClipPath(
              child: Container(color: Colors.black.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
                width: 350,
                top: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(
                                    profilePicUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 15.0),
                    Text(
                      userName,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Container(
                            height: 30.0,
                            width: 250.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(3.0),
                              shadowColor: Colors.white,
                              color: Colors.white,
                              elevation: 4.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed('/editprofilepage');
                                },
                                child: Center(
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ))
          ],
        ));
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
    // TODO: implement shouldReclip
    return true;
  }
}

