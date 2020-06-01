import 'package:connectivity/connectivity.dart';

Future<bool> isNetworkOn() async {

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {//se não tenho internet retorna os dados do bd
    return false;
  } else {
    return true;//3g ou wifi
  }

}

