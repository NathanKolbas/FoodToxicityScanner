import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/constants.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:food_toxicity_scanner/screens/signed_in/components/waves.dart';

import '../size_config.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => new _LoadingState();
}

class _LoadingState extends State<Loading> {
  final loadingTexts = [
    'Loading, please wait   ',
    'Loading, please wait.  ',
    'Loading, please wait.. ',
    'Loading, please wait...',
  ];
  int startingPosition = 0;
  String loadingText;
  Timer timer;
  Widget takingTooLong = Container();
  Duration tooLongTime = new Duration(seconds: 3);
  Timer tooLongTimer;

  @override
  void initState() {
    super.initState();
    startingPosition = 0;
    loadingText = loadingTexts[startingPosition];
    animateLoading();
    takingTooLongTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    tooLongTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Need to initialize on the start screen
    SizeConfig().init(context);

    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Text(
          loadingText,
          style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 10,),
          AnimatedSwitcher(duration: kAnimationDuration, child: takingTooLong,),
          Spacer(), // This will put the waves at the bottom
          Waves(),
        ],
      ),
    );
  }

  void takingTooLongTimer() {
    tooLongTimer = new Timer(tooLongTime, () {
      setState(() {
        takingTooLong = Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'Taking too long? ',
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, SignInScreen.routeName),
              child: Text(
                "Sign-in",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      });
    });
  }

  void animateLoading() {
    timer = new Timer(const Duration(milliseconds: 350), () {
      ++startingPosition;
      if (startingPosition == loadingTexts.length) startingPosition = 0;

      setState(() {
        loadingText = loadingTexts[startingPosition];
      });
      animateLoading();
    });
  }
}
