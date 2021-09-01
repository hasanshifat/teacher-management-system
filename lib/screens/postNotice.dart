import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/firestore/addNotice.dart';

class PostNotice extends StatefulWidget {
  final DocumentSnapshot userDetailsData;
  PostNotice({this.userDetailsData});
  @override
  _PostNoticeState createState() => _PostNoticeState();
}

class _PostNoticeState extends State<PostNotice> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final title = TextEditingController();
  final details = TextEditingController();

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

  validCheck(context, titles, detail) {
    if (title.text.isEmpty) {
      loadSnackBAr(context, 'Please add Title');
    } else if (details.text.isEmpty) {
      loadSnackBAr(context, 'Please add Details');
    } else {
      Dialogs().waiting(context, 'Posting...');
      NoticeDataAdding().noticeRoutineData(context, titles, detail);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // final UserDetails userDetails =
    //     Provider.of<UserDetails>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor4,
        title: Mytext(
          text: 'Add a notice',
        ),
      ),
      body: SafeArea(
        child: Container(
            height: size.height * 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Mytext(
                      text: 'Notice Tilte :',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: title,
                            decoration: InputDecoration(
                              hintText: 'Enter here',
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: kPrimaryColor4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Mytext(
                      text: 'Notice Details :',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: details,
                            decoration: InputDecoration(
                              hintText: 'Enter here',
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: kPrimaryColor4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Center(
                      child: RoundedButton(
                        text: "SUBMIT",
                        color: kPrimaryColor3,
                        press: () {
                          print("ok");
                          setState(() {
                            final titles = title.text.trim();
                            final detail = details.text.trim();

                            FocusScope.of(context).unfocus();
                            validCheck(context, titles, detail);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
