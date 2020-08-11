//Main Flutter Package
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Widgets
import 'widgets/textfielddecoration.dart';
import 'widgets/errordialog.dart';
import 'widgets/slidetransition.dart';

//Services
import '../services/authentication.dart';
import '../services/database.dart';
import '../services/cache.dart';

//Views
import 'home.dart';
import 'login.dart';

//Models
import '../models/localuser.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  QuerySnapshot userInfoSnapshot;
  bool loading = false;

  //Initialising Firebase Authentication Services
  AuthMethods authMethods = AuthMethods();
  //Initialising Firebase Database Services
  DatabaseMethods databaseMethods = DatabaseMethods();
  //Initialising Cache Method Services
  CacheMethods cacheMethods = CacheMethods();

  //Form key is used to validate the text in the Text Fields
  final formKey = GlobalKey<FormState>();

  //Text editing controllers to retrive data for Text Fields
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  //Main register function
  register_function() async {
    bool stop = false;

    //We are showing the loading screen
    setState(() {
      loading = true;
    });

    //We are validating the form key and calling the authmethods services
    if (formKey.currentState.validate()) {
      String username = ".";
      //We are checking if the username is in already used
      await databaseMethods
          .doesNameAlreadyExist(usernameTextController.text)
          .then((val) {

        //If val doesnt have data it means that the username is not used
        if (val) {
          setState(() {
            stop = true;
            loading = false;
          });
          showDialog(
            context: context,
            builder: (context) => usernameerror(context),
            barrierDismissible: false,
          );
        }
      });

      if (!stop) {
        await authMethods
            .registerEmailAndPassword(
                emailTextController.text, passwordTextController.text)
            .then((val) {
          if (!val) {
            //We are mapping data to upload on the firebase cloud services
            Map<String, dynamic> userDataMap = {
              "name": usernameTextController.text,
              "email": emailTextController.text,
              "picture": "",
              "registered": DateTime.now().millisecondsSinceEpoch,
            };

            //We are uploading mapped date to the cloud
            databaseMethods.uploadUser(userDataMap);

            //We are saving to cache data
            CacheMethods.cacheUserLoggedInState(true);
            CacheMethods.cacheUserNameState(usernameTextController.text);
            CacheMethods.cacheUserEmailState(emailTextController.text);

            //We are navigating to the home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            //Showing a dialog with error details
            showDialog(
              context: context,
              builder: (context) => errordialog(context),
              barrierDismissible: false,
            );
          }
        });

        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Container()
          : Container(
              margin: EdgeInsets.all(30),
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Usershop',
                        style: TextStyle(
                          color: Color(0xff8e8e8e),
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xff8e8e8e),
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (val) {
                              return val.length > 4
                                  ? null
                                  : "Please provide a valid Username";
                            },
                            controller: usernameTextController,
                            decoration: textfielddecoration('Username'),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xff8e8e8e),
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please provide a valid Email";
                            },
                            controller: emailTextController,
                            decoration: textfielddecoration('Email'),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xff8e8e8e),
                              ),
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Please provide a valid Password";
                            },
                            controller: passwordTextController,
                            decoration: textfielddecoration('Password'),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => login(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Color(0xff8e8e8e),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Already have an account ? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xff8e8e8e),
                                ),
                              ),
                              TextSpan(
                                text: 'Login now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xff74B4FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        register_function();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xffffba1d),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Center(
                      child: Text(
                        'Userapps',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8e8e8e),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
