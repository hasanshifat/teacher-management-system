import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/roundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/signup.dart';
import 'package:tms/screens/login.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging _firebaseMessaging;
    Size size = MediaQuery.of(context).size;
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // This size provide us total height and width of our screen
    return Container(
      color: Colors.white,
      height: size.height * 1,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.09),
            Text("WELCOME TO",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: kPrimaryColor3,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none),
                )),
            Text("TEACHER MANAGEMENT SYSTEM",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: kPrimaryColor3,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none),
                )),
            SizedBox(height: size.height * 0.05),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/images/teacher.svg",
                height: size.height * 0.45,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                print("ok");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginBody();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: kPrimaryColor1,
              textColor: Colors.black,
              press: () {
                // _firebaseMessaging.getToken().then((token) {
                //   print('t= $token');
                //   userDetails.datafcmToken(token);
                // });
                // print("ok");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpBody();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
