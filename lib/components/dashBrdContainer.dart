import 'package:flutter/material.dart';
import 'package:tms/colors.dart';

class DashBrdContainer extends StatelessWidget {
  final Widget child;
  final Function press;
  final Color color;
  const DashBrdContainer({
    Key key,
    this.child,
    this.color,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: GestureDetector(
        onTap: press,
        child: Card(
          elevation: 0.5,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: size.height * 0.15,
            height: size.height * 0.15,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: kPrimaryColor3, width: 0.3)),
            child: child,
          ),
        ),
      ),
    );
  }
}
