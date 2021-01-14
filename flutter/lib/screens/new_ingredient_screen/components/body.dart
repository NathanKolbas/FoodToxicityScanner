import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/new_ingredient_screen/components/new_ingredient_form.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  final String name;
  final String description;

  Body({
    Key key,
    this.name,
    this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(28),
        ),
        child: NewIngredientForm(name: name, description: description,),
      ),
    );
  }
}
