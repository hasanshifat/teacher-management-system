import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';

class InternetCheck extends ChangeNotifier {
  Connectivity connectivity = Connectivity();

  String networkState = '';
  String prevs = 'no';
  var conn;
  var contxt;
  void connectivityCheck(BuildContext context) async {
    final InternetCheck internetCheck =
        Provider.of<InternetCheck>(context, listen: false);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      conn = getConnectionValue(result);
      networkState = conn;
      print(networkState);
      print(prevs + '1');
      internetCheck.datanetworkState(networkState);
      if (prevs == 'no' && networkState == 'None') {
        prevs = 'yes';
        // print('========');
        // print(prevs + '2');
        // print("shifat");
        // print('========');
        // dialaogsFucntion.internetDialog(context);
        this.nextPage(context);
      }
      if (prevs == 'yes' && networkState == 'Mobile') {
        prevs = 'no';
        // print('========');
        // print(prevs + '3');
        // print("shifat3");
        // print('========');
        removePage(context);
        //Navigator.pop(context,dialaogsFucntion.internetDialog(context));
      }
      if (prevs == 'yes' && networkState == 'Wi-Fi') {
        prevs = 'no';
        // print('========');
        // print(prevs + '4');
        // print("shifat4");
        // print('========');
        removePage(context);
        //Navigator.pop(context,dialaogsFucntion.internetDialog(context));

      }
    });
    notifyListeners();
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';

    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  datanetworkState(String networkState) {
    networkState = networkState;
    notifyListeners();
  }

  void nextPage(context) {
    Navigator.pushNamed(context, '/nonet');
    //Navigator.push(context, MaterialPageRoute(builder: (context) => NoNet(),));
  }

  void removePage(context) {
    Navigator.pop(context);
  }
}
