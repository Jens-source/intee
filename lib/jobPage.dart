import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:async';


import 'package:http/http.dart' as http;


class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => new _JobPageState();
}

class _JobPageState extends State<JobPage> {
  List data;
  String url = 'https://randomapi.com/api/r2vj950w?key=ZOWM-IU9X-1J7E-5F3F';

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});


    setState(() {
      var extractData = jsonDecode(response.body);
      data = extractData["results"];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Job List'),
        ),
        body: new ListView.builder(
            itemCount: data == null? 0: data.length,
            itemBuilder: (BuildContext context, i) {
              return new ListTile(
                title: new Text(data[i]["jobTitle"]),
                subtitle: new Text(data[i]["city"]),
                trailing: new Text(data[i]["formattedRelativeTime"]),
                leading: new CircleAvatar(
                  backgroundImage: new NetworkImage(data[i]["companyImageLogo"]),

                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SecondPage(data[i])));
                },
              );
            }
        )
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);

  final data;

  @override
  Widget build(BuildContext context) =>
      new Scaffold(
          appBar: new AppBar(title: new Text('More info')),
          body: new ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: 320.0,
                      height: 450.0,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: new NetworkImage(data["companyImage"]),
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter
                        ),
                      ),
                    ),
                    Positioned(
                        top: 100,
                        left: 60,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(data["jobTitle"],
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87
                                    ))
                              ],
                            )
                          ],
                        )
                    ),
                    Positioned(
                        top: 125,
                        left: 45,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(data["salary"],
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38
                                    ))
                              ],
                            )
                          ],
                        )
                    ),
                    Positioned(
                        top: 150,
                        left: 20,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('_____________________________________',
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38
                                    ))
                              ],
                            )
                          ],
                        )
                    ),
                    Positioned(
                        top: 180,
                        left: 20,
                        child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 110.0, top: 10.0, bottom: 10.0),
                                  width: 250,
                                  child: Text('About',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ))),


                              Container(
                                  width: 250,
                                  child: Text(data["snippet"],
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ))),
                              Container(
                                padding: EdgeInsets.only(left: 90.0, top: 10.0, bottom: 10.0),
                                  width: 250,
                                  child: Text('Requirements',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ))),
                              Container(
                                  width: 250,
                                  child: Text('Compunication skills in English.',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ))),
                              Container(
                                  width: 250,
                                  child: Text('Bachelors Degree',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ))),
                              Container(
                                  width: 250,
                                  child: Text('3 years experience',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ))),
                              Container(
                                  width: 250,
                                  child: Text('Profile with completed projects.',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ))),
                            ]


                        )
                    )
                  ],
                )
              ]
          )
      );
}
