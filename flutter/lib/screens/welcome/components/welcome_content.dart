import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({
    Key key,
    this.text,
    this.description,
    this.image,
  }) : super(key: key);
  final String text, description, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(40),
              vertical: getProportionateScreenWidth(10)
          ),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2),
        SvgPicture.asset(
          image,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
