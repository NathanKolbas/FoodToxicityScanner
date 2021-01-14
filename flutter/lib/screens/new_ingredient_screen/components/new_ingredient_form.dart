import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/async_button.dart';
import 'package:food_toxicity_scanner/components/form_error.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/ingredient.dart';
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/not_authorized_screen/not_authorized_screen.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class NewIngredientForm extends StatefulWidget {
  final String name;
  final String description;

  NewIngredientForm({
    Key key,
    this.name,
    this.description
  }) : super(key: key);

  @override
  _NewIngredientFormState createState() => _NewIngredientFormState();
}

class _NewIngredientFormState extends State<NewIngredientForm> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String description;
  String safetyRating;
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
  void initState() {
    super.initState();
    name = widget.name;
    description = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildIngredientNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildIngredientDescriptionFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildIngredientSafetyFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          AsyncButton(
            text: 'Add',
            successText: 'Ingredient added',
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                clearErrors();

                try {
                  Ingredient ingredient = new Ingredient(
                    name: name,
                    description: description,
                    safetyRating: safetyRating,
                  );
                  Ingredient response = await Api.Ingredient.createIngredient(ingredient, Provider.of<User>(context, listen: false).token);
                  // Now show the ingredient

                  return true;
                  // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
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

  TextFormField buildIngredientNameFormField() {
    return TextFormField(
      initialValue: name,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kIngredientNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return kIngredientNameNullError;
        }
        return null;
      },
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: "Ingredient name",
        hintText: "Enter the name of the ingredient",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField buildIngredientDescriptionFormField() {
    return TextFormField(
      initialValue: description,
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kIngredientDescriptionNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return kIngredientDescriptionNullError;
        }
        return null;
      },
      maxLines: 5,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: "Ingredient description",
        hintText: "Enter information about the ingredient",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: Icon(Icons.description),
      ),
    );
  }

  Widget buildIngredientSafetyFormField() {
    final safetyNames = Ingredient.safetyRatingEnum.keys;
    // This is also the default value
    safetyRating = safetyNames.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Rating:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8,),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DropdownButtonFormField(
              value: safetyRating,
              hint: Text('Safety rating'),
              onChanged: (String newValue) {
                setState(() {
                  safetyRating = newValue;
                });
              },
              items: safetyNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Image.asset(Ingredient.safetyRatingPicture[Ingredient.safetyRatingEnum[value]], scale: 3.5,),
                      SizedBox(width: 16,),
                      Text("${value[0].toUpperCase()}${value.substring(1)}"),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        ),
      ],
    );
  }
}
