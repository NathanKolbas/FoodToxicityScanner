import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class UserWelcomeText extends StatefulWidget {
  UserWelcomeText({Key key}) : super(key: key);

  @override
  _UserWelcomeText createState() => new _UserWelcomeText();
}

class _UserWelcomeText extends State<UserWelcomeText> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: getProportionateScreenWidth(28),
    );

    return SizeTransition(
      sizeFactor: _animation,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "Welcome ",
              style: textStyle,
            ),
            Hero(
              tag: 'userNameWelcome',
              flightShuttleBuilder: flightShuttleBuilder,
              child: Text(
                Provider.of<User>(context).name,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
            Text(
              "!",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
