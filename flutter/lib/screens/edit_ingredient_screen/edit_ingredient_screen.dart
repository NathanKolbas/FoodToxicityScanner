import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/models/ingredient.dart';

import 'components/body.dart';

class EditIngredientScreen extends StatelessWidget {
  final Ingredient ingredient;

  EditIngredientScreen({
    Key key,
    @required
    this.ingredient,
  }) : assert(ingredient != null),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Ingredient"),
      ),
      body: Body(ingredient: ingredient),
    );
  }
}
