import 'package:flutter/material.dart';

import 'components/body.dart';

class NewIngredientScreen extends StatelessWidget {
  static String routeName = "/new_ingredient";
  final String name;
  final String description;

  NewIngredientScreen({
    Key key,
    this.name,
    this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Ingredient"),
      ),
      body: Body(name: name, description: description),
    );
  }
}
