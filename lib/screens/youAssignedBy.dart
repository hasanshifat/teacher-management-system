import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';

class YouAssignedBy extends StatefulWidget {
  @override
  _YouAssignedByState createState() => _YouAssignedByState();
}

class _YouAssignedByState extends State<YouAssignedBy> {
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference rejectData =
      FirebaseFirestore.instance.collection("requestedTo");

  void reject(asstchruid, rqsdby, randomnumber, classtime, docid) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

    FirebaseFirestore.instance
        .collection('requestedTo')
        .doc(userDetails.userID)
        .collection(userDetails.userName)
        .doc(docid)
        .update({"status": "Rejected"}).then((value) {
      FirebaseFirestore.instance
          .collection('requestedBy')
          .doc(asstchruid)
          .collection(rqsdby)
          .where(
            'randomNumber',
            isEqualTo: randomnumber,
          )
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('requestedBy')
              .doc(asstchruid)
              .collection(rqsdby)
              .doc(element.id)
              .update({"status": "Rejected"});
        });
      });
      Navigator.pop(context);
    });
  }

  void accept(asstchruid, rqsdby, randomnumber, classtime, docid) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

    FirebaseFirestore.instance
        .collection('requestedTo')
        .doc(userDetails.userID)
        .collection(userDetails.userName)
        .doc(docid)
        .update({"status": "Accepted"}).then((value) {
      FirebaseFirestore.instance
          .collection('requestedBy')
          .doc(asstchruid)
          .collection(rqsdby)
          .where(
            'randomNumber',
            isEqualTo: randomnumber,
          )
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('requestedBy')
              .doc(asstchruid)
              .collection(rqsdby)
              .doc(element.id)
              .update({"status": "Accepted"});
        });
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        // color: kPrimaryColor3,
        height: size.height * 1,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requestedTo')
                    .doc(userDetails.userID)
                    .collection(userDetails.userName)
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
                        text: 'No data available!',
                        fontsize: 20,
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: Colors.white, width: 0.5)),
                            //  color: kPrimaryColor1,
                            elevation: 1,
                            child: Container(
                              // height: size.height * 0.34,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffFFFFFF),
                                      Color(0xffEAF8FB)
                                    ],
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
                                    GestureDetector(
                                      onTap: () {
                                        final note = data['additional note'];
                                        print(note);
                                        Dialogs().message(
                                            context, note, 'Additional note');
                                      },
                                      child: SizedBox(
                                        // height: size.height * 0.25,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                // height: size.height * 0.4,
                                                width: size.width * 0.9,
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Mytext(
                                                            text:
                                                                'Requested By \t\t\nClass Date \t\t\nClaas time \t\t\nStatus \t\t\nNote',
                                                            fontsize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kPrimaryColor3),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Mytext(
                                                            text:
                                                                ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                                                            fontsize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kPrimaryColor3),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Wrap(
                                                        spacing: 2.0,
                                                        runSpacing: 2.0,
                                                        direction:
                                                            Axis.vertical,
                                                        children: [
                                                          Mytext(
                                                              text:
                                                                  '${data['requested by']}\t\t\n${data['class date']}\t\t\n${data['class time']}\t\t\n${data['status']}\t\t\n${data['additional note']}',
                                                              fontsize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  kPrimaryColor3),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                            width: size.width * 0.4,
                                            child: MaterialButton(
                                              elevation: 1,
                                              color: kPrimaryColor1,
                                              onPressed: data['status'] ==
                                                      'Pending'
                                                  ? () {
                                                      setState(() {
                                                        final asstchruid = data[
                                                            'requestor uid'];
                                                        final rqsdby = data[
                                                            'requested by'];

                                                        final classtime =
                                                            data['class time'];
                                                        final randomnumber =
                                                            data[
                                                                'randomNumber'];

                                                        final docid =
                                                            documentSnapshot.id;

                                                        // print(randomnumber);

                                                        // print(classtime);
                                                        reject(
                                                            asstchruid,
                                                            rqsdby,
                                                            randomnumber,
                                                            classtime,
                                                            docid);
                                                      });

                                                      Dialogs().waiting(context,
                                                          'Updating....');
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
                                            elevation: 1,
                                            color: kPrimaryColor4,
                                            onPressed: data['status'] ==
                                                    'Pending'
                                                ? () {
                                                    setState(() {
                                                      final asstchruid =
                                                          data['requestor uid'];
                                                      final rqsdby =
                                                          data['requested by'];
                                                      // final date = documentSnapshot
                                                      //     .data()['class date'];
                                                      final classtime =
                                                          data['class time'];
                                                      final randomnumber =
                                                          data['randomNumber'];
                                                      final docid =
                                                          documentSnapshot.id;
                                                      print(randomnumber);
                                                      // print(rqsdby);
                                                      // print(docid);
                                                      accept(
                                                          asstchruid,
                                                          rqsdby,
                                                          randomnumber,
                                                          classtime,
                                                          docid);
                                                      Dialogs().waiting(context,
                                                          'Updating....');
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
                                  ],
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
      ),
    );
  }
}
