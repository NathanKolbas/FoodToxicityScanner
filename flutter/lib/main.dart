import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/routes.dart';
import 'package:food_toxicity_scanner/screens/home/home_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:food_toxicity_scanner/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/loading.dart';
import 'models/user.dart';

void main() {
  runApp(_MyAppMain());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}

class _MyAppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>.value(value: new User(),),
      ],
      child: Consumer<User>(
        builder: (BuildContext context, userProvider, _) {
          // Each time the app is built or a notifyListeners() is called then this is ran
          return FutureBuilder(
            future: setup(context),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  // MaterialApp is needed for MediaQuery
                  child: MaterialApp(home: Loading(),),
                );
              }

              Widget initialScreen = snapshot.data;

              return MaterialApp(
                title: 'Food Toxicity Scanner',
                theme: ThemeData(
                  primarySwatch: Colors.green,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: initialScreen,
                routes: routes,
              );
            },
          );
        },
      ),
    );
  }

  Future<Widget> setup(BuildContext context) async {
    final User user = Provider.of<User>(context, listen: false);
    Widget initialScreen = HomeScreen();

    // If the user is already signed in then don't try logging them in
    if (user.id != null) return initialScreen;

    // Check if first time opening app or the user does not want to sign in
    final prefs = await SharedPreferences.getInstance();
    bool showSplashScreen = prefs.getBool('showSplashScreen') ?? true;
    bool skipSignin = prefs.getBool('skipSignin') ?? false;

    if (showSplashScreen) return SplashScreen();

    if (!skipSignin) {
      final User signedInUser = await User.getSignedIn();

      if (signedInUser.id == null) {
        // If the id is null then the user is not signed in
        initialScreen = SignInScreen();
      } else {
        user.updateFromUser(signedInUser);
      }
    }

    return initialScreen;
  }
}
