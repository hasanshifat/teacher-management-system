import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mytext3 extends StatelessWidget {
  final String text;
  final double fontsize;
  final Color color;
  final FontWeight fontWeight;
  const Mytext3({
    this.text,
    this.fontsize,
    this.color,
    this.fontWeight,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(text,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: color,
                      fontSize: fontsize,
                      letterSpacing: 1,
                      fontWeight: fontWeight,
                      height: 1.5,
                      decoration: TextDecoration.none),
                )),
          ),
        ),
      ],
    );
  }
}
