import 'dart:convert';
import 'package:brigade/courses.dart';
import 'package:brigade/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class homepage extends StatefulWidget {
  //const homepage({super.key});
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  homepage({required this.analytics, required this.observer});
  @override
  State<homepage> createState() =>
      _homepageState(this.analytics, this.observer);
}

class _homepageState extends State<homepage> {
  late FirebaseAnalytics analytics;
  late FirebaseAnalyticsObserver observer;
  late Future myfuture;
  _homepageState(this.analytics, this.observer);
  List<Departments> departmentlist = [];
  Future<List<Departments>> getdepaetments() async {
    final response = await http
        .get(Uri.parse('https://kitsbrigade.herokuapp.com/api/departments/'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        Departments departments = Departments(name: i['name']);
        departmentlist.add(departments);
      }
      return departmentlist;
    } else {
      return departmentlist;
    }
  }

  Future<Null> _sendanlytics() async {
    await widget.analytics
        .logEvent(name: 'Departments-brigade', parameters: <String, dynamic>{});
  }

  @override
  void initState() {
    myfuture = getdepaetments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/brigade.png')),
              // SizedBox(width: MediaQuery.of(context).size.width*0.2,),
              // Icon(Icons.info)
            ],
          ),
          SizedBox(height: 300, child: Lottie.asset('assets/book.json')),
          Expanded(
            child: FutureBuilder(
                future: myfuture,
                builder: (context, snapshot) {
                  // if (status != '') {
                  //   return Container(
                  //     child: Center(
                  //       child: Text('no internet connection'),
                  //     ),
                  //   );
                  // } else
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: departmentlist.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // FirebaseAnalytics.instance
                              //     .logEvent(name: 'deapartments');
                              // print(departmentlist[index].name.toString());
                              _sendanlytics();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => courses(
                                          value: departmentlist[index]
                                              .name
                                              .toString(),
                                          analytics: analytics,
                                          observer: observer,
                                        ),
                                    settings: RouteSettings(
                                        name: 'departments-brigade')),
                              );
                            },
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Container(
                                  height: 65,
                                  width: 352,
                                  decoration: BoxDecoration(
                                      // color: Color.fromARGB(255, 240, 245, 255),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 194, 204, 235),
                                          offset: Offset(10, 10),
                                          blurRadius: 20,
                                        ),
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 234, 239, 255),
                                          offset: Offset(-10, -10),
                                          blurRadius: 16,
                                        ),
                                      ]),
                                  child: Center(
                                      child: Text(
                                    departmentlist[index].name.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}

class Departments {
  String name;
  Departments({required this.name});
}
