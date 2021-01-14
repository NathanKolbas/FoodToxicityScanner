import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/models/ingredient.dart';

import '../../../size_config.dart';
import 'edit_ingredient_form.dart';

class Body extends StatelessWidget {
  final Ingredient ingredient;

  Body({
    Key key,
    @required
    this.ingredient,
  }) : assert(ingredient != null),
        super(key: key);

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
        child: EditIngredientForm(ingredient: ingredient,),
      ),
    );
  }
}
