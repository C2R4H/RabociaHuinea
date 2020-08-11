//Flutter Package
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Importing Widgets
import 'widgets/textfielddecoration.dart';
import 'widgets/slidetransition.dart';
import 'widgets/errordialog.dart';
import 'widgets/loading.dart';

//Importing Services
import '../services/authentication.dart';
import '../services/database.dart';
import '../services/cache.dart';

//Importing Views
import 'register.dart';

//Importing models
import '../models/localuser.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  //Variables
  QuerySnapshot snapshotUserInfo;
  bool isLoading = false;

  //Initialising Firebase Cloud Services
  DatabaseMethods databaseMethods = DatabaseMethods();
  //Initialising Firebase Authentication Services
  AuthMethods authMethods = AuthMethods();

  //Text Field Controllers
  final formKey = GlobalKey<FormState>();

  //Text Editing Controllers are used for retrieving text from Text Field
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  //Main login function
  login_function() async {
    if (formKey.currentState.validate()) {
      //Showing Loading Screen
      setState(() {
        isLoading = true;
      });

      //User Authentication services to validate email and password
      await authMethods
          .loginEmailAndPassword(
              emailTextController.text, passwordTextController.text)
          .then((val) {
        if (!val) {
          //Retrieving user data from cloud firebase
          databaseMethods.getUserByEmail(emailTextController.text).then((val) {
            //We are saving the snapshot in a variable
            snapshotUserInfo = val;
            String username = snapshotUserInfo.documents[0].data["name"];
            String email = snapshotUserInfo.documents[0].data["email"];

            //Caching username and email
            CacheMethods.cacheUserNameState(username);
            CacheMethods.cacheUserEmailState(email);

            //Saving user info in a local variable
            LocalUser localUser = LocalUser(
              username: username,
              email: email,
            );

            print("LOGIN:");
            print(localUser.username);
            print(localUser.email);

          });

          //Caching user logged in state
          CacheMethods.cacheUserLoggedInState(true);
          //We are changing screen to the home one
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          //Showing an Error Dialog
          showDialog(
            context: context,
            builder: (context) => errordialog(context),
            barrierDismissible: false,
          );
        }
      });

      //Stoping Showing Loading Screen
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? loading()
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
                        //Left to Right transition to Register Screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => register(),
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
                                text: 'Don\'t have an account ? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xff8e8e8e),
                                ),
                              ),
                              TextSpan(
                                text: 'Register now',
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
                        login_function();
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
                          'Login',
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
