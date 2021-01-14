import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/async_button.dart';
import 'package:food_toxicity_scanner/components/form_error.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/user.dart' as Model;
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/sign_up/sign_up_screen.dart';
import 'package:food_toxicity_scanner/screens/signed_in/signed_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shop_app/screens/login_success/login_success_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void clearErrors() {
    setState(() {
      errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          AsyncButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                clearErrors();

                try {
                  Model.User user = await Api.User.signIn(email, password);
                  Provider.of<User>(context, listen: false).updateFromUser(user);

                  Navigator.pushNamed(context, SignedInScreen.routeName);

                  // Don't show the splash screen anymore after first sign-in and reset the "continue without account"
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool('showSplashScreen', false);
                    prefs.setBool('skipSignin', false);
                  });
                  return true;
                } on SocketException {
                  addError(error: 'Unable to connect to server. Please check your internet connection.');
                } on Api.ApiException catch(e) {
                  if (e.cause.containsKey('message')) {
                    addError(error: e.cause['message']);
                  } else if (e.cause.containsKey('error')) {
                    e.cause['error'].forEach((k, v) => addError(error: '${k[0].toUpperCase()}${k.substring(1)} $v'));
                  } else {
                    print(e);
                    addError(error: 'An unknown error occurred');
                  }
                } catch(e) {
                  print(e);
                  addError(error: 'An unknown error occurred');
                }
              }
              return false;
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return kPassNullError;
        } else if (value.length < 6) {
          return kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Icon(Icons.lock_outline),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Icon(Icons.mail_outline),
      ),
    );
  }
}
