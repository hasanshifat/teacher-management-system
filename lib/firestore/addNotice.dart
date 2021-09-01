import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/dashboard.dart';

class NoticeDataAdding {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String fcmToken;
  noticeRoutineData(context, titles, detail) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    //final uid = auth.currentUser.uid;

    FirebaseFirestore.instance.collection('/notice').add({
      'title': titles,
      'details': detail,
      'postedby': userDetails.userName,
      'usersid': FieldValue.arrayUnion(['']),
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
      Dialogs().message(context, 'Your Notice Posted', 'Message');
    }).catchError((onError) {
      var a = onError.message;
      print(onError);
      Dialogs().error(context, a);
    });
  }
}
