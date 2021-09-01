import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/provider/userDetails.dart';

// ignore: must_be_immutable
class NoticeNotificationPage extends StatefulWidget {
  @override
  _NoticeNotificationPageState createState() => _NoticeNotificationPageState();
}

class _NoticeNotificationPageState extends State<NoticeNotificationPage> {
  var date;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  Map<String, dynamic> seenStatus;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('notice').doc();
  String docid;
  bool seen = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var id;
  int a = 0;
  int b = 0;

  updatedata(context, id) {
    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;
    FirebaseFirestore.instance.collection('notice').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('notice').doc(id).set({
          'usersid': FieldValue.arrayUnion([uid.toString()]),
        }, SetOptions(merge: true)).then((value) {
          print('suc');
          // if (userDetails.notiCount > 0) {
          //   print(userDetails.notiCount);
          //   setState(() {
          //     var a = userDetails.notiCount - 1;
          //     userDetails.dataNoticeCount(a);
          //     print(userDetails.notiCount);
          //   });
          // }
        });
      });
    });
  }

  void getnotice(context) {
    print('cccccccc');

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
              setState(() {
                b = b - 1;
              });
            }
          }

          //print(userDetails.notiCount);
          else if (!value.data()['usersid'].contains(uid)) {
            // print(userDetails.notiCount);

            setState(() {
              a = a + 1;
            });
          }
          if (a - b > 0) {
            setState(() {
              userDetails.dataNoticeCount(a);
            });
          } else {
            setState(() {
              userDetails.dataNoticeCount(0);
            });
          }

          //  print(userDetails.notiCount);
        });
      });
    });
  }

  @override
  void initState() {
    //  getdata();
    id = auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    //print(id);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kPrimaryColor4,
          title: Mytext(
            text: 'Notice',
          )),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notice')
              .orderBy('created', descending: true)
              .snapshots(),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.docs.length == 0) {
              return Center(
                  child: Mytext(
                text: 'No data availalbe',
              ));
            } else if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  final Timestamp timestamp = data['created'];

                  date = df.format(new DateTime.fromMillisecondsSinceEpoch(
                      timestamp.millisecondsSinceEpoch));

                  return Container(
                    decoration: BoxDecoration(
                        color: data['usersid'].contains(userDetails.userID)
                            ? Colors.white
                            : Colors.lightBlueAccent.withOpacity(0.2),
                        border: Border(
                            bottom:
                                BorderSide(width: 0.3, color: kPrimaryColor3))),
                    child: ListTile(
                      onTap: () {
                        final id = documentSnapshot.id;
                        setState(() {
                          docid = id;
                        });
                        updatedata(context, id);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NoticeNotificationPageDetailsPage(
                                notificationDetailsData: documentSnapshot,
                              );
                            },
                          ),
                        );
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Mytext(
                                    text:
                                        data['title'].toString().toUpperCase(),
                                    fontsize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor3),
                                Mytext(
                                    text: data['postedby']
                                        .toString()
                                        .toUpperCase(),
                                    fontsize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor3),
                              ],
                            ),
                          ),
                          Mytext(
                            fontsize: 10,
                            text: date,
                            color: kPrimaryColor4,
                          ),
                        ],
                      ),
                      subtitle: Mytext(
                        text: data['details'],
                        fontsize: 15,
                        color: kPrimaryColor2,
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}

class NoticeNotificationPageDetailsPage extends StatefulWidget {
  final DocumentSnapshot notificationDetailsData;
  NoticeNotificationPageDetailsPage({this.notificationDetailsData});
  @override
  _NoticeNotificationPageDetailsPageState createState() =>
      _NoticeNotificationPageDetailsPageState();
}

class _NoticeNotificationPageDetailsPageState
    extends State<NoticeNotificationPageDetailsPage> {
  @override
  void initState() {
    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    // if (userDetails.notiCount > 0) {
    //   return GetnoticeCount().getnotice(context);
    // }
    setState(() {
      data = widget.notificationDetailsData.data() as Map<String, dynamic>;
    });
    super.initState();
  }

  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor4,
        title: Mytext(
          text: 'Notice Details',
        ),
      ),
      body: SafeArea(
        child: Container(
            height: size.height * 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    // Mytext(
                    //   text: 'Title :',
                    //   fontsize: 20,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    Text(
                      data['title']
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 20, color: kPrimaryColor3),
                    ),
                    Mytext(
                      text:data['postedby']
                          .toString()
                          .toUpperCase(),
                      fontsize: 12,
                      color: kPrimaryColor4,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Mytext(
                      text: 'Details :',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(data['details']
                          .toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
