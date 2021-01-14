import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/home/home_screen.dart';
import 'package:food_toxicity_scanner/screens/signed_in/components/user_welcome_text.dart';
import 'package:food_toxicity_scanner/screens/signed_in/components/waves.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => new _Body();
}

class _Body extends State<Body> {
  @override
  void initState() {
    super.initState();
    new Timer(const Duration(seconds: 2), () => Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (r) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          UserWelcomeText(),
          Spacer(), // This will put the waves at the bottom
          Waves(),
        ],
      ),
    );
  }
}
