import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/home/home_screen.dart';

IconButton homeAppbarButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.home),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (r) => false);
    },
  );
}
