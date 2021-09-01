import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/components/roundedTextfield.dart';
import 'package:tms/components/roundedPassField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tms/components/roundedNumberField.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/firestore/signInUserDataClass.dart';
import 'package:tms/provider/userDetails.dart';

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _textname = TextEditingController();
  final _textsubject = TextEditingController();
  final _textnumber = TextEditingController();
  final _textemail = TextEditingController();
  final _textpassword = TextEditingController();

  bool obscuretexts = true;
  //bool val1 = false;
  //bool _validate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // void ab(bool valaue) {
  //   setState(() {
  //     val1 = valaue;
  //   });
  // }

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
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    if (_textname.text.isEmpty) {
      return _showToast(context, 'Enter The Name');
    } else if (_textsubject.text.isEmpty) {
      return _showToast(context, 'Enter The Subject Name');
    } else if (_textnumber.text.isEmpty) {
      return _showToast(context, 'Enter The Number');
    } else if (_textnumber.text.length < 11) {
      return _showToast(context, 'Enter The Valid Number');
    } else if (_textemail.text.isEmpty) {
      return _showToast(context, 'Enter The Email');
    } else if (!_textemail.text.contains('@') &&
        (!_textemail.text.contains('.com'))) {
      return _showToast(context, 'Enter The Valid Email');
    } else if (!_textemail.text.contains('.com')) {
      return _showToast(context, 'Enter The Valid Email');
    } else if (_textpassword.text.isEmpty) {
      return _showToast(context, 'Enter The Password');
    } else if (_textpassword.text.length < 6) {
      return _showToast(context, 'Password is too short');
    } else {
      Dialogs().waiting(context, 'Registering..');
      setState(() {
        userDetails.dataUserName(_textname.text.toString());
        userDetails.dataSubjectname(_textsubject.text.toString());
        userDetails.dataPhoneNumber(_textnumber.text.toString());
        userDetails.dataUseremail(_textemail.text.toString());
        userDetails.dataPassword(_textpassword.text.toString());
        signUp();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return OTPScreen();
        //     },
        //   ),
        // );
      });
    }
  }

  Future signUp() async {
    //loadSnackBAr(context, 'Loading');
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

    auth
        .createUserWithEmailAndPassword(
            email: userDetails.userEmail.toString(),
            password: userDetails.password.toString())
        .then((user) {
      print(user);
      print(user.user.uid);
      setState(() {
        userDetails.dataUserID(user.user.uid);
      });
      print(userDetails.userID.toString());
      String u = userDetails.userID.toString();
      if (u != null) {
        UserSignDataAdding().storeNewUSerData(
          context,
        );
      }
      if (user != null) {
        user.user.updateProfile(displayName: userDetails.userName.toString());
      }
    }).catchError((onError) {
      var a = onError.message;

      Dialogs().error(context, a);
    });
  }

  @override
  void initState() {
    super.initState();
    onesignalToken();
  }

  @override
  void dispose() {
    _textname.dispose();
    _textsubject.dispose();
    _textnumber.dispose();
    _textemail.dispose();
    _textpassword.dispose();
    super.dispose();
  }

  onesignalToken() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    var deviceState = await OneSignal.shared.getDeviceState();
    if (deviceState == null || deviceState.userId == null) return;
    var playerId = deviceState.userId;
    setState(() {
      userDetails.dataOSToken(playerId);
      print(playerId);
    });

    // OneSignal.shared.getDeviceState().then((deviceState) {
    //   print(deviceState.userId);
    //   setState(() {
    //     userDetails.dataOSToken(deviceState.userId);
    //   });
    //   //print("DeviceState: ${deviceState?.jsonRepresentation()}");
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      left: true,
      right: true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.07),
              Text(
                "SIGNUP",
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
                "assets/images/signup.svg",
                height: size.height * 0.35,
              ),
              // Switch(
              //   value: val1,
              //   onChanged: ab,
              //   activeColor: kPrimaryColor4,
              //   activeTrackColor: kPrimaryColor3,

              // ),
              RoundedInputField(
                controlerText: _textname,
                icon: Icons.person,
                hintText: "Your Full Name",
                onChanged: (value) {},
              ),
              RoundedInputField(
                controlerText: _textsubject,
                icon: Icons.book,
                hintText: "Your Subject Name",
                onChanged: (value) {},
              ),
              RoundedMobileNumberField(
                controlerText: _textnumber,
                icon: Icons.phone_android,
                hintText: "Your Mobile Number",
                onChanged: (value) {},
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
              RoundedButton(
                color: kPrimaryColor4,
                text: "SIGNUP",
                press: () {
                  setState(() {
                    //_text.text.isEmpty ? _showToast(context) : null;
                    validationcheck();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return OTPScreen();
                    //     },
                    //   ),
                    // );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
