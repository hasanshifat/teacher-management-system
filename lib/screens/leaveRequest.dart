import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/firestore/atLeaveRequest.dart';
import 'package:tms/provider/userDetails.dart';

class LeaveRequest extends StatefulWidget {
  @override
  _LeaveRequestState createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final addnote = TextEditingController();
  String ddValue;
  List leaveTypes = [
    'Casual Leave',
    'Sick Leave',
    'Maternity leave',
    'Paternity leave',
    'Unpaid Leave'
  ];
  bool dropVal = false;
  var fromDate;
  var toDate;

  DateTime dateTimeFrom = DateTime.now();
  DateTime dateTimeTo = DateTime.now();

  @override
  void initState() {
    randomnumber();
    super.initState();
  }

  Future selectFromDate(BuildContext context) async {
    print(fromDate);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTimeFrom,
      firstDate: DateTime(1950),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      setState(() {
        dateTimeFrom = picked;
        fromDate =
            "${dateTimeFrom.year}-${dateTimeFrom.month}-${dateTimeFrom.day}";
        print(fromDate);
      });
    }
  }

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

  validCheck() {
    if (dropVal == false) {
      loadSnackBAr(context, 'Please Select Leave Type');
    } else if (fromDate == null) {
      loadSnackBAr(context, 'Please Select Start Date');
    } else if (toDate == null) {
      loadSnackBAr(context, 'Please Select End Date');
    } else {
      final note = addnote.text;
      LeaveRequestDataAdding()
          .storeLeaveRequestedData(context, fromDate, toDate, ddValue, note);
      LeaveRequestDataAdding().storeLeaveRequestedDataForHOD(
          context, fromDate, toDate, ddValue, note);
      

      Dialogs().waiting(context, 'Sumitting request..');
    }
  }

  var random;
  void randomnumber() {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    random = Random();
    var n1 = random.nextInt(32);
    var n2 = random.nextInt(64);
    var n3;
    if (n2 >= n1) {
      n2 += 1;
      n3 = n1 + n2;
      print(n3);
      setState(() {
        userDetails.dataRandomN1(n3);
        print(userDetails.randomN1.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kPrimaryColor4,
          title: Mytext(
            text: 'Request For Leave',
          )),
      body: SafeArea(
        child: Container(
          color: Colors.white,
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
                                userDetails.userName.toString().toUpperCase(),
                            fontsize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Mytext(
                    text: 'Leave Type :',
                    fontsize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                      width: size.width * 1,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                          //color: kPrimaryColor1,
                          border: Border.all(width: 1, color: kPrimaryColor4),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: DropdownButton(
                          hint: Mytext(
                            text: '\tSelect Leave Type',
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
                              randomnumber();
                              print(ddValue);
                            });
                          },
                          items: leaveTypes.map((value) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Mytext(
                            text: 'Start Date :',
                            fontsize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          GestureDetector(
                            onTap: () {
                              selectFromDate(context);
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
                                          "${dateTimeFrom.year}-${dateTimeFrom.month}-${dateTimeFrom.day}",
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Mytext(
                            text: 'End Date :',
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
                    text: 'Additional Note :',
                    fontsize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextField(
                    autofocus: false,
                    controller: addnote,
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
                      press: () {
                        print("ok");
                        validCheck();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
