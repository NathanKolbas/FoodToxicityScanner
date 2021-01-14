import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/welcome/components/body.dart';
import 'package:food_toxicity_scanner/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    // Need to initialize on the start screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
