import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserDetails extends ChangeNotifier {
  var userName;
  var userEmail;
  var phoneNumber;
  var osToken;
  String userID;
  var subjectName;
  var password;
  String role;
  var fcmToken;
  var randomN1;
  int notiCount = 0;

  dataUserName(var username) {
    userName = username;
    notifyListeners();
  }

  dataUserID(var uid) {
    userID = uid;
    notifyListeners();
  }

  dataPhoneNumber(var phonenumber) {
    phoneNumber = phonenumber;
    notifyListeners();
  }

  dataSubjectname(var subjectname) {
    subjectName = subjectname;
    notifyListeners();
  }

  dataUseremail(var useremail) {
    userEmail = useremail;
    notifyListeners();
  }

  dataPassword(var passw) {
    password = passw;
    notifyListeners();
  }

  dataRole(var roles) {
    role = roles;
    notifyListeners();
  }

  datafcmToken(var token) {
    fcmToken = token;
    notifyListeners();
  }

  dataRandomN1(var r2) {
    randomN1 = r2;
    notifyListeners();
  }

  dataNoticeCount(var r3) {
    notiCount = r3;
    notifyListeners();
  }
  dataOSToken(var ostkn) {
    osToken = ostkn;
    notifyListeners();
  }
}
