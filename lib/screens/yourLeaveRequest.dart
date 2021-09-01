import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/provider/userDetails.dart';

class YourLeaveRequest extends StatefulWidget {
  @override
  _YourLeaveRequestState createState() => _YourLeaveRequestState();
}

class _YourLeaveRequestState extends State<YourLeaveRequest> {
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
      body: SafeArea(
              child: Container(
           //color: kPrimaryColor3,
          height: size.height *1,
          child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('leaveRequest')
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
                      children:
                          snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.white, width: 0.5)
                                ),
                            //  color: kPrimaryColor1,
                            elevation: 2,
                            child: Container(
                            //  height: size.height * 0.12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [Color(0xffFFFFFF), Color(0xffEDE7FD)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                  //color: kPrimaryColor1,
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          
                                          children: [
                                            Mytext(
                                              text: 'Name \t\t\nStatus ',
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Mytext(
                                              text: ':\t\t\n:',
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
                                                    '${data['requested by']}\n${data['status']}',
                                                fontsize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimaryColor3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    data['status'] != 'Pending'
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Mytext(
                                                text: 'HOD \t\t\t',
                                                fontsize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor3,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Mytext(
                                                text: ':\t\t',
                                                fontsize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor3,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Mytext(
                                                text:
                                                    '${data['hod']}',
                                                fontsize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimaryColor3,
                                              ),
                                            ],
                                          )
                                        : SizedBox(),

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
