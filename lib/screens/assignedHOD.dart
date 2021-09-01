import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/provider/userDetails.dart';

class AssiedHOD extends StatefulWidget {
  @override
  _AssiedHODState createState() => _AssiedHODState();
}

class _AssiedHODState extends State<AssiedHOD> {
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future bottomSheet(context, String role, String id, name) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50.0,
                          ),
                          SizedBox(
                            height: 5.0,
                            width: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff191919),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.clear),
                              color: Color(0xff191919),
                              onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Mytext(text: 'Make ' + name.toString().toUpperCase()),
                      SizedBox(
                        height: 10.0,
                      ),
                      role == 'user'
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor1)),
                                  onPressed: () {
                                    firestoreInstance
                                        .collection("usersData")
                                        .doc(id)
                                        .update({"role": 'admin'}).then((_) {
                                      print("success!");
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Mytext(
                                    text: 'An Admin',
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor4)
                                  ),
                                  onPressed: () {
                                    firestoreInstance
                                        .collection("usersData")
                                        .doc(id)
                                        .update({"role": 'user'}).then((_) {
                                      print("success!");
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Mytext(
                                    text: 'a User',
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kPrimaryColor4,
          title: Mytext(
            text: 'HOD',
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usersData')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.docs.length == null) {
                  return Center(
                    child: Mytext(
                      text: 'No User available!',
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: snapshot.data.docs
                        .map((DocumentSnapshot documentSnapshot) {
                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            // side:
                            //     BorderSide(color: kPrimaryColor4, width: 0.5)
                          ),
                          //  color: kPrimaryColor1,
                          elevation: 3,
                          child: Container(
                            //height: size.height * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors: [
                                    kPrimaryColor4.withOpacity(0.1),
                                    Colors.white
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                                //color: kPrimaryColor1,
                                ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: size.height * 0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                      color: kPrimaryColor3,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Mytext(
                                        text:
                                            'Name \t\t\nSubject \t\t\nRole \t\t\nNumber \t\t\nEmail ',
                                        fontsize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor3,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Mytext(
                                        text: ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                                        fontsize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor3,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 2.0,
                                      runSpacing: 2.0,
                                      direction: Axis.vertical,
                                      children: [
                                        Mytext(
                                          text:
                                              '${data['name']}\t\t\n${data['subject']}\t\t\n${data['role']}\t\t\n${data['number']}\t\t\n${data['email']}',
                                          fontsize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: kPrimaryColor3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                final r = data['role'];

                                                final id = data['uid'];
                                                final mail = data['email'];
                                                final name = data['name'];
                                                print(mail);
                                                print(userDetails.userEmail);

                                                if (userDetails.userEmail ==
                                                    ['email']) {
                                                  loadSnackBAr(context,
                                                      'You are already an Admin');
                                                } else
                                                  return bottomSheet(
                                                      context, r, id, name);
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
