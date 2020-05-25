

import 'package:flutter/cupertino.dart';

class ApiResponse<T> {
  bool ok;
  String msg;
  T result;

  ApiResponse.ok(this.result) { //named contructor
    ok = true;
  }

  ApiResponse.error(this.msg) { //named contructor
    ok = false;
  }

}