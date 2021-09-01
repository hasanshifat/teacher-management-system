import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/dashboard.dart';

class LeaveRequestDataAdding {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String fcmToken;
  storeLeaveRequestedData(context, fromDate, toDate, ddValue, note) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;

    FirebaseFirestore.instance
        .collection('/leaveRequest')
        .doc(uid)
        .collection(userDetails.userName.toString())
        .add({
      'requested by': userDetails.userName.toString(),
      'requestor uid': uid,
      'additional note': note.toString(),
      'formdate': fromDate,
      'todate': toDate,
      'leavetype': ddValue,
      'status': 'Pending',
      'hod': '',
      'randomNumber': userDetails.randomN1.toString(),
      'created': FieldValue.serverTimestamp()
    }).then((value) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Dashboard();
          },
        ),
      );
      Dialogs().message(context, 'Your request sumbitted', 'Message');
    }).catchError((onError) {
      print(onError);
      Dialogs().error(context, 'Failed to added data!: $onError');
    });
  }

  storeLeaveRequestedDataForHOD(context, fromDate, toDate, ddValue, note) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;

    FirebaseFirestore.instance.collection('/leaveRequestToHOD').add({
      'requested by': userDetails.userName.toString(),
      'requestor uid': uid,
      'additional note': note.toString(),
      'formdate': fromDate,
      'todate': toDate,
      'leavetype': ddValue,
      'status': 'Pending',
      'hod': '',
      'randomNumber': userDetails.randomN1.toString(),
      'created': FieldValue.serverTimestamp()
    });
  }
}
