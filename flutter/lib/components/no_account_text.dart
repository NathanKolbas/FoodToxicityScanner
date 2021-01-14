import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/home/home_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_up/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Sign Up ",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: Theme.of(context).primaryColor),
          ),
        ),
        Text(
          "or continue ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setBool('showSplashScreen', false);
              prefs.setBool('skipSignin', true);
            });

            Navigator.pushNamed(context, HomeScreen.routeName);
          },
          child: Text(
            "without an account.",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
