import 'package:brigade/Units.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class courses extends StatefulWidget {
// courses({super.key});
  String value;
  courses({required this.value , required this.analytics, required this.observer});
   final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  State<courses> createState() => _coursesState(value);
}

class _coursesState extends State<courses> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);
  String value;
  late Future myfuture;
  _coursesState(this.value);
  List<Courses> coursetlist = [];
  Future<List<Courses>> getdepaetments() async {
    final response = await http.get(
        Uri.parse('https://kitsbrigade.herokuapp.com/api/departments/$value/'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        Courses departments = Courses(name: i['name']);
        coursetlist.add(departments);
      }
      return coursetlist;
    } else {
      return coursetlist;
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
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios)),
                    SizedBox(width: MediaQuery.of(context).size.width*0.2,),
                Center(child: Image.asset('assets/brigade.png')),
                // SizedBox(width: MediaQuery.of(context).size.width*0.2,),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: myfuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                        child: new CircularProgressIndicator(),
                      ),
                    );
                    ;
                  } else {
                    return ListView.builder(
                        itemCount: coursetlist.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              FirebaseAnalytics.instance
                                  .logEvent(name: 'courses');
                              // print(departmentlist[index].name.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => units(
                                          values: coursetlist[index]
                                              .name
                                              .toString()
                                              )
                                              
                                              ),
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
                                    coursetlist[index].name.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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

class Courses {
  String name;
  Courses({required this.name});
}
