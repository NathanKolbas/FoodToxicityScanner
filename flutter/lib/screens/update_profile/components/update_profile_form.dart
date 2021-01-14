import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/async_button.dart';
import 'package:food_toxicity_scanner/components/default_button.dart';
import 'package:food_toxicity_scanner/components/form_error.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/user.dart' as Model;
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/not_authorized_screen/not_authorized_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class UpdateProfileForm extends StatefulWidget {
  final Model.User user;

  UpdateProfileForm({this.user});

  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  Model.User signedInUser;
  Model.User user;
  String name;
  String email;
  bool updatePassword = false;
  String password;
  String confirmPassword;
  bool admin = false;
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
    signedInUser = Provider.of<User>(context);
    user = widget.user;
    admin = user.admin;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text("ID: ${user.id}", style: TextStyle(color: Colors.grey, fontSize: 14.0,),),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildUpdatePasswordField(),
          buildAdminField(context),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          AsyncButton(
            text: 'Update',
            successText: 'User updated',
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                clearErrors();

                try {
                  await Api.User.updateUser(
                    user.id,
                    signedInUser.token,
                    name: name,
                    email: email,
                    password: password,
                    admin: admin,
                  );
                  // If the user that is currently signed in is updating themselves,
                  // then make sure to update their profile.
                  if (signedInUser.id == user.id) {
                    Provider.of<User>(context, listen: false).updateFromUser(await Api.User.getUser(token: signedInUser.token));
                  }
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
                } on Api.AuthException catch(e) {
                  // Not authorized
                  if (e.cause["error_code"] == Api.Auth.NOT_AUTHORIZED) {
                    // Go to not authorized screen
                    Navigator.pushNamed(context, NotAuthorizedScreen.routeName);
                  } else {
                    // Have the user sign in
                    Navigator.pushNamed(context, SignInScreen.routeName);
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

  Widget buildAdminField(final builderContext) {
    // Check if the signed in user has admin permissions
    bool signedInUserIsAdmin = signedInUser.admin;

    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return signedInUserIsAdmin ? Column(
        children: [
          CheckboxListTile(
            title: Text('Admin'),
            contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
            value: admin,
            onChanged: (bool value) {
              setState(() {
                admin = value;
              });
            },
          ),
        ],
      ) : Column();
    },
    );
  }

  Widget buildUpdatePasswordField() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          CheckboxListTile(
            title: Text('Update password?'),
            contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
            value: updatePassword,
            onChanged: (bool value) {
              setState(() {
                updatePassword = value;
              });
            },
          ),
          AnimatedSwitcher(
            duration: kAnimationDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(sizeFactor: animation, child: child,);
            },
            child: updatePassword ? Column(
              key: UniqueKey(),
              children: [
                // Padding needed so the password text isn't clipped when highlighted
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: buildPasswordFormField(),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildConformPassFormField(),
              ],
            ) : Column(),
          ),
        ],
      );
    },
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      initialValue: user.name,
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
          return kPassNullError;
        } else if ((password != value)) {
          return kMatchPassError;
        }
        return null;
      },
      buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused,}) {
        return currentLength < 6 ? Text("${6 - currentLength} more character(s) needed") : Container();
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
          return kPassNullError;
        } else if (value.length < 6) {
          return kShortPassError;
        }
        return null;
      },
      buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused,}) {
        return currentLength < 6 ? Text("${6 - currentLength} more character(s) needed") : Container();
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
      initialValue: user.email,
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
