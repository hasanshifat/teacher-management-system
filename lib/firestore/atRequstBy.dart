import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';

class RequestedByDataAdding {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String fcmToken;
  storeRequestedbyUSerData(context, String subjectname, roomnumber, classtime,
      classdate, duration, additionalnote, assTchrUid, assTchrName) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;
    
    

    // final email = userDetails.userEmail.toString();

    // final name = userDetails.userName.toString();

    FirebaseFirestore.instance
        .collection('/requestedBy')
        .doc(uid)
        .collection(userDetails.userName.toString())
        .add({
      'requested by': userDetails.userName.toString(),
      'requestor uid': uid,
      'assigned teacher uid': assTchrUid,
      'assigned teacher name': assTchrName,
      'subject name': subjectname.toString(),
      'room number': roomnumber.toString(),
      'class time': classtime.toString(),
      'class date': classdate.toString(),
      'duration': duration.toString(),
      'additional note': additionalnote.toString(),
      'status': 'Pending',
      'randomNumber':userDetails.randomN1.toString(),
      'created': FieldValue.serverTimestamp()
    }).then((value) {
      Navigator.pop(context);
    }).catchError((onError) {
      print(onError);
      Dialogs().error(context, 'Failed to added data!: $onError');
    });
  }
}
