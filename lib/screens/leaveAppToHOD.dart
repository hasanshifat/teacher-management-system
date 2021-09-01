import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/dashboard.dart';

class HODLeaveRequest extends StatefulWidget {
  @override
  _HODLeaveRequestState createState() => _HODLeaveRequestState();
}

class _HODLeaveRequestState extends State<HODLeaveRequest> {
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool hod = false;

  @override
  void initState() {
    super.initState();
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

  void accept(rqstruid, name, randomNumber, docid) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Dialogs().waiting(context, 'Updating....');
    FirebaseFirestore.instance
        .collection('leaveRequest')
        .doc(rqstruid)
        .collection(name)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('leaveRequest')
            .doc(rqstruid)
            .collection(name)
            .where(
              'randomNumber',
              isEqualTo: randomNumber,
            )
            .get()
            .then((value1) {
          value1.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('leaveRequest')
                .doc(rqstruid)
                .collection(name)
                .doc(element.id)
                .update({"status": "Accepted", 'hod': userDetails.userName});

            FirebaseFirestore.instance
                .collection('leaveRequestToHOD')
                .doc(docid)
                .update({"status": "Accepted", 'hod': userDetails.userName});
          });
        });
      });
    }).whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Dashboard();
          },
        ),
      );
    });
  }

  void reject(rqstruid, name, randomNumber, docid) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Dialogs().waiting(context, 'Updating....');
    FirebaseFirestore.instance
        .collection('leaveRequest')
        .doc(rqstruid)
        .collection(name)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('leaveRequest')
            .doc(rqstruid)
            .collection(name)
            .where(
              'randomNumber',
              isEqualTo: randomNumber,
            )
            .get()
            .then((value1) {
          value1.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('leaveRequest')
                .doc(rqstruid)
                .collection(name)
                .doc(element.id)
                .update({"status": "Rejected", 'hod': userDetails.userName});

            FirebaseFirestore.instance
                .collection('leaveRequestToHOD')
                .doc(docid)
                .update({"status": "Rejected", 'hod': userDetails.userName});
          });
        }).whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Dashboard();
              },
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kPrimaryColor4,
          title: Mytext(
            text: 'Leave Applications',
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('leaveRequestToHOD')
                  .orderBy('created', descending: true)
                  .snapshots(),
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.docs.length == 0) {
                  return Center(
                      child: Mytext(
                    text: 'No data available',
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Mytext(
                      text: 'No data available!',
                      fontsize: 20,
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: snapshot.data.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      Map<String, dynamic> data =
                          documentSnapshot.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            // side: BorderSide(color: kPrimaryColor4, width: 0.5)
                          ),
                          //  color: kPrimaryColor1,
                          elevation: 2,
                          child: GestureDetector(
                            onTap: () {
                              final note =data['additional note'];
                              print(note);

                              Dialogs()
                                  .message(context, note, 'Additional note');
                            },
                            child: Container(
                              //height: size.height * 0.27,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Color(0xffFBF9D5)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                  //color: kPrimaryColor1,
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // Container(
                                        //   width: 10,
                                        //   height: size.height * 0.25,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.only(
                                        //         bottomLeft: Radius.circular(5),
                                        //         topLeft: Radius.circular(5)),
                                        //     color: data['status'] ==
                                        //             'Pending'
                                        //         ? kPrimaryColor2
                                        //         : data['status'] ==
                                        //                 'Rejected'
                                        //             ? Colors.red
                                        //             : data['status'] ==
                                        //                     'Accepted'
                                        //                 ? Colors.green
                                        //                 : kPrimaryColor2,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Mytext(
                                                text:
                                                    'Requested By \t\t\nLeave Type \t\t\nDate \t\t\nStatus \t\t\nNote',
                                                fontsize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Mytext(
                                                text:
                                                    ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                                                fontsize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Wrap(
                                            spacing: 2.0,
                                            runSpacing: 2.0,
                                            direction: Axis.vertical,
                                            children: [
                                              Mytext(
                                                  text:
                                                      '${data['requested by']}\t\t\n${data['leavetype']}\t\t\n${data['formdate'] + ' ' + 'to' + ' ' + data['todate']}\t\t\n${data['status']}\t\t\n${data['additional note']}',
                                                  fontsize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    userDetails.role.toString() == 'admin'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                  width: size.width * 0.4,
                                                  child: MaterialButton(
                                                    shape: StadiumBorder(),
                                                    color: kPrimaryColor1,
                                                    onPressed:
                                                        data[
                                                                    'status'] ==
                                                                'Pending'
                                                            ? () {
                                                                setState(() {
                                                                  final name =data[
                                                                          'requested by'];
                                                                  final rqstruid =data[
                                                                          'requestor uid'];
                                                                  final randomNumber =data[
                                                                          'randomNumber'];
                                                                  final docid =
                                                                      documentSnapshot
                                                                          .id;
                                                                  print(name);
                                                                  print(
                                                                      randomNumber);
                                                                  // print(docid);
                                                                  if (name ==
                                                                      userDetails
                                                                          .userName) {
                                                                    loadSnackBAr(
                                                                        context,
                                                                        'You can not reject your request');
                                                                  } else {
                                                                    reject(
                                                                        rqstruid,
                                                                        name,
                                                                        randomNumber,
                                                                        docid);
                                                                  }
                                                                });
                                                              }
                                                            : null,
                                                    child: Mytext(
                                                      text: 'REJECT',
                                                      fontsize: 15,
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: size.width * 0.4,
                                                child: MaterialButton(
                                                  shape: StadiumBorder(),
                                                  color: kPrimaryColor4,
                                                  onPressed: data[
                                                              'status'] ==
                                                          'Pending'
                                                      ? () {
                                                          setState(() {
                                                            final name =data[
                                                                    'requested by'];
                                                            final rqstruid =data[
                                                                    'requestor uid'];
                                                            final randomNumber =data[
                                                                    'randomNumber'];
                                                            final docid =
                                                                documentSnapshot
                                                                    .id;
                                                            print(name);
                                                            print(randomNumber);
                                                            // print(docid);
                                                            if (name ==
                                                                userDetails
                                                                    .userName) {
                                                              loadSnackBAr(
                                                                  context,
                                                                  'You can not accept your request');
                                                            } else {
                                                              accept(
                                                                  rqstruid,
                                                                  name,
                                                                  randomNumber,
                                                                  docid);
                                                            }
                                                          });
                                                        }
                                                      : null,
                                                  child: Mytext(
                                                    text: 'ACCEPT',
                                                    fontsize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
