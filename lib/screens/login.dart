import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/components/roundedTextfield.dart';
import 'package:tms/components/roundedPassField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _textemail = TextEditingController();
  final _textpassword = TextEditingController();
  bool obscuretexts = true;
  bool val1 = false;
  String uname;
  String upass;
  bool rememberme = false;
  //bool _validate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future sharedpref() async {
    print(rememberme);
    print(uname);
    print(upass);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("uname") ?? null;
    String datapass = sharedPreferences.getString("upass") ?? null;
    bool rem = sharedPreferences.getBool("rem") ?? false;
    this.val1 = rem;
    this.uname = data;
    this.upass = datapass;

    if (val1 == true) {
      setState(() {
        _textemail.value = TextEditingValue(text: uname);
        _textpassword.value = TextEditingValue(text: upass);
        val1 = true;
      });
    } else {
      setState(() {
        val1 = false;
      });
    }
  }

  Future saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      uname = _textemail.text;
      upass = _textpassword.text;
      sharedPreferences.setString('uname', this.uname);
      sharedPreferences.setString('upass', this.upass);
      sharedPreferences.setBool('rem', this.val1);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a,
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none),
              )),
          CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 2,
          )
        ],
      ),
    ));
  }

  void _showToast(BuildContext context, String a) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      duration: Duration(seconds: 2),
      backgroundColor: kPrimaryColor3,
      content: new Text(a,
          style: GoogleFonts.robotoMono(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w300,
                decoration: TextDecoration.none),
          )),
    ));
  }

  void validationcheck() {
    if (_textemail.text.isEmpty) {
      return _showToast(context, 'Enter The Email');
    } else if (!_textemail.text.contains('@') &&
        (!_textemail.text.contains('.com'))) {
      return _showToast(context, 'Enter The Valid Email');
    } else if (!_textemail.text.contains('.com')) {
      return _showToast(context, 'Enter The Valid Email');
    } else if (_textpassword.text.isEmpty) {
      return _showToast(context, 'Enter The Password');
    } else if (_textpassword.text.length < 6) {
      return _showToast(context, 'Enter The Correct Password');
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return Dashboard();
      //     },
      //   ),
      // );
      login();
    }
  }

  Future login() async {
    //loadSnackBAr(context, 'Loading');
    Dialogs().waiting(context, 'Logging in');

    auth
        .signInWithEmailAndPassword(
            email: _textemail.text, password: _textpassword.text)
        .then((user) {
      // print(user);
      // print(user.user.uid);

      if (user.user.uid != null) {
        //  _scaffoldKey.currentState.hideCurrentSnackBar();
        //UserGetData().getUserInfo(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Dashboard();
            },
          ),
        ).then((value) => Navigator.pop(context)).catchError((error) {
          print(error);
          return Dialogs().error(context, error);
        });
      } else if (user.user.uid == null) {
        return Dialogs().error(context, 'Please SignUp first!');
      } else {
        return loadSnackBAr(context, 'Loading');
      }
    }).catchError((onError) {
      var a = onError.message;

      Dialogs().error(context, a);
    });
  }

  @override
  void initState() {
    sharedpref();
    super.initState();
  }

  @override
  void dispose() {
    _textemail.dispose();
    _textpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      left: true,
      right: true,
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.07),
                    Text(
                      "LOGIN",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: kPrimaryColor3,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset(
                      "assets/images/login.svg",
                      height: size.height * 0.35,
                    ),
                    RoundedInputField(
                      controlerText: _textemail,
                      icon: Icons.email,
                      hintText: "Your Email",
                      onChanged: (value) {},
                    ),
                    RoundedPasswordField(
                      controlerText: _textpassword,
                      obscuretext: obscuretexts,
                      press: () {
                        setState(() {
                          obscuretexts = !obscuretexts;
                        });
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      //height: size.height * 0.05,
                      width: size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Save password",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: kPrimaryColor3,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          Switch(
                            value: val1,
                            onChanged: (value) {
                              setState(() {
                                val1 = value;
                                saveData();
                              });
                            },
                            activeColor: kPrimaryColor4,
                            activeTrackColor: kPrimaryColor3,
                          ),
                        ],
                      ),
                    ),
                    RoundedButton(
                      color: kPrimaryColor4,
                      text: "LOGIN",
                      press: () {
                        setState(() {
                          //_text.text.isEmpty ? _showToast(context) : null;
                          validationcheck();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return Dashboard();
                          //     },
                          //   ),
                          // );
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
