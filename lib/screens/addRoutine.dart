import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/firestore/addRoutineData.dart';
import 'package:tms/provider/userDetails.dart';

class AddRoutine extends StatefulWidget {
  @override
  _AddRoutineState createState() => _AddRoutineState();
}

class _AddRoutineState extends State<AddRoutine> {
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void loadSnackBAr(BuildContext context, String a) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      duration: Duration(seconds: 2),
      backgroundColor: kPrimaryColor3,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(a,
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none),
              )),
        ],
      ),
    ));
  }

  @override
  void initState() {
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
          title: Mytext(
            text: 'Assign a Teacher',
          )),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('usersData').snapshots(),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: snapshot.data.docs.map((
                  DocumentSnapshot documentSnapshot,
                ) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          // if (userDetails.userEmail ==
                          //     documentSnapshot.data()['email']) {
                          //   loadSnackBAr(
                          //       context, 'You can not assign yourself');
                          // }
                          //   print(documentSnapshot.data()['fcmToken']);
                          // else {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) {
                          //         return AssiedTeacherDetailsPage(
                          //           userDetailsData: documentSnapshot,
                          //         );
                          //       },
                          //     ),
                          //   );
                          // }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AssiedTeacherDetailsPage(
                                  userDetailsData: documentSnapshot,
                                );
                              },
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Mytext(
                              text: data['name'].toString().toUpperCase(),
                              fontsize: 20,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor4,
                            ),
                            leading: CircleAvatar(
                                backgroundColor: kPrimaryColor2,
                                child: Text(data['name']
                                    .toString()
                                    .toUpperCase()
                                    .substring(0, 1))),
                            subtitle: Mytext(
                              text: data['subject'],
                              fontsize: 20,
                              color: kPrimaryColor2,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                          ),
                        ),
                      ));
                }).toList(),
              );
            }
          }),
    );
  }
}

class AssiedTeacherDetailsPage extends StatefulWidget {
  final DocumentSnapshot userDetailsData;
  AssiedTeacherDetailsPage({this.userDetailsData});
  @override
  _AssiedTeacherDetailsPageState createState() =>
      _AssiedTeacherDetailsPageState();
}

