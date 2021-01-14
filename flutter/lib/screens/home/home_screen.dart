import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    // Need to initialize on the start screen
    SizeConfig().init(context);
    return Body();
  }
}
