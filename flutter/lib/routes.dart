import 'package:flutter/widgets.dart';
import 'package:food_toxicity_scanner/screens/camera/camera_screen.dart';
import 'package:food_toxicity_scanner/screens/home/home_screen.dart';
import 'package:food_toxicity_scanner/screens/new_ingredient_screen/new_ingredient_screen.dart';
import 'package:food_toxicity_scanner/screens/not_authorized_screen/not_authorized_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_up/sign_up_screen.dart';
import 'package:food_toxicity_scanner/screens/signed_in/signed_in_screen.dart';
import 'package:food_toxicity_scanner/screens/welcome/welcome_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignedInScreen.routeName: (context) => SignedInScreen(),
  CameraScreen.routeName: (context) => CameraScreen(),
  NotAuthorizedScreen.routeName: (context) => NotAuthorizedScreen(),
  NewIngredientScreen.routeName: (context) => NewIngredientScreen(),
};
