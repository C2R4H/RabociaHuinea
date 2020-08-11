import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cache.dart';
import '../models/user.dart';

class AuthMethods {

  //Initializing cache methods
  CacheMethods cacheMethods = CacheMethods(); 

  //Defining a shorter variable for Firebase Authentication Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool error = false;

  //Its checking if the user is having some information and is returning user id
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //This function is used for Creating a new user
  Future registerEmailAndPassword(String email, String password) async {
    try {
      //Conecting to the firebase authentiction system and we are creating a new user
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((val) {
        //We are checking if the variable has data
        if (val.user != null) {
          FirebaseUser firebaseUser = val.user;
          error = false;
        } else {
          error = true;
        }
      });
    } catch (e) {
      print(e.toString());
      //We are handling errors
      error = true;
    }
    return error;
  }

  //This function is used for Login a user
  Future loginEmailAndPassword(String email, String password) async {
    try {
      //Conecting to the firebase authentiction system and we are creating a new user
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((val) {
        //We are checking if the variable has data
        if (val.user != null) {
          FirebaseUser firebaseUser = val.user;
          error = false;
        } else {
          error = true;
        }
      });
    } catch (e) {
      print(e.toString());
      //We are handling errors
      error = true;
    }
    return error;
  }

  //This function is used to logout
  Future logout() async {
    try {

      //We are saying to the cache system that no user is logged in
      CacheMethods.cacheUserLoggedInState(false);

      //I don't know what we are returning , but its working :)
      return await _auth.signOut();

    } catch (e) {

      //Printing erros in the console
      print(e.toString());
    }
  }
}
