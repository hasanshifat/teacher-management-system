import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tms/Screens/dashboard.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';

class UserSignDataAdding {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  String fcmToken;
  storeNewUSerData(context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = userDetails.userID.toString();

    // final email = userDetails.userEmail.toString();

    // final name = userDetails.userName.toString();
    FirebaseFirestore.instance.collection('/usersData').doc(uid).set({
      'email': userDetails.userEmail.toString(),
      'number': userDetails.phoneNumber.toString(),
      'subject': userDetails.subjectName.toString(),
      'name': userDetails.userName.toString(),
      'uid': userDetails.userID.toString(),
      'role': 'user',
      'fcmToken': userDetails.fcmToken.toString(),
      'osToken': userDetails.osToken.toString(),
    }).then((value) {
      Navigator.pop(context);
      auth
          .signInWithEmailAndPassword(
              email: userDetails.userEmail.toString(),
              password: userDetails.password.toString())
          .then((value) {
        userDetails.dataUserID(value.user.uid);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Dashboard();
            },
          ),
        );
      });
    }).catchError((onError) {
      print(onError);
      Dialogs().error(context, 'SignUp Failed: $onError');
    });
  }
}
