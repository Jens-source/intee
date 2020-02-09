

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class TimelinePage extends StatefulWidget {



  @override

  _TimelinePageState createState() => new _TimelinePageState();

}

class _TimelinePageState extends State<TimelinePage> {

  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;



  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,

        body: Stack(
            children: <Widget>[
              UnityWidget(
                onUnityViewCreated: onUnityCreated,
                isARScene: false,
                onUnityMessage: onUnityMessage,
              ),
            ],
          ),
        )
    );
  }




  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }
}
