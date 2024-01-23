import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String UserTable = 'User';
const String UserId = 'id';
const String UserIdentityNumber = 'identityNumber';
const String UserNameSurname = 'nameSurname';
const String UserPhone = 'phone';
const String UserEmail = 'eMail';
const String UserIsDeleted = 'isDeleted';

const String UnitTable = 'Unit';
const String UnitId = 'id';
const String UnitName = 'name';

showToast(String string) {
  Fluttertoast.showToast(
      msg: string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0);
}

showProgress() {
  return ProgressHUD(
      backgroundColor: Colors.black12,
      indicatorColor: Colors.white,
      barrierColor: Colors.black38,
      backgroundRadius: const Radius.circular(5.0),
      child: const Text('Loading...')
  );
}