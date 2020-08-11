//Shared Preferences is a package that enables us to cache easy data
import 'package:shared_preferences/shared_preferences.dart';

class CacheMethods {

  //
  //Saving data to the cache
  //

  //This are the keys used to classific data
  static String cacheUserLoggedInKey = "ISLOGGEDIN";
  static String cacheUserNameKey = "USERNAMEKEY";
  static String cacheUserEmailKey = "USEREMAILKEY";

  //We save a bool variable that will say if the user is logged in or not
  static Future<bool> cacheUserLoggedInState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(cacheUserLoggedInKey, isLoggedIn);
  }

  //Caching the username
  static Future<bool> cacheUserNameState(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cacheUserNameKey, username);
  }

  //Caching the email
  static Future<bool> cacheUserEmailState(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cacheUserEmailKey, email);
  }

  //
  //Retrieving data from the cache
  //

  //Retrieving the bool logged in state
  static Future<bool> getCachedUserLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(cacheUserLoggedInKey);
  }

  //Retrieving the username
  static Future<String> getCachedUserNameState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(cacheUserNameKey);
  }

  //Retrieving the email
  static Future<String> getCachedUserEmailState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(cacheUserEmailKey);
  }
}
