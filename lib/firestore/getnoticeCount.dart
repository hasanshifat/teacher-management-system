import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tms/provider/userDetails.dart';

class GetnoticeCount {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void getnotice(context) {
    int a = 0;
    int b = 0;
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;

    FirebaseFirestore.instance.collection("notice").get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('notice')
            .doc(element.id)
            .get()
            .then((value) {
          if (value.data()['usersid'].contains(uid)) {
            if (userDetails.notiCount > 0) {
              b = b - 1;
            }
          }

          //print(userDetails.notiCount);
          else if (!value.data()['usersid'].contains(uid)) {
            print(userDetails.notiCount);

            a = a + 1;
            print('aa');
          }
          if (a - b > 0) {
            userDetails.dataNoticeCount(a);
          } else {
            userDetails.dataNoticeCount(0);
          }

          print(userDetails.notiCount);
        });
      });
    });
  }
}
