import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tms/colors.dart';

import 'package:tms/components/tableText.dart';

class ClassRoutine extends StatefulWidget {
  @override
  _ClassRoutineState createState() => _ClassRoutineState();
}

class _ClassRoutineState extends State<ClassRoutine> {
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  QuerySnapshot querySnapshot;

  Map<String, String> userdata = Map();

  users(context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Mytext1(
              text: 'Teacher Info',
            ),
          ),
          content: Container(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usersData')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Mytext1(
                        text: 'No data available!',
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Mytext1(
                        text: 'Something error!',
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        Map<String, dynamic> data =
                            documentSnapshot.data() as Map<String, dynamic>;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.15,
                                  child: Mytext1(
                                    text:
                                        data['name'].toString().substring(0, 3),
                                    color: kPrimaryColor4,
                                    fontsize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Mytext1(
                                  text: ":",
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Mytext1(
                                  text: data['name'].toString().toUpperCase(),
                                  fontsize: 20,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Mytext1(
                      text: 'Ok',
                      color: Colors.white,
                    )),
              ),
            )
          ],
        );
      },
    );
  }

  Map<String, String> saturday1 = Map();
  Map<String, String> saturday2 = Map();
  Map<String, String> saturday3 = Map();
  Map<String, String> saturday4 = Map();
  Map<String, String> saturday5 = Map();
  Map<String, String> saturday6 = Map();
  Map<String, String> saturday7 = Map();
  Map<String, String> saturday8 = Map();

  Map<String, String> sunday1 = Map();
  Map<String, String> sunday2 = Map();
  Map<String, String> sunday3 = Map();
  Map<String, String> sunday4 = Map();
  Map<String, String> sunday5 = Map();
  Map<String, String> sunday6 = Map();
  Map<String, String> sunday7 = Map();
  Map<String, String> sunday8 = Map();

  Future saturdayData() async {
    CollectionReference sat1 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('1st');
    sat1.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday1['day'] = data['day'] ?? 'No data';
            saturday1['subject'] = data['subject'] ?? 'No data';
            saturday1['name'] = data['teachername'].toString().substring(0, 3);
            saturday1['period'] = data['period'] ?? 'No data';
          });
          print(saturday1.values);
        }
      });
    });
    CollectionReference sat2 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('2nd');
    sat2.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday2['day'] = data['day'] ?? 'No data';
            saturday2['subject'] = data['subject'] ?? 'No data';
            saturday2['name'] = data['teachername'].toString().substring(0, 3);
            saturday2['period'] = data['period'] ?? 'No data';
          });
        }
      });
    });
    CollectionReference sat3 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('3rd');
    sat3.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday3['day'] = data['day'] ?? 'No data';
            saturday3['subject'] = data['subject'] ?? 'No data';
            saturday3['name'] = data['teachername'].toString().substring(0, 3);
            saturday3['period'] = data['period'] ?? 'No data';
          });
        }
      });
    });
    CollectionReference sat4 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('4th');
    sat4.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday4['day'] = data['day'] ?? 'No data';
            saturday4['subject'] = data['subject'] ?? 'No data';
            saturday4['name'] = data['teachername'].toString().substring(0, 3);
            saturday4['period'] = data['period'] ?? 'No data';
          });
        }
      });
    });
    CollectionReference sat5 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('5th');
    sat5.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday5['day'] = data['day'] ?? 'No data';
            saturday5['subject'] = data['subject'] ?? 'No data';
            saturday5['name'] = data['teachername'].toString().substring(0, 3);
            saturday5['period'] = data['period'] ?? 'No data';
          });
        }
      });
    });
    CollectionReference sat6 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('6th');
    sat6.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday6['day'] = data['day'] ?? 'No data';
            saturday6['subject'] = data['subject'] ?? 'No data';
            saturday6['name'] = data['teachername'].toString().substring(0, 3);
            saturday6['period'] = data['period'] ?? 'No data';
          });
        }
      });
    });
    CollectionReference sat7 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('7th');
    sat7.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday7['day'] = data['day'] ?? 'No data';
            saturday7['subject'] = data['subject'] ?? 'No data';
            saturday7['name'] = data['teachername'].toString().substring(0, 3);
            saturday7['period'] = data['period'] ?? 'No data';
          });
        }
      });
    });
    CollectionReference sat8 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Saturday')
        .collection('8th');
    sat8.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            saturday8['day'] = data['day'] ?? 'No data';
            saturday8['subject'] = data['subject'] ?? 'No data';
            saturday8['name'] = data['teachername'].toString().substring(0, 3);
            saturday8['period'] = data['period'] ?? 'No data';
          });
          print(saturday4.values);
        }
      });
    });
  }

  sundaydata() {
    CollectionReference san1 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('1st');
    san1.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday1['day'] = data['day'];
            sunday1['subject'] = data['subject'];
            sunday1['name'] = data['teachername'].toString().substring(0, 3);
            sunday1['period'] = data['period'];
          });
          print(sunday1.values);
        }
      });
    });
    CollectionReference san2 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('2nd');
    san2.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
           Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday2['day'] = data['day'];
            sunday2['subject'] = data['subject'];
            sunday2['name'] =data['teachername'].toString().substring(0, 3);
            sunday2['period'] = data['period'];
          });
        }
      });
    });
    CollectionReference san3 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('3rd');
    san3.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
           Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday3['day'] = data['day'];
            sunday3['subject'] = data['subject'];
            sunday3['name'] =
                data['teachername'].toString().substring(0, 3);
            sunday3['period'] = data['period'];
          });
        }
      });
    });
    CollectionReference san4 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('4th');
    san4.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
           Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday4['day'] = data['day'];
            sunday4['subject'] = data['subject'];
            sunday4['name'] =
                data['teachername'].toString().substring(0, 3);
            sunday4['period'] = data['period'];
          });
        }
      });
    });
    CollectionReference san5 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('5th');
    san5.get().then((value) {
      value.docs.forEach((element) {
         Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        if (element.exists) {
          setState(() {
            sunday5['day'] = data['day'];
            sunday5['subject'] = data['subject'];
            sunday5['name'] =
                data['teachername'].toString().substring(0, 3);
            sunday5['period'] = data['period'];
          });
        }
      });
    });
    CollectionReference san6 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('6th');
    san6.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
           Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday6['day'] = data['day'];
            sunday6['subject'] = data['subject'];
            sunday6['name'] =
                data['teachername'].toString().substring(0, 3);
            sunday6['period'] = data['period'];
          });
        }
      });
    });
    CollectionReference san7 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('7th');
    san7.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
           Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday7['day'] = data['day'];
            sunday7['subject'] = data['subject'];
            sunday7['name'] =
                data['teachername'].toString().substring(0, 3);
            sunday7['period'] = data['period'];
          });
        }
      });
    });
    CollectionReference san8 = FirebaseFirestore.instance
        .collection('classroutine')
        .doc('Sunday')
        .collection('8th');
    san8.get().then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
           Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          setState(() {
            sunday8['day'] = data['day'];
            sunday8['subject'] = data['subject'];
            sunday8['name'] =
                data['teachername'].toString().substring(0, 3);
            sunday8['period'] = data['period'];
          });
        }
      });
    });
  }

  @override
  void initState() {
    saturdayData();
    sundaydata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor4,
        title: Mytext1(
          text: 'Class Routine',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                users(context);
              })
        ],
      ),
      body: sunday1['day'] == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  dataRowHeight: MediaQuery.of(context).size.height * 0.1,
                  columns: [
                    DataColumn(
                        label: Mytext1(
                      text: 'Days',
                      color: Colors.green,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '1st',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '2nd',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '3rd',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '4th',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '5th',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '6th',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '7th',
                      color: Colors.red,
                    )),
                    DataColumn(
                        label: Mytext1(
                      text: '8th',
                      color: Colors.red,
                    )),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Mytext1(
                        text: saturday1['day'],
                      )),
                      DataCell(Mytext1(
                        text: '${saturday1['subject']}\n${saturday1['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday2['subject']}\n${saturday2['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday3['subject']}\n${saturday3['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday4['subject']}\n${saturday4['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday5['subject']}\n${saturday5['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday6['subject']}\n${saturday6['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday7['subject']}\n${saturday7['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${saturday8['subject']}\n${saturday8['name']}',
                      )),
                    ]),
                    //sunday
                    DataRow(cells: [
                      DataCell(Mytext1(
                        text: sunday1['day'],
                      )),
                      DataCell(Mytext1(
                        text: '${sunday1['subject']}\n${sunday1['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday2['subject']}\n${sunday2['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday3['subject']}\n${sunday3['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday4['subject']}\n${sunday4['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday5['subject']}\n${sunday5['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday6['subject']}\n${sunday6['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday7['subject']}\n${sunday7['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday8['subject']}\n${sunday8['name']}',
                      )),
                    ]),
                    //monday
                    DataRow(cells: [
                      DataCell(Mytext1(
                        text: sunday1['day'],
                      )),
                      DataCell(Mytext1(
                        text: '${sunday1['subject']}\n${sunday1['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday2['subject']}\n${sunday2['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday3['subject']}\n${sunday3['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday4['subject']}\n${sunday4['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday5['subject']}\n${sunday5['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday6['subject']}\n${sunday6['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday7['subject']}\n${sunday7['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday8['subject']}\n${sunday8['name']}',
                      )),
                    ]),
                    //tuesday
                    DataRow(cells: [
                      DataCell(Mytext1(
                        text: sunday1['day'],
                      )),
                      DataCell(Mytext1(
                        text: '${sunday1['subject']}\n${sunday1['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday2['subject']}\n${sunday2['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday3['subject']}\n${sunday3['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday4['subject']}\n${sunday4['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday5['subject']}\n${sunday5['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday6['subject']}\n${sunday6['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday7['subject']}\n${sunday7['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday8['subject']}\n${sunday8['name']}',
                      )),
                    ]),
                    //wednesday
                    DataRow(cells: [
                      DataCell(Mytext1(
                        text: sunday1['day'],
                      )),
                      DataCell(Mytext1(
                        text: '${sunday1['subject']}\n${sunday1['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday2['subject']}\n${sunday2['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday3['subject']}\n${sunday3['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday4['subject']}\n${sunday4['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday5['subject']}\n${sunday5['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday6['subject']}\n${sunday6['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday7['subject']}\n${sunday7['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday8['subject']}\n${sunday8['name']}',
                      )),
                    ]),
                    //thursday
                    DataRow(cells: [
                      DataCell(Mytext1(
                        text: sunday1['day'],
                      )),
                      DataCell(Mytext1(
                        text: '${sunday1['subject']}\n${sunday1['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday2['subject']}\n${sunday2['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday3['subject']}\n${sunday3['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday4['subject']}\n${sunday4['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday5['subject']}\n${sunday5['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday6['subject']}\n${sunday6['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday7['subject']}\n${sunday7['name']}',
                      )),
                      DataCell(Mytext1(
                        text: '${sunday8['subject']}\n${sunday8['name']}',
                      )),
                    ]),
                  ]),
            ),
    );
  }
}
