import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/constants.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:food_toxicity_scanner/size_config.dart';

import '../components/welcome_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map> splashData = [
    {
      "text": "What's This?",
      "description": "A quick and easy way to learn about the ingredients in your food.",
      "image": "assets/icons/food_and_restaurant.svg",
      "color": Colors.blue
    },
    {
      "text": "It's Really Easy",
      "description": "Simply point your camera at the ingredients label.",
      "image": "assets/icons/crop_free.svg",
      "color": Colors.pinkAccent
    },
    {
      "text": "Ta Da!",
      "description": "We'll work the magic behind the scenes to tell you more about the ingredients on the label.",
      "image": "assets/icons/hat_and_magic_wand.svg",
      "color": Colors.green
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      color: splashData[currentPage]["color"],
      duration: defaultDuration,
      child: Column(
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 3,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: splashData.length,
              itemBuilder: (context, index) => WelcomeContent(
                image: splashData[index]["image"],
                text: splashData[index]['text'],
                description: splashData[index]['description'],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashData.length,
                          (index) => buildDot(index: index),
                    ),
                  ),
                  Spacer(flex: 3),
                  AnimatedSwitcher(
                    duration: defaultDuration,
                    child: currentPage == splashData.length - 1 ? SizedBox(
                      // Need key so AnimatedSwitcher knows the difference between the two that could be returned
                      key: Key('continueButton'),
                      width: double.infinity,
                      height: getProportionateScreenHeight(56),
                      child: OutlineButton(
                        onPressed: () => Navigator.pushNamed(context, SignInScreen.routeName),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                        highlightedBorderColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid
                        ),
                      ),
                    ) : SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(56),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.white : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
