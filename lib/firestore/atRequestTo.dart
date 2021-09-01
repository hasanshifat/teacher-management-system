import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/dashboard.dart';

class RequestedTODataAdding {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String fcmToken;
  storeRequestedToUSerData(context, String subjectname, roomnumber, classtime,
      classdate, duration, additionalnote, assTchrUid, assTchrName) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;

    // final email = userDetails.userEmail.toString();

    // final name = userDetails.userName.toString();
    FirebaseFirestore.instance
        .collection('/requestedTo')
        .doc(assTchrUid)
        .collection(assTchrName)
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
       Dialogs().message(context, 'Your request send successfully', 'Message');
    }).catchError((onError) {
      print(onError);
      var a = onError.message;
      Dialogs().error(context, a);
    });
  }

  notificationData(token) {
    FirebaseFirestore.instance
        .collection('/notificationDemo')
        .doc()
        .collection('notification')
        .add({
      'message': 'message',
      'title': 'title',
      'fcmToken': token,
      'created': FieldValue.serverTimestamp()
    });
  }
}
