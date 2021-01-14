import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/home_appbar_button.dart';
import 'package:food_toxicity_scanner/models/ingredient.dart';
import 'package:food_toxicity_scanner/models/user.dart';

import 'components/body.dart';

class ViewIngredientScreen extends StatelessWidget {
  final Ingredient ingredient;
  final UniqueKey heroKey;
  final User createdBy;

  ViewIngredientScreen({
    Key key,
    @required
    this.ingredient,
    this.heroKey,
    this.createdBy,
  }) : assert(ingredient != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredient"),
        actions: [
          homeAppbarButton(context),
        ],
      ),
      body: Body(ingredient: ingredient, heroKey: heroKey, createdBy: createdBy),
    );
  }
}
