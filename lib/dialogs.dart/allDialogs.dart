import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tms/components/myText.dart';

import '../colors.dart';

class Dialogs {
  exit(context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Center(
            child: Mytext(
              text: 'EXIT',
              fontsize: 20,
              color: kPrimaryColor4,
            ),
          ),
          content: Container(
            height: size.height * 0.05,
            child: Center(
              child: Mytext(
                text: 'Do you want to exit?',
                fontsize: 18,
              ),
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

  waiting(context, a) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Container(
            height: size.height * 0.1,
            width: size.width * 0.01,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Mytext(
                  text: a,
                  fontsize: 18,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  error(context, a) {
    //Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Center(
              child: Mytext(
            text: 'Warning',
            color: kPrimaryColor4,
          )),
          content: Container(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    a,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 1,
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Mytext(
                      text: 'Ok',
                      color: Colors.white,
                    )),
              ),
            )
          ],
        );
      },
    );
  }

  message(context, a, t) {
    // Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: kPrimaryColor1, width: 0.5),
          ),
          title: Center(
              child: Mytext(
            text: t,
            color: kPrimaryColor4,
          )),
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    a,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 1,
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Mytext(
                      text: 'Ok',
                      color: Colors.black,
                    )),
              ),
            )
          ],
        );
      },
    );
  }
}
