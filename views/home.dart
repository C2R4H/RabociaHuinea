import 'package:flutter/material.dart';
import '../services/authentication.dart';


//
//THIS HOME SCREEN IN NOT WORKING PROPERLY
//



class home extends StatelessWidget {

  AuthMethods authMethods = AuthMethods();


  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
            child: FlatButton(
                onPressed: () {
                  authMethods.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Logout'),
                ),
            ),
        );
  }
}
