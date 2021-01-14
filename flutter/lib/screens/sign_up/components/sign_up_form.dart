import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/async_button.dart';
import 'package:food_toxicity_scanner/components/default_button.dart';
import 'package:food_toxicity_scanner/components/form_error.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/user.dart' as Model;
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/signed_in/signed_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  String password;
  String confirmPassword;
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
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          AsyncButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                clearErrors();

                try {
                  Model.User user = await Api.User.signUp(name, email, password);
                  Provider.of<User>(context, listen: false).updateFromUser(user);

                  Navigator.pushNamed(context, SignedInScreen.routeName);

                  // Don't show the splash screen anymore after first sign-up and reset the "continue without account"
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

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          // addError(error: kNameNullError);
          return kNameNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          // addError(error: kPassNullError);
          return kPassNullError;
        } else if ((password != value)) {
          // addError(error: kMatchPassError);
          return kMatchPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Icon(Icons.lock_outline),
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
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          // addError(error: kPassNullError);
          return kPassNullError;
        } else if (value.length < 6) {
          // addError(error: kShortPassError);
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
          // addError(error: kEmailNullError);
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          // addError(error: kInvalidEmailError);
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
