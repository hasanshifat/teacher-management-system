import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/contstants.dart';
import 'package:tms/components/dashBrdContainer.dart';
import 'package:tms/components/myText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tms/firestore/readData.dart';
import 'package:tms/oneSignalNotificationSend.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/acceptReject.dart';
import 'package:tms/screens/addRoutine.dart';
import 'package:tms/screens/assignTeacher.dart';
import 'package:tms/screens/assignedHOD.dart';
import 'package:tms/screens/classRoutine.dart';
import 'package:tms/screens/noticeDetailspage.dart';
import 'package:tms/screens/testPage.dart';
import 'package:tms/screens/welcome.dart';
import 'package:tms/components/drawer.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uEmail;
  QuerySnapshot querySnapshot;
  UserDataReading userDataReading = UserDataReading();
  int a = 0;
  int b = 0;
  int val = 0;
  bool notify = false;

  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void loadSnackBAr(BuildContext context, String a) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      duration: Duration(seconds: 2),
      backgroundColor: kPrimaryColor3,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(a,
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none),
              )),
        ],
      ),
    ));
  }

  Future getUserInfo(context) async {
    print('calledd');
    // firestoreInstance.collection("usersData").get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((result) {
    //     print(result.data());
    //   });
    // });
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance
        .collection("usersData")
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((value) {
      if (value != null) {
        setState(() {
          getnotice(context);
          userDetails.dataRole(value.data()['role']);
          userDetails.dataUserName(value.data()['name']);
          userDetails.dataUseremail(value.data()['email']);
          userDetails.dataUserID(value.data()['uid']);
          print(userDetails.userName.toString());
          print(userDetails.userID.toString());
        });
        // return loadSnackBAr(
        //     context, 'Welcome ' + userDetails.userName.toString());
      }
    });
  }

  void getnotice(context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final uid = auth.currentUser.uid;

    FirebaseFirestore.instance.collection("notice").get().then((element) {
      element.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('notice')
            .doc(element.id)
            .get()
            .then((value) {
          if (value.data()['usersid'].contains(uid)) {
            if (userDetails.notiCount > 0) {
              setState(() {
                b = b - 1;
                userDetails.dataNoticeCount(0);
                print('ase');
              });
            }
          }

          //print(userDetails.notiCount);
          if (!value.data()['usersid'].contains(uid)) {
            setState(() {
              a = a + 1;
              userDetails.dataNoticeCount(a);
              print('not');
            });
          }
          if (a - b > 0) {
            setState(() {
              val = a;
            });
          } else {
            setState(() {
              val = b;
            });
          }

          print(userDetails.notiCount);
        });
      });
    });
  }

  @override
  void initState() {
    getUserInfo(context);
    super.initState();
  }

  // Future sendNotification(BuildContext context) async {
  //   var url = Uri.parse('https://onesignal.com//api/v1/notifications');
  //   var data;

  //   final response = await http
  //       .post(
  //         url,
  //         // encoding: Encoding.getByName("utf-8"),
  //         body: {
  //           "app_id": osAppId,
  //           "include_player_ids": list,
  //           "headings": 'test',
  //           "contents": 'shifat done'
  //         },
  //       )
  //       .timeout(Duration(seconds: 60))
  //       .catchError((error) {
  //         print(error);
  //       });
  //   data = json.decode(response.body);
  //   print(data);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    uEmail = auth.currentUser.email;
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

    // This size provide us total height and width of our screen

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerBody(
        email: uEmail,
        userName: userDetails.userName.toString(),
        press: () {
          auth.signOut().then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Body();
                },
              ),
            );
          });
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor4,
        title: Mytext(
          text: 'DASHBOARD',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //color: Colors.black,
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              width: 40,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      val = 0;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NoticeNotificationPage();
                        },
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.notifications,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      val > 0
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    shape: BoxShape.circle),
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: Text(
                                    '$val',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () => Dialogs().exit(context),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height * 0.25,
                  width: size.width * 1,
                  decoration: BoxDecoration(
                      color: kPrimaryColor4.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      border: Border.all(color: kPrimaryColor3, width: 0.3)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Mytext(
                          text: "Welcome to TMS",
                          fontsize: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SvgPicture.asset(
                          "assets/images/onboard.svg",
                          height: size.height * 0.15,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DashBrdContainer(
                      color: kPrimaryColor11.withOpacity(0.05),
                      press: () {
                        OSFunction.sendNotification(
                            tokenIdList, 'shifat done', 'test');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return TestPage();
                        //     },
                        //   ),
                        // );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            child: SvgPicture.asset(
                              "assets/images/event_busy.svg",
                              color: kPrimaryColor11,
                              //height: size.height * 0.35,
                            ),
                          ),
                          Mytext(
                            text: 'Request for',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          Mytext(
                            text: 'leave',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    DashBrdContainer(
                      color: kPrimaryColor44.withOpacity(0.05),
                      press: () {
                        print('object2');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AssiedTeacher();
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            //color: kPrimaryColor3,
                            child: SvgPicture.asset(
                              "assets/images/person_add.svg",
                              color: kPrimaryColor44,
                              //height: size.height * 0.35,
                            ),
                          ),
                          Mytext(
                            text: 'Assign a',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          Mytext(
                            text: 'Teacher',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DashBrdContainer(
                      color: kPrimaryColor33.withOpacity(0.05),
                      press: () {
                        print('object3');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddRoutine();
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            //color: kPrimaryColor3,
                            child: SvgPicture.asset(
                              "assets/images/schedule.svg",
                              color: kPrimaryColor33,
                              //height: size.height * 0.35,
                            ),
                          ),
                          Mytext(
                            text: 'Add Routine',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    DashBrdContainer(
                      color: kPrimaryColor22.withOpacity(0.05),
                      press: () {
                        print('object4');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AcceptReject();
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            //color: kPrimaryColor3,
                            child: SvgPicture.asset(
                              "assets/images/swap_vert.svg",
                              color: kPrimaryColor22,
                              //height: size.height * 0.35,
                            ),
                          ),
                          Mytext(
                            text: 'Accept Reject',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userDetails.role.toString() == 'admin'
                        ? DashBrdContainer(
                            color: kPrimaryColor3.withOpacity(0.05),
                            press: () {
                              print('object5');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AssiedHOD();
                                  },
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.05,
                                  width: size.height * 0.05,
                                  //color: kPrimaryColor3,
                                  child: SvgPicture.asset(
                                    "assets/images/admin.svg",
                                    color: kPrimaryColor3,
                                    //height: size.height * 0.35,
                                  ),
                                ),
                                Mytext(
                                  text: 'Assigned',
                                  fontsize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                Mytext(
                                  text: 'HOD',
                                  fontsize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    DashBrdContainer(
                      color: kPrimaryColor4.withOpacity(0.05),
                      press: () {
                        print('object6');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ClassRoutine();
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            //color: kPrimaryColor3,
                            child: SvgPicture.asset(
                              "assets/images/article.svg",
                              color: kPrimaryColor4,
                              //height: size.height * 0.35,
                            ),
                          ),
                          Mytext(
                            text: 'Class Routine',
                            fontsize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
