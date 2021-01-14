import 'package:flutter/material.dart';

import 'components/body.dart';

class SignedInScreen extends StatelessWidget {
  static String routeName = "/signed_in";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
