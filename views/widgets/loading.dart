import 'package:flutter/material.dart';

class loading extends StatefulWidget{
  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<loading>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text('Loading...'),
                ],
                ),
            ),
        );
  }
}
