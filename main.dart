import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'services/cache.dart';

import 'views/widgets/loading.dart';
import 'views/register.dart';
import 'views/home.dart';
import 'views/login.dart';

void main() => runApp(Usershop());

class Usershop extends StatefulWidget {
  @override
  _UsershopState createState() => _UsershopState();
}

class _UsershopState extends State<Usershop> {
  //Initializing cache services
  bool isLoggedIn = false;

  //We are retrieving from the cache user logged in state
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await CacheMethods.getCachedUserLoggedInState().then((val) {
      if (isLoggedIn != null) {
        setState(() {
          isLoggedIn = val;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //We are naming screens to acces them easier in the app
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/register':
            return PageTransition(
                child: register(), type: PageTransitionType.leftToRight);
            break;
          case '/login':
            return PageTransition(
                child: login(), type: PageTransitionType.leftToRight);
            break;
          case '/home':
            return PageTransition(
                child: home(), type: PageTransitionType.rightToLeft);
            break;
          default:
            return null;
        }
      },

      //If is logged in we will show the home screen, or we will show the login screen
      home: isLoggedIn ? home() : login(),
    );
  }
}
