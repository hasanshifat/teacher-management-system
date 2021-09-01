import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';

class RoutineDataAdding {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String fcmToken;
  storeRoutineData(context, day, period, tname, subject) {
    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    // final uid = auth.currentUser.uid;

    FirebaseFirestore.instance
        .collection('/classroutine')
        .doc(day)
        .collection(period)
        .add({
      'teachername': tname,
      'day': day,
      'period': period,
      'subject': subject,
      'created': FieldValue.serverTimestamp()
    }).then((value) {
      Navigator.pop(context);
    }).catchError((onError) {
      print(onError);
      Dialogs().error(context, 'Failed to added data!: $onError');
    });
  }
}
