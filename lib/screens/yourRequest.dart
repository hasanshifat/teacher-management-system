import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/provider/userDetails.dart';

class YourRequest extends StatefulWidget {
  @override
  _YourRequestState createState() => _YourRequestState();
}

class _YourRequestState extends State<YourRequest> {
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loadData = false;

  @override
  void initState() {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    userDetails.dataUserID(auth.currentUser.uid);
    print(userDetails.userID.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        //  color: kPrimaryColor3,
        height: size.height * 1,
        child: SafeArea(
                  child: SingleChildScrollView(
                                      child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                    .collection('requestedBy')
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
                            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              //side: BorderSide(color: kPrimaryColor3, width: 0.5)
                            ),
                            //  color: kPrimaryColor1,
                            elevation: 3,
                            child: Container(
                            //  height: size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [Color(0xffFFFFFF), Color(0xffD0D0D0)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                  //color: kPrimaryColor1,
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: size.height * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            topLeft: Radius.circular(5)),
                                        color: data['status'] ==
                                                'Pending'
                                            ? kPrimaryColor2
                                            : data['status'] ==
                                                    'Rejected'
                                                ? Colors.red
                                                : data['status'] ==
                                                        'Accepted'
                                                    ? Colors.green
                                                    : kPrimaryColor2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Mytext(
                                          text:
                                              'Name \t\t\nClass Date \t\t\nStatus ',
                                          fontsize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor3,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Mytext(
                                          text: ':\t\t\n:\t\t\n: ',
                                          fontsize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor3,
                                        ),
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
                                                '${data['assigned teacher name']}\t\t\n${data['class date']}\t\t\n${data['status']}',
                                            fontsize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryColor3,
                                          ),
                                        ],
                                      ),
                                    ),
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
