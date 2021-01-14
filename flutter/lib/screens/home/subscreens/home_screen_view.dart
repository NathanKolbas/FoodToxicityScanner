import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/default_button.dart';
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/home/components/semicircle_animated_path.dart';
import 'package:food_toxicity_scanner/screens/new_ingredient_screen/new_ingredient_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:food_toxicity_scanner/screens/update_profile/update_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

import '../../../size_config.dart';

class HomeScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    final _userName = Align(
      alignment: Alignment.topLeft,
      child: Hero(
        tag: 'userNameWelcome',
        flightShuttleBuilder: flightShuttleBuilder,
        child: Text(
          user.name ?? 'Sign-in',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: getProportionateScreenWidth(28),
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(28),
        ),
        child: Column(
          children:
            Provider.of<User>(context).id == null ?
              [
                _userName,
                SizedBox(height: SizeConfig.screenHeight / 3),
                DefaultButton(
                  text: 'Sing-in',
                  press: () => Navigator.pushNamed(context, SignInScreen.routeName),
                )
              ]
            :
              [
                _userName,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                    if (user.admin ?? false)
                      Row(
                        children: [
                          Icon(
                              Icons.shield,
                              size: 16.0,
                              color: Colors.grey
                          ),
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: getProportionateScreenWidth(14),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 75.0,),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Used so things can be pressed; if needed later
                    IgnorePointer(
                      child: SemicircleAnimatedPath(
                          strokeColor: Theme.of(context).primaryColorLight,
                          strokeWidth: 10.0
                      ),
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 123),
                      duration: Duration(seconds: 1),
                      curve: Curves.decelerate,
                      builder: (BuildContext context, double _val, Widget child) {
                        return Text(
                          _val.toInt().toString(),
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(64),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Text(
                  'Your Contributions',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                  ),
                ),
                SizedBox(height: 42.0,),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Contribute new ingredient", style: TextStyle(color: Colors.white),),
                      SizedBox(width: 8.0),
                      Icon(Icons.add, color: Colors.white,),
                    ],
                  ),
                  onPressed: () {
                    if (user.loggedInCheck(context)) Navigator.pushNamed(context, NewIngredientScreen.routeName);
                  },
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Update your profile", style: TextStyle(color: Colors.white),),
                      SizedBox(width: 8.0),
                      Icon(Icons.person, color: Colors.white,),
                    ],
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen(user.id),
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Logout", style: TextStyle(color: Colors.white),),
                      SizedBox(width: 8.0),
                      Icon(Icons.logout, color: Colors.white,),
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Provider.of<User>(context, listen: false).signOut(context);
                    Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (r) => false);
                  },
                ),
              ]
        ),
      ),
    );
  }
}
