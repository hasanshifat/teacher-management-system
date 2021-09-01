import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:tms/Screens/dashboard.dart';
// import 'package:tms/provider/userDetails.dart';
// import 'package:tms/screens/welcome.dart';

class UserDataReading {
  final FirebaseAuth auth = FirebaseAuth.instance;
   getUserData() async {
    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    return await FirebaseFirestore.instance.collection('usersData').get();
  }

  Stream<QuerySnapshot> provideDocumentFieldStream() {
    return FirebaseFirestore.instance.collection('usersData').snapshots();
  }
}