class _AssiedTeacherDetailsPageState extends State<AssiedTeacherDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final addnote = TextEditingController();
  final subjectName = TextEditingController();
  final roomNumber = TextEditingController();
  Map<String, dynamic> data;
  var toDate;
  var time;
  DateTime dateTimeTo = DateTime.now();
  bool dropVal = false;
  bool dayss = false;
  bool periods = false;

  String ddValue;
  String periodval;
  String daysval;
  List durationTypes = [
    '30 minutes',
    '35 minutes',
    '40 minutes',
    '45 minutes',
    '60 minutes'
  ];
  List days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday'
  ];
  List period = ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th'];

  var random;
  String submit;
  String update;

  void loadSnackBAr(BuildContext context, String a) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      duration: Duration(seconds: 2),
      backgroundColor: kPrimaryColor3,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(a,
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none),
              )),
        ],
      ),
    ));
  }

  validCheck(context, periodval, daysval, sbjnm, n, btn) {
    if (subjectName.text.isEmpty) {
      loadSnackBAr(context, 'Please Select Subject name');
    } else if (periods == false) {
      loadSnackBAr(context, 'Please Select Period Time');
    } else if (dayss == false) {
      loadSnackBAr(context, 'Please Select The Day');
    } else {
      Dialogs().waiting(context, 'Please wait...');
      RoutineDataAdding()
          .storeRoutineData(context, daysval, periodval, n, sbjnm);
    }
  }

  updatedata(context, periodval, daysval, sbjnm, n, btn) {
    if (subjectName.text.isEmpty) {
      loadSnackBAr(context, 'Please Select Subject name');
    } else if (periods == false) {
      loadSnackBAr(context, 'Please Select Period Time');
    } else if (dayss == false) {
      loadSnackBAr(context, 'Please Select The Day');
    } else {
      Dialogs().waiting(context, 'Updating...');
      FirebaseFirestore.instance
          .collection('classroutine')
          .doc(daysval)
          .collection(periodval)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('classroutine')
              .doc(daysval)
              .collection(periodval)
              .doc(element.id)
              .update({
            'teachername': n,
            'day': daysval,
            'period': periodval,
            'subject': sbjnm,
            'created': FieldValue.serverTimestamp()
          }).whenComplete(() {
            print('up');
            Navigator.pop(context);
          });
        });
      });
    }
  }

  void randomnumber() {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    random = Random();
    var n1 = random.nextInt(16);
    var n2 = random.nextInt(15);
    var n3;
    if (n2 >= n1) {
      n2 += 1;
      n3 = n1 + n2;

      setState(() {
        userDetails.dataRandomN1(n3);
        print(userDetails.randomN1.toString());
      });
    }
  }

  @override
  void initState() {
    randomnumber();
    setState(() {
      data = widget.userDetailsData.data();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor4,
        title: Mytext(
          text: 'Add Routine',
        ),
      ),
      body: SafeArea(
        child: Container(
            height: size.height * 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Mytext(
                      text: 'Teacher Name :',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    Container(
                      width: size.width * 1,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                          color: kPrimaryColor4.withOpacity(0.1),
                          border: Border.all(width: 1, color: kPrimaryColor2),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Mytext(
                              text: '\t' +
                                  data['name']
                                      .toString()
                                      .toUpperCase(),
                              fontsize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Mytext(
                              text: 'Subject Name :',
                              fontsize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                              width: size.width * 0.45,
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                  //color: kPrimaryColor4.withOpacity(0.1),
                                  border: Border.all(
                                      width: 1, color: kPrimaryColor4),
                                  borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: subjectName,
                                      decoration: InputDecoration(
                                        hintText: 'Enter here',
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: kPrimaryColor4)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Mytext(
                              text: 'Select the Day :',
                              fontsize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                                width: size.width * 0.45,
                                height: size.height * 0.07,
                                decoration: BoxDecoration(
                                    //color: kPrimaryColor1,
                                    border: Border.all(
                                        width: 1, color: kPrimaryColor4),
                                    borderRadius: BorderRadius.circular(5)),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: DropdownButton(
                                    hint: Mytext(
                                      text: '\tSelect the Day',
                                    ),
                                    underline: SizedBox(),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 35,
                                    iconEnabledColor: Colors.green,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    value: daysval,
                                    onChanged: (value) {
                                      setState(() {
                                        daysval = value;
                                        dayss = true;
                                        print(daysval);
                                      });
                                    },
                                    items: days.map((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Mytext(
                                            text: '\t' + value,
                                            fontsize: 18,
                                            color: Colors.black,
                                          ));
                                    }).toList(),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Mytext(
                              text: 'Select Period :',
                              fontsize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                                width: size.width * 0.45,
                                height: size.height * 0.07,
                                decoration: BoxDecoration(
                                    //color: kPrimaryColor1,
                                    border: Border.all(
                                        width: 1, color: kPrimaryColor4),
                                    borderRadius: BorderRadius.circular(5)),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: DropdownButton(
                                    hint: Mytext(
                                      text: '\tSelect Period',
                                    ),
                                    underline: SizedBox(),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 35,
                                    iconEnabledColor: Colors.green,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    value: periodval,
                                    onChanged: (value) {
                                      setState(() {
                                        periodval = value;
                                        periods = true;
                                        print(periodval);
                                      });
                                    },
                                    items: period.map((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Mytext(
                                            text: '\t' + value,
                                            fontsize: 18,
                                            color: Colors.black,
                                          ));
                                    }).toList(),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Center(
                      child: RoundedButton(
                        text: "SUBMIT",
                        color: kPrimaryColor3,
                        press: () {
                          print("ok");
                          setState(() {
                            final sbjnm = subjectName.text.trim();
                            final n = data['name'];
                            final btn = submit;

                            FocusScope.of(context).unfocus();
                            validCheck(
                                context, periodval, daysval, sbjnm, n, btn);
                          });
                        },
                      ),
                    ),
                    Center(
                      child: RoundedButton(
                        text: "UPDATE",
                        color: kPrimaryColor4,
                        press: () {
                          setState(() {
                            final sbjnm = subjectName.text.trim();
                            final n = data['name'];
                            final btn = update;

                            FocusScope.of(context).unfocus();

                            updatedata(
                                context, periodval, daysval, sbjnm, n, btn);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
