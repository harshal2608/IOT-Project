import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final referenceDatabase = FirebaseDatabase.instance;

  late int level1;
  late int level2;
  late int level3;
  late int level4;
  late int relay;
  Future getData() async {
    while (true) {
      final readref = referenceDatabase.reference();

      await readref.child('l1').once().then((DataSnapshot snapshot) {
        level1 = snapshot.value;

        print(level1);
      });
      await readref.child('l2').once().then((DataSnapshot snapshot) {
        level2 = snapshot.value;

        print(level2);
      });
      await readref.child('l3').once().then((DataSnapshot snapshot) {
        level3 = snapshot.value;

        print(level3);
      });
      await readref.child('l4').once().then((DataSnapshot snapshot) {
        level4 = snapshot.value;

        print(level4);
      });
      await readref.child('relay').once().then((DataSnapshot snapshot) {
        relay = snapshot.value;

        print(relay);
      });
      readref.keepSynced(true);

      return [level1, level2, level3, level4, relay];
    }
  }

  Future loop() async {
    while (true) {
      await getData();
      setState(() {});
      await Future.delayed(Duration(seconds: 3));
    }
  }

  @override
  void initState() {
    super.initState();
    // while (true) {
    // Future.delayed(Duration(seconds: 5));
    loop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
        appBar: AppBar(
          title: Text('IOT PROJECT'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh_outlined),
          onPressed: () {
            setState(() {
              getData();
            });
          },
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (ctx, snapshot) {
            print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '100%',
                              style: TextStyle(fontSize: 25),
                            ),
                            height: 75,
                            width: 150,
                            color: level4 == 1 ? Colors.blue : Colors.white70,
                          ),
                          Container(
                            alignment: Alignment.center,
                            // padding: EdgeInsets.all(10),
                            child: Text(
                              '75%',
                              style: TextStyle(fontSize: 25),
                            ),
                            height: 75,
                            width: 150,
                            color: level3 == 1 || level4 == 1
                                ? Colors.blue
                                : Colors.white70,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '50%',
                              style: TextStyle(fontSize: 25),
                            ),
                            height: 75,
                            width: 150,
                            color: level2 == 1 || level3 == 1 || level4 == 1
                                ? Colors.blue
                                : Colors.white70,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '25%',
                              style: TextStyle(fontSize: 25),
                            ),
                            height: 75,
                            width: 150,
                            color: level1 == 1 ||
                                    level2 == 1 ||
                                    level3 == 1 ||
                                    level4 == 1
                                ? Colors.blue
                                : Colors.white70,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            print('tap');

                            if (relay == 0) {
                              relay = 1;
                            }
                            // else {
                            //   relay = 0;
                            // }

                            ref.update({'relay': relay});
                          });
                        },
                        child: Icon(
                          relay == 0
                              ? Icons.usb_off_outlined
                              : Icons.not_started,
                          size: 100,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        relay == 1 ? 'ON' : 'OFF',
                        style: TextStyle(fontSize: 80),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('${snapshot.error} occured'),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
