import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/youAssignedBy.dart';
import 'package:tms/screens/yourLeaveRequest.dart';
import 'package:tms/screens/yourRequest.dart';

class AcceptReject extends StatefulWidget {
  @override
  _AcceptRejectState createState() => _AcceptRejectState();
}

class _AcceptRejectState extends State<AcceptReject>
    with SingleTickerProviderStateMixin {
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loadData = false;
  TabController controller;
  

  @override
  void initState() {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    userDetails.dataUserID(auth.currentUser.uid);
    print(userDetails.userID.toString());
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kPrimaryColor4,
          title: Mytext(
            text: 'Acception/Rejection',
          ),
          bottom: TabBar(
            controller: controller, 
            indicatorColor: Colors.green,
            labelStyle: TextStyle(fontSize: 12),
          tabs: <Widget>[
            Tab(
              text: 'Your Request',
            ),
            Tab(
              text: 'Requested you ',
            ),
            Tab(
              text: 'Leave Request',
            ),
          ]),
        ),
        body: TabBarView(
          controller: controller,
          children: [
          YourRequest(),
          YouAssignedBy(),
          YourLeaveRequest()
        ]));
  }
}
