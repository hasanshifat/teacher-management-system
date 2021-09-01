import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/otpField.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:tms/dialogs.dart/allDialogs.dart';
import 'package:tms/provider/userDetails.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _text = TextEditingController();
  int sec = 60;
  int min = 1;

  Timer timer;
  bool submit = false;
  bool tDone = false;
  String smsCode;
  String verificationID;

  Future startTimer() async {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (sec > 0) {
            sec--;
            print(sec);
          } else if (sec == 0) {
            if (sec == 0 && min == 0) {
              return timer.cancel();
            }
            setState(() {
              min = min - 1;
              sec = 60;
            });
          }
        });
      }
    });
  }

  Future signUp(String a) async {
    //loadSnackBAr(context, 'Loading');

    if (a != null) {
      // _scaffoldKey.currentState.hideCurrentSnackBar();

    }
    // auth
    //     .createUserWithEmailAndPassword(
    //         email: userDetails.userEmail.toString(),
    //         password: userDetails.password.toString())
    //     .then((user) {
    //   print(user);
    //   print(user.user.uid);

    // });
  }

  Future<void> verifyPhone() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    print(userDetails.phoneNumber.toString());
    final PhoneCodeAutoRetrievalTimeout pCodeAuto = (String verID) {
      this.verificationID = verID;
    };

    final PhoneCodeSent phoneCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationID = verID;
    };

    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) async {
      UserCredential userCredential =
          await auth.signInWithCredential(authCredential);
      Navigator.pop(context);
      if (userCredential.user.uid != null) {
        this.signUp(userCredential.user.uid);
      }
      // AuthCResult authCredential = await auth.signInWithPhoneNumber(authCredential)
    };
    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException firebaseAuthException) {
      print(firebaseAuthException);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: userDetails.phoneNumber,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        timeout: Duration(seconds: 120),
        codeAutoRetrievalTimeout: pCodeAuto);
  }

  void calledFunction() {
    startTimer();
    verifyPhone();
  }

  @override
  void initState() {
    calledFunction();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      left: true,
      right: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.09),
              Text(
                "OTP Validation",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: kPrimaryColor3,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "0" + "$min" + ':' + '$sec',
                style: GoogleFonts.robotoMono(
                  textStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              PinCodeField(
                controlerText: _text,
                onChanged: (value) {
                  this.smsCode = value;
                  print(_text);
                },
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              RoundedButton(
                color: kPrimaryColor4,
                text: "SUBMIT",
                press: () {
                  setState(() async {
                    final code = _text.text.trim();
                    print(code);
                    AuthCredential authCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationID, smsCode: code);
                    UserCredential userCredential =
                        await auth.signInWithCredential(authCredential);
                    Dialogs().waiting(context, 'Verifying...');
                    print(userCredential.user.uid);
                    print('=');
                    print(authCredential);
                    print('=');
                  });
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    timer.cancel();
                    _text.clear();
                    sec = 60;
                    min = 1;

                    startTimer();
                  });
                },
                child: Text(
                  "Resend OTP",
                  style: GoogleFonts.robotoMono(
                    textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
