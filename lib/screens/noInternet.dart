import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';

class NoNet extends StatelessWidget {
  exit(context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Container(
            height: size.height * 0.1,
            width: size.width * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Mytext(
                  text: 'EXIT',
                  fontsize: 20,
                  color: kPrimaryColor4,
                ),
                Mytext(
                  text: 'Do you want to exit?',
                  fontsize: 18,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Mytext(
                  text: 'Yes',
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Mytext(
                    text: 'No',
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => exit(context),
        child: Scaffold(
          body: SafeArea(
            right: true,
            left: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.2),
                    Container(
                      child: SvgPicture.asset(
                        "assets/images/nonet.svg",
                        height: size.height * 0.45,
                      ),
                    ),
                    Mytext(
                      fontsize: 18,
                      text:
                          'Wi-Fi/Mobile data is off! \nPlease check your connection',
                    ),
                    // SizedBox(height: size.height * 0.2)
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
