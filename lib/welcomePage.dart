
import 'package:flutter/material.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
          image: AssetImage('lib/assets/welcomeBack.jpg'),
                fit: BoxFit.cover
      )
            ),
          ),


          Container(
            padding: EdgeInsets.fromLTRB(100.0, 30.0, 0.0, 0.0),
            child: Text('Hello',
                style: TextStyle(
                    fontSize: 80.0, fontWeight: FontWeight.bold,
                    color: Colors.white54)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(90, 105.0, 0.0, 0.0),
            child: Text('There',
                style: TextStyle(
                    fontSize: 80.0, fontWeight: FontWeight.bold,
                    color: Colors.white54)),
          ),
          Positioned(
            top: 340,
            left: 150,
            child: Container(
              width: 60,
              height: 60,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey,
              ),
              child: new Icon(Icons.weekend, size: 40, color: Colors.white,),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(90.0, 420.0, 0.0, 0.0),
            child: Text('Welcome to Intee',
                style: TextStyle(
                    fontFamily: 'RobotoMono',
                    color: Colors.white70,
                    fontSize: 25.0, fontWeight: FontWeight.bold)),
          ),

          Positioned(
            top: 470,
            left: 55,
            child: Container(
                width: 270,
                height: 40,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color.fromRGBO(166, 133, 119, 1)
                ),
                child: OutlineButton(
                    child: Center(
                        child: Text('Signup with Email',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        )
                        )
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signup');
                    }
                )
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(55, 530.0, 0.0, 0.0),
            child: Text('________',
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold,
                    color: Colors.white54)),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(135, 540.0, 0.0, 0.0),
            child: Text('or continue with',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white54)),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(250, 530.0, 0.0, 0.0),
            child: Text('________',
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold,
                    color: Colors.white54)),
          ),

          Positioned(
            top: 570,
            left: 80,
            child: Container(
                width: 100,
                height: 30,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.white,
                ),
                child: Container(
                  child: new Image.asset('lib/assets/googleIcon.png',),
                )
            ),
          ),

          Positioned(
            top: 570,
            left: 190,
            child: Container(
                width: 100,
                height: 30,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.white,
                ),
                child: Container(
                  child: new Image.asset('lib/assets/facebookIcon.png',),
                )
            ),
          ),

          Positioned(
              top: 620,
              child: Container(
                  width: 450,
                  height: 45,
                  decoration: new BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: OutlineButton(
                      child: Center(
                          child: Text('Have an account? Log In')
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/loginpage');
                      }
                  )
              )
          ),
        ],
      ),
    );
  }
}
