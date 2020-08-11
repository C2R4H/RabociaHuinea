import 'package:flutter/material.dart';


AlertDialog errordialog(BuildContext context){
  return AlertDialog(
      title: Text('Error'),
      content: Text('Please check your email or password'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
            ),
      ],
      );
}

AlertDialog usernameerror(BuildContext context){
  return AlertDialog(
      title: Text('Error'),
      content: Text('Username is already used by someone'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
            ),
      ],
      );
}
