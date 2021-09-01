import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/contstants.dart';
import 'package:tms/provider/internetCheck.dart';
import 'package:tms/screens/dashboard.dart';
import 'package:tms/screens/noInternet.dart';
import 'screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
//import 'package:tms/screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'provider/userDetails.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDetails>.value(
          value: UserDetails(),
        ),
        ChangeNotifierProvider<InternetCheck>.value(
          value: InternetCheck(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TMS',
        theme: ThemeData(
          //primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: MyhomePage(),
        routes: <String, WidgetBuilder>{
          '/nonet': (BuildContext context) => NoNet(),
        },
      ),
    );
  }
}

class MyhomePage extends StatefulWidget {
  @override
  _MyhomePageState createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    final InternetCheck internetCheck =
        Provider.of<InternetCheck>(context, listen: false);

    internetCheck.connectivityCheck(context);
    // UserGetData().getUserInfo(context);
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showMessage("Notification", "$message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     showMessage("Notification", "$message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     showMessage("Notification", "$message");
    //   },
    // );
    onesignal();
    super.initState();
  }

  onesignal() {
    var debugLabelString;
    OneSignal.shared.setAppId(osAppId);

    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(osAppId);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
      this.setState(() {
        debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
  }

  showMessage(title, description) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Body(),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<auth.User>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            Navigator.pushNamed(context, '/nonet');
          } else if (snapshot.connectionState == ConnectionState.active) {
            auth.User user = snapshot.data;
            //get the user status once the connection is established
            if (user == null) {
              //print("User is NULL::: " + user.toString());
              return Body(); //
            }
            print("User is NOT NULL::: " + user.toString());
            //home screen
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: kPrimaryColor4,
                ), //called in case all fails while waiting for connection status
              ),
            );
          } else if (snapshot.hasData) {
            setState(() {
              auth.User user = snapshot.data;
              userDetails.dataUserID(user.uid);
              print(userDetails.userID.toString());
            });
          }
          return Dashboard();
        },
      ),
    );
  }
}
