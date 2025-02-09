import 'package:flutter/material.dart';

alertDialogWidget(
  BuildContext context, {
  required String title,
  required String content,
  String action = "OK",
  required onConfirm,
}) {

  Widget okButton = TextButton(
    onPressed: onConfirm,
    child: Text(action),
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
