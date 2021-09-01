import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/provider/userDetails.dart';
import 'package:tms/screens/leaveAppToHOD.dart';
import 'package:tms/screens/noticeDetailspage.dart';
import 'package:tms/screens/postNotice.dart';

class DrawerBody extends StatelessWidget {
  final Widget child;
  final String email;
  final String userName;
  final Function press;
  final Color color;
  const DrawerBody({
    Key key,
    this.child,
    this.email,
    this.userName,
    this.color,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: size.height * 0.3,
              color: kPrimaryColor4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Mytext(
                      text: userName,
                      fontsize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Mytext(
                      text: email,
                      fontsize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  userDetails.role.toString() == 'admin'
                      ? ListTile(
                          leading: Icon(
                            Icons.assignment,
                            color: kPrimaryColor4,
                            size: 30,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor3,
                            size: 20,
                          ),
                          title: Mytext(
                            text: 'Requested Leave \nApplications',
                            fontsize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HODLeaveRequest();
                                },
                              ),
                            );
                          })
                      : SizedBox(),
                userDetails.role.toString() == 'admin'
                      ?  Divider():SizedBox(),
                  userDetails.role.toString() == 'admin'
                      ? ListTile(
                          leading: Icon(
                            Icons.description,
                            color: kPrimaryColor4,
                            size: 30,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor3,
                            size: 20,
                          ),
                          title: Mytext(
                            text: 'Post Notice',
                            fontsize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PostNotice();
                                },
                              ),
                            );
                          })
                      : SizedBox(),
                  userDetails.role.toString() == 'admin'
                      ?  Divider():SizedBox(),
                  ListTile(
                      leading: Icon(
                        Icons.view_headline,
                        color: kPrimaryColor4,
                        size: 30,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor3,
                        size: 20,
                      ),
                      title: Mytext(
                        text: 'Notice board',
                        fontsize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NoticeNotificationPage();
                            },
                          ),
                        );
                      }),
                  Divider(),
                  ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: kPrimaryColor4,
                        size: 30,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor3,
                        size: 20,
                      ),
                      title: Mytext(
                        text: 'Sign Out',
                        fontsize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: press),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
