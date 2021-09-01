import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/firestore/atRequestTo.dart';
import 'package:tms/firestore/atRequstBy.dart';
import 'package:tms/oneSignalNotificationSend.dart';
import 'package:tms/provider/userDetails.dart';

class AssiedTeacher extends StatefulWidget {
  @override
  _AssiedTeacherState createState() => _AssiedTeacherState();
}

class _AssiedTeacherState extends State<AssiedTeacher> {
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
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
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
                          if (userDetails.userEmail == data['email']) {
                            loadSnackBAr(
                                context, 'You can not assign yourself');
                          }
                          //   print(documentSnapshot.data()['fcmToken']);
                          else {
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
                          }
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
  var toDate;
  var time;
  DateTime dateTimeTo = DateTime.now();
  bool dropVal = false;

  String ddValue;
  List durationTypes = [
    '30 minutes',
    '35 minutes',
    '40 minutes',
    '45 minutes',
    '60 minutes'
  ];

  TimeOfDay timeOfDay = TimeOfDay.now();
  TimeOfDay pickedTime;
  bool datepck = false;
  bool timepick = false;
  var random;
  Map<String, dynamic> data;

  Future selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTimeTo,
      firstDate: DateTime(1950),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      setState(() {
        dateTimeTo = picked;
        toDate = "${dateTimeTo.year}-${dateTimeTo.month}-${dateTimeTo.day}";
        print(toDate);
      });
    }
  }

  Future selectTime(BuildContext context) async {
    print(time);
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (timeOfDay != null) {
      setState(() {
        pickedTime = timeOfDay;
        timepick = true;
        time = '${pickedTime.hour} : ${pickedTime.minute}';
        datepck = true;
        FocusScope.of(context).unfocus();
        print(pickedTime.hour);
        if (pickedTime.hour > 12) {
          var h = pickedTime.hour - 12;

          setState(() {
            String n = h.toString();
            String c = pickedTime.minute.toString();
            time = n + " : " + c + " " + 'pm';
            print(time);
          });
        } else if (pickedTime.hour == 0) {
          var h = pickedTime.hour + 12;
          setState(() {
            String n = h.toString();
            String c = pickedTime.minute.toString();
            time = n + " : " + c + " " + 'pm';
            print(time);
          });
        } else if (pickedTime.hour == 12) {
          var h = pickedTime.hour;
          setState(() {
            String n = h.toString();
            String c = pickedTime.minute.toString();
            time = n + " : " + c + " " + 'pm';
            print(time);
          });
        } else {
          setState(() {
            String n = pickedTime.hour.toString();
            String c = pickedTime.minute.toString();
            time = n + " : " + c + " " + 'am';
            print(time);
          });
        }
      });
    }
  }

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

  validCheck(context, subjectname, roomnumber, classtime, classdate, duration,
      additionalnote, assTchrUid, assTchrName, token, list) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    if (subjectName.text.isEmpty) {
      loadSnackBAr(context, 'Please Select Subject name');
    } else if (roomNumber.text.isEmpty) {
      loadSnackBAr(context, 'Please Select Room Number');
    } else if (datepck == false) {
      loadSnackBAr(context, 'Please Select Class Time');
    } else if (toDate == null) {
      loadSnackBAr(context, 'Please Select The Date');
    } else if (dropVal == false) {
      loadSnackBAr(context, 'Please Select Class Duration');
    } else {
      RequestedByDataAdding().storeRequestedbyUSerData(
        context,
        subjectname,
        roomnumber,
        classtime,
        classdate,
        duration,
        additionalnote,
        assTchrUid,
        assTchrName,
      );
      RequestedTODataAdding().storeRequestedToUSerData(
          context,
          subjectname,
          roomnumber,
          classtime,
          classdate,
          duration,
          additionalnote,
          assTchrUid,
          assTchrName);
      RequestedTODataAdding().notificationData(token);
      OSFunction.sendNotification(
          list,
          'Subject: $subjectname\nDate: $classdate',
          '${userDetails.userName} assined you');
      Dialogs().waiting(context, 'Please wait...');
    }
  }

  // void randomnumber() {
  //   final UserDetails userDetails =
  //       Provider.of<UserDetails>(context, listen: false);
  //   random = Random();
  //   var n1 = random.nextInt(16);
  //   var n2 = random.nextInt(15);
  //   var n3;
  //   if (n2 >= n1) {
  //     n2 += 1;
  //     n3 = n1 + n2;

  //     setState(() {
  //       userDetails.dataRandomN1(n3);
  //       print(userDetails.randomN1.toString());
  //     });
  //   }
  // }

  @override
  void initState() {
    pickedTime = TimeOfDay.now();
    //randomnumber();
    setState(() {
      data = widget.userDetailsData.data();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor4,
        title: Mytext(
          text: 'Assing a Teacher',
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
                      text: 'Assigned Teacher Name :',
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
                              text:
                                  '\t' + data['name'].toString().toUpperCase(),
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
                              text: 'Room Number :',
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
                                      controller: roomNumber,
                                      keyboardType: TextInputType.phone,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Mytext(
                              text: 'Class Time :',
                              fontsize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            GestureDetector(
                              onTap: () {
                                selectTime(context);
                              },
                              child: Container(
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
                                      child: Mytext(
                                        text: '\t' +
                                            '${pickedTime.format(context)}',
                                        fontsize: 20,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: kPrimaryColor4,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Mytext(
                              text: 'Select Date :',
                              fontsize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            GestureDetector(
                              onTap: () {
                                selectToDate(context);
                              },
                              child: Container(
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
                                      child: Mytext(
                                        text: '\t' +
                                            "${dateTimeTo.year}-${dateTimeTo.month}-${dateTimeTo.day}",
                                        fontsize: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: kPrimaryColor4,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Mytext(
                      text: 'Duration :',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    Container(
                        width: size.width * 0.45,
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                            //color: kPrimaryColor1,
                            border: Border.all(width: 1, color: kPrimaryColor4),
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: DropdownButton(
                            hint: Mytext(
                              text: '\tSelect Class Duration',
                            ),
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 35,
                            iconEnabledColor: Colors.green,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: ddValue,
                            onChanged: (value) {
                              setState(() {
                                ddValue = value;
                                dropVal = true;
                                print(ddValue);
                              });
                            },
                            items: durationTypes.map((value) {
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
                    Mytext(
                      text: 'Additional Note :',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    TextField(
                      autofocus: false,
                      textAlign: TextAlign.start,
                      controller: addnote,
                      maxLength: 50,
                      decoration: InputDecoration(
                        hintText: 'Write here...',
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: kPrimaryColor4)),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Center(
                      child: RoundedButton(
                        text: "SUBMIT",
                        color: kPrimaryColor3,
                        press: () {
                          print("ok");
                          final sbjnm = subjectName.text.trim();
                          final rmnbr = roomNumber.text.trim();
                          final adnt = addnote.text.trim();
                          final id = data['uid'];
                          final n = data['name'];
                          final token = data['fcmToken'];

                          String tkn = data['osToken'];

                          List<String> list = ['$tkn'];

                          FocusScope.of(context).unfocus();

                          validCheck(context, sbjnm, rmnbr, time, toDate,
                              ddValue, adnt, id, n, token, list);
                          print(list);
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
