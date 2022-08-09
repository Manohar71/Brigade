import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class units extends StatefulWidget {
  String values;
  units({required this.values});

  @override
  State<units> createState() => _unitsState(values);
}

class _unitsState extends State<units> {
  late Future myfuture;
  String values;
  _unitsState(this.values);
  List<Units> unitlist = [];
  Future<List<Units>> getunit() async {
    final response = await http.get(
        Uri.parse('https://kitsbrigade.herokuapp.com/api/courses/$values/'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        Units adding = Units(name: i['name'], file_url: i['file_url']);
        unitlist.add(adding);
      }
      return unitlist;
    } else {
      return unitlist;
    }
  }
  @override
  void initState() {
    myfuture = getunit();
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
                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,20,0,0),
            child: Container(
              height: MediaQuery.of(context).size.height*0.06,
              width: MediaQuery.of(context).size.width*0.85,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Center(
                child: Text(values , textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Poppins" ,fontWeight: FontWeight.w400 , color: Colors.white ),
                ),
              ),
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
                        itemCount: unitlist.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // FirebaseAnalytics.instance
                              //     .logEvent(name: 'units');
                              // print(departmentlist[index].name.toString());
                              //print(unitlist[index].file_url);
                              final url = unitlist[index].file_url.toString();
                              // ignore: deprecated_member_use
                              if (await canLaunch(url)) {
                                // ignore: deprecated_member_use
                                await launch(url , forceWebView: true , enableJavaScript: true);
                              }else{
                                throw "coudn't launch url";
                              }
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                    unitlist[index].name.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600),
                                  ),
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

class Units {
  String name, file_url;
  Units({required this.name, required this.file_url});
}
